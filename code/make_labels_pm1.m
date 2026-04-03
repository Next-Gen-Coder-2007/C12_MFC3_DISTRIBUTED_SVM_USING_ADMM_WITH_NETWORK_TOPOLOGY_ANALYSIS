function [ytr_pm1, yte_pm1, mapping] = make_labels_pm1(ytr, yte)
% Map binary labels to {-1,+1} using the training labels as reference.
% mapping = struct('neg', value_mapped_to_minus1, 'pos', value_mapped_to_plus1)

    ytr = ytr(:); yte = yte(:);
    ut = unique(ytr);
    if numel(ut) ~= 2
        error('make_labels_pm1: dataset must be binary; found %d classes.', numel(ut));
    end

    neg = ut(1);   % -> will become -1
    pos = ut(2);   % -> will become +1

    ytr_pm1 = double(ytr);
    yte_pm1 = double(yte);

    ytr_pm1(ytr == neg) = -1;  ytr_pm1(ytr == pos) = +1;
    yte_pm1(yte == neg) = -1;  yte_pm1(yte == pos) = +1;

    mapping = struct('neg', neg, 'pos', pos);
end
