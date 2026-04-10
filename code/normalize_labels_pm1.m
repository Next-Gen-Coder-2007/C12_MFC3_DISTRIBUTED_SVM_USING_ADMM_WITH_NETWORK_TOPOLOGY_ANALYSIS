function [y_pm1, mapping] = normalize_labels_pm1(y)
% Map a binary label vector to {-1,+1}.
    y = y(:);
    ut = unique(y);
    if numel(ut) ~= 2
        error('normalize_labels_pm1: dataset must be binary; found %d classes.', numel(ut));
    end
    neg = ut(1); pos = ut(2);
    y_pm1 = double(y);
    y_pm1(y == neg) = -1; y_pm1(y == pos) = +1;
    mapping = struct('neg', neg, 'pos', pos);
end
