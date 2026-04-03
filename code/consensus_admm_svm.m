function [model, info] = consensus_admm_svm(X, y, A, rho, C, gamma, maxIters, tol_pri, tol_dual)
% CONSENSUS_ADMM_SVM
% Decentralized consensus-ADMM SVM using Random Fourier Features (RBF approximation).
% - Each node j solves a local LS-SVM/Ridge subproblem in its RFF space.
% - Consensus is enforced via a one-hop neighbor mixing with a
%   Metropolis-Hastings weight matrix W = W(A).
% - The ADMM stopping test follows Boyd et al. with absolute/relative tolerances.
%
% Inputs:
%   X (N x d)      : data
%   y (N x 1)      : labels in {-1,+1}
%   A (J x J)      : adjacency (undirected, connected)
%   rho            : ADMM penalty
%   C              : regularization (LS-SVM / ridge style)
%   gamma          : RBF kernel width parameter (k(x,z)=exp(-gamma*||x-z||^2))
%   maxIters       : maximum ADMM iterations
%   tol_pri        : absolute tolerance (ABSTOL)
%   tol_dual       : relative tolerance (RELTOL)
%
% Outputs:
%   model: struct with fields
%       .type     = 'rff_admm'
%       .Omega    : (d x D) random projection matrix
%       .bRFF     : (1 x D) random phases
%       .w        : (D+1 x 1) primal (last entry is bias)
%       .rff_dim  : D (number of RFFs)
%       .gamma    : RBF gamma used to build features
%
%   info: struct with
%       .iters       : iterations performed
%       .converged   : true/false
%       .r_hist      : primal residual norm per iter
%       .s_hist      : dual   residual norm per iter
%       .times       : elapsed time per iter
%       .W           : mixing matrix used

% ------------------- Basic setup -------------------
rng(7);                      % reproducibility
y = y(:);
[N, d] = size(X);
J      = size(A,1);
parts  = partition_indices(N, J);   % disjoint partition across nodes

% Tolerances in Boyd's notation
ABSTOL = tol_pri;
RELTOL = tol_dual;

% ------------------- Random Fourier Features -------------------
% RBF: k(x,z)=exp(-gamma*||x-z||^2)
% RFF: w ~ N(0, 2*gamma I), b ~ U(0, 2*pi)
% phi(x) = sqrt(2/D) * cos(X*Omega + b)
rff_dim = 500;                             % you can tune (200–1000 reasonable)
Omega   = sqrt(2*gamma) * randn(d, rff_dim);
bRFF    = 2*pi * rand(1, rff_dim);

Phi     = sqrt(2/rff_dim) * cos(X*Omega + repmat(bRFF, N, 1));
Phi_aug = [Phi, ones(N,1)];               % (bias as last coord)
Dp      = rff_dim + 1;                    % feature dimension including bias

% ------------------- Mixing matrix from topology -------------------
W = metropolis_weights(A);                 % symmetric, row-stochastic

% ------------------- Allocate per-node variables -------------------
w      = cell(J,1);   % local primal (Dp x 1)
z      = cell(J,1);   % local consensus copy (Dp x 1)
u      = cell(J,1);   % scaled dual (Dp x 1)
G      = cell(J,1);   % Phi_j'Phi_j
h      = cell(J,1);   % Phi_j' y_j
Lchol  = cell(J,1);   % Cholesky factors for (1+rho)I + C*Phi_j'Phi_j
Minv   = cell(J,1);   % fallback inverses if Cholesky fails

use_chol_global = true;

for j = 1:J
    idx  = parts{j};
    PhiJ = Phi_aug(idx, :);                % n_j x Dp
    yj   = y(idx);

    % Precompute Gram and RHS
    G{j} = PhiJ' * PhiJ;                   % Dp x Dp
    h{j} = PhiJ' * yj;                     % Dp x 1

    % Initialization
    w{j} = zeros(Dp,1);
    z{j} = zeros(Dp,1);
    u{j} = zeros(Dp,1);

    % Factorize local system:
    % (1+rho)*I + C * (Phi_j' Phi_j)
    Mj = (1 + rho)*eye(Dp) + C * G{j};

    if use_chol_global
        [Lj, p] = chol(Mj, 'lower');
        if p == 0
            Lchol{j} = Lj;
            Minv{j}  = [];
        else
            % if any node fails PD test, disable chol globally
            use_chol_global = false;
        end
    end
end

% If any node failed PD test, invert all Mj (safe but a bit slower)
if ~use_chol_global
    for j = 1:J
        Mj = (1 + rho)*eye(Dp) + C * G{j};
        Minv{j} = inv(Mj);
        Lchol{j} = [];
    end
end

% ------------------- ADMM iterations -------------------
converged = false;
r_hist = zeros(maxIters,1);
s_hist = zeros(maxIters,1);
t_hist = zeros(maxIters,1);

for k = 1:maxIters
    t0 = tic;

    % (1) Local w-update: closed-form ridge solution
    for j = 1:J
        rhs = C*h{j} + rho * ( z{j} - u{j} );   % Dp x 1

        if ~isempty(Lchol{j})
            % Solve Mj * wj = rhs via Cholesky (L L' w = rhs)
            wj = Lchol{j} \ (Lchol{j}' \ rhs);
        else
            wj = Minv{j} * rhs;
        end
        w{j} = wj;
    end

    % (2) Decentralized z-update: single round of neighbor mixing
    z_prev = z;
    v = cellfun(@(wj,uj) (wj + uj), w, u, 'UniformOutput', false);  % v_j = w_j + u_j

    z_new = cell(J,1);
    for j = 1:J
        acc = zeros(Dp,1);
        for l = 1:J
            if W(j,l) ~= 0
                acc = acc + W(j,l) * v{l};
            end
        end
        z_new{j} = acc;
    end
    z = z_new;

    % (3) Dual update: u_j := u_j + (w_j - z_j)
    for j = 1:J
        u{j} = u{j} + (w{j} - z{j});
    end

    % (4) Residuals and stopping criteria (Boyd et al.)
    % Stack all vectors to compute Frobenius norms
    Wmat = cell2mat(w');      % Dp x J
    Zmat = cell2mat(z');      % Dp x J
    Umat = cell2mat(u');      % Dp x J
    Zprv = cell2mat(z_prev'); % Dp x J

    r = norm(Wmat - Zmat, 'fro');            % primal residual
    s = rho * norm(Zmat - Zprv, 'fro');      % dual residual

    % Tolerances scale with problem size
    nvars   = numel(Wmat);                   % J*Dp
    eps_pri = sqrt(nvars)*ABSTOL + RELTOL * max( norm(Wmat,'fro'), norm(Zmat,'fro') );
    eps_dual= sqrt(nvars)*ABSTOL + RELTOL * norm(Umat,'fro');

    r_hist(k) = r;
    s_hist(k) = s;
    t_hist(k) = toc(t0);

    if (r <= eps_pri) && (s <= eps_dual)
        converged = true;
        break;
    end
end

iters = k;

% ------------------- Aggregate the consensus model -------------------
% At convergence all z_j are equal; take their mean as the final model.
Zall  = cell2mat(z');
w_mean = mean(Zall, 2);        % (Dp x 1), last coordinate is bias

% ------------------- Pack outputs -------------------
model = struct();
model.type     = 'rff_admm';
model.Omega    = Omega;        % (d x rff_dim)
model.bRFF     = bRFF;         % (1 x rff_dim)
model.w        = w_mean;       % (Dp x 1) includes bias as last coord
model.rff_dim  = rff_dim;
model.gamma    = gamma;

info = struct();
info.iters     = iters;
info.converged = converged;
info.r_hist    = r_hist(1:iters);
info.s_hist    = s_hist(1:iters);
info.times     = t_hist(1:iters);
info.W         = W;

end

% =====================================================================
% Helpers
% =====================================================================
function parts = partition_indices(N, J)
% Disjoint partition of {1,...,N} into J contiguous blocks
sizes = floor(N/J) * ones(J,1);
rem = N - sum(sizes);
for t=1:rem
    sizes(t) = sizes(t) + 1;
end
parts = cell(J,1);
start = 1;
for j=1:J
    fin = start + sizes(j) - 1;
    parts{j} = (start:fin)';
    start = fin + 1;
end
end

function W = metropolis_weights(A)
% Symmetric Metropolis-Hastings mixing matrix (row/col stochastic)
J   = size(A,1);
deg = sum(A,2);
W   = zeros(J);
for i = 1:J
    for j = 1:J
        if A(i,j) ~= 0
            W(i,j) = 1 / (1 + max(deg(i), deg(j)));
        end
    end
end
for i = 1:J
    W(i,i) = 1 - sum(W(i,:));
end
end
