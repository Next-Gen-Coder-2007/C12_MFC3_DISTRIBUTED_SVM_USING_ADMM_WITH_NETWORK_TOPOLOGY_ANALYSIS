function [XtrN, XteN] = normalize_if_needed(Xtr, Xte)
    % Ensure dense matrices (important for libsvm sparse data)
    Xtr = full(Xtr);
    Xte = full(Xte);

    % Align number of features (pad test set if fewer cols)
    if size(Xte,2) < size(Xtr,2)
        Xte(:, end+1:size(Xtr,2)) = 0;
    elseif size(Xte,2) > size(Xtr,2)
        Xtr(:, end+1:size(Xte,2)) = 0;
    end

    mu = mean(Xtr,1);
    sg = std(Xtr,[],1);
    sg(sg==0) = 1;   % avoid divide-by-zero

    XtrN = (Xtr - mu)./sg;
    XteN = (Xte - mu)./sg;
end
