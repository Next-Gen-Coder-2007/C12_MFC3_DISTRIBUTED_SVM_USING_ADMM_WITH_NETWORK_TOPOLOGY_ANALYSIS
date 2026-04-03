function yscore = predict_svm_rbf(model, Xte)
% PREDICT_SVM_RBF
% - If model.type == 'rff_admm', use RFF + primal w.
% - Else, use kernel decision with alpha, training X/y, gamma, and bias b.
% - Robust to different field names (X vs Xtr, y vs ytr, alpha vs alpha_full).

% -----------------------------
% 1) Random Fourier Features path
% -----------------------------
if isfield(model, 'type') && strcmp(model.type, 'rff_admm')
    Omega  = model.Omega;     % d x D
    bRFF   = model.bRFF;      % 1 x D
    w      = model.w;         % (D+1) x 1
    D      = size(Omega, 2);

    Phi = sqrt(2/D) * cos(Xte * Omega + repmat(bRFF, size(Xte,1), 1));
    Phi_aug = [Phi, ones(size(Xte,1), 1)];
    yscore = Phi_aug * w;
    return;
end

% -----------------------------
% 2) Kernel (dual) decision path
% -----------------------------
% Try to obtain training features
if isfield(model, 'X')
    Xtr = model.X;
elseif isfield(model, 'Xtr')
    Xtr = model.Xtr;
else
    error('predict_svm_rbf: Model lacks X/Xtr for kernel prediction.');
end

% Try to obtain training labels
if isfield(model, 'y')
    ytr = model.y(:);
elseif isfield(model, 'ytr')
    ytr = model.ytr(:);
else
    error('predict_svm_rbf: Model lacks y/ytr for kernel prediction.');
end

% Alpha (dual variables)
if isfield(model, 'alpha')
    alpha = model.alpha(:);
elseif isfield(model, 'alpha_full')
    alpha = model.alpha_full(:);
else
    error('predict_svm_rbf: Model lacks alpha/alpha_full for kernel prediction.');
end

% Gamma and bias
if isfield(model, 'gamma')
    gamma = model.gamma;
elseif isfield(model, 'params') && isfield(model.params,'gamma')
    gamma = model.params.gamma;
else
    error('predict_svm_rbf: Model lacks gamma for kernel prediction.');
end

if isfield(model, 'b')
    b = model.b;
else
    b = 0;  % fallback if bias was not computed
end

% Compute decision yscore = K(Xte, Xtr) * (alpha .* ytr) + b
B = 5000; % block rows of Xte
yscore = zeros(size(Xte,1),1);
for s = 1:ceil(size(Xte,1)/B)
    r1 = (s-1)*B + 1;
    r2 = min(s*B, size(Xte,1));
    Kb = exp(-gamma * pdist2(Xte(r1:r2,:), Xtr, 'euclidean').^2);
    yscore(r1:r2) = (Kb * (alpha .* ytr)) + b;
end
end
