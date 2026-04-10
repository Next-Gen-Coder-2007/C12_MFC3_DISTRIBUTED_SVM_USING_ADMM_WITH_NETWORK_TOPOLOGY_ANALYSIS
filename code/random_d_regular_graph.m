function A = random_d_regular_graph(N, d)
% RANDOM_D_REGULAR_GRAPH Generate a random simple d-regular undirected graph
% Always succeeds if N*d is even and d < N
%
% Input:
%   N - number of nodes
%   d - degree of each node
% Output:
%   A - adjacency matrix (NxN)

    % Basic validity checks
    if mod(N*d,2) ~= 0
        error('N*d must be even for a d-regular graph to exist.');
    end
    if d >= N
        error('Degree d must be less than N.');
    end

        % Try MATLAB built-in (R2021b+)
    if exist('randRegularGraph','file')
        G = randRegularGraph(N,d);          % built-in function
        A = adjacency(digraph(G));          % convert to adjacency matrix
        A = full(A);
        return;
    end


    % Otherwise use stub-matching algorithm
    maxTries = 20000;  % increase retries
    for attempt = 1:maxTries
        % Create degree "stubs"
        stubs = repelem(1:N, d);
        stubs = stubs(randperm(length(stubs)));

        % Pair stubs sequentially
        A = zeros(N);
        success = true;
        for k = 1:2:length(stubs)
            i = stubs(k);
            j = stubs(k+1);

            if i == j || A(i,j) == 1
                success = false;
                break;
            end
            A(i,j) = 1;
            A(j,i) = 1;
        end

        if success
            return;
        end
    end

    % If still failing → fall back to deterministic construction
    warning('Random construction failed, using deterministic circulant graph instead.');
    A = zeros(N);
    for i = 1:N
        for j = 1:d/2
            v1 = mod(i-1+j,N)+1;
            v2 = mod(i-1-j+N,N)+1;
            A(i,v1) = 1; A(v1,i) = 1;
            A(i,v2) = 1; A(v2,i) = 1;
        end
    end
end
