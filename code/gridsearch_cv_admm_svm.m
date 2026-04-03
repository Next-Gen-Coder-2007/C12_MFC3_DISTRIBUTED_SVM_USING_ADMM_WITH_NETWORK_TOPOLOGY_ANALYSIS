function [rho_best, JC_best, gamma_best] = gridsearch_cv_admm_svm(X, y, J, rho_grid, JC_grid, gamma_grid, cvFolds, tol_pri, tol_dual, maxIters)
% Simple K-fold CV on consensus ADMM SVM (simulated without graph, central split across J)
% For speed, we simulate consensus on a complete graph for CV only (hyperparam selection),
% since the paper selects (rho, JC, gamma) globally per dataset/graph setting via grid-search+CV.
% Final training uses the actual graph.
N = size(X,1);
cv = cvpartition(N, 'KFold', cvFolds);
bestScore = -inf;
rho_best = rho_grid(1);
JC_best  = JC_grid(1);
gamma_best = gamma_grid(1);

for r = 1:numel(rho_grid)
  for c = 1:numel(JC_grid)
    for g = 1:numel(gamma_grid)
        scores = zeros(cvFolds,1);
        C = JC_grid(c)/J;
        for fold = 1:cvFolds
            trIdx = training(cv,fold);
            teIdx = test(cv,fold);
            [model, info] = consensus_admm_svm(X(trIdx,:), y(trIdx), ones(J), rho_grid(r), C, gamma_grid(g), min(2000,maxIters), tol_pri, tol_dual); %#ok<ASGLU>
            yhat = predict_svm_rbf(model, X(teIdx,:));
            scores(fold) = mean(sign(yhat) == y(teIdx));
        end
        sc = mean(scores);
        if sc > bestScore
            bestScore = sc;
            rho_best = rho_grid(r);
            JC_best  = JC_grid(c);
            gamma_best = gamma_grid(g);
        end
    end
  end
end
end
