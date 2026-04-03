function [Xtr, ytr, Xte, yte] = shuffled_split(D)
% Shuffle training set (only), keep test as provided.
idx = randperm(size(D.Xtr,1));
Xtr = D.Xtr(idx,:); ytr = D.ytr(idx);
Xte = D.Xte; yte = D.yte;
end
