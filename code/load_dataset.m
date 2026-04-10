function D = load_dataset(name, dataDir)
% Downloads/loads datasets used in the paper (Table I).
% D returns struct with fields: name, Xtr, ytr, Xte, yte
% Some datasets are available in LIBSVM format. We'll fetch from common mirrors.

if ~exist(dataDir,'dir'), mkdir(dataDir); end
switch lower(name)
    case 'ionosphere'
    % UCI ionosphere: 351 instances, 34 features
    % We'll download from UCI; format as +1/-1 labels (good/bad)
    fn = fullfile(dataDir,'ionosphere.mat');
    if ~exist(fn,'file')
        url = 'https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data';
        localFile = fullfile(dataDir,'ionosphere.data');
        websave(localFile, url);

        % FIX: specify delimiter explicitly (comma-separated file)
        T = readtable(localFile, 'FileType','text', 'Delimiter', ',');

        X = table2array(T(:,1:end-1));
        ychar = table2array(T(:,end));
        y = ones(size(ychar));
        y(strcmp(ychar,'b')) = -1;

        % Train/test split sizes per paper: 300 train, 51 test
        Xtr = X(1:300,:); ytr = y(1:300);
        Xte = X(301:end,:); yte = y(301:end);

        save(fn,'Xtr','ytr','Xte','yte');
    else
        S=load(fn); Xtr=S.Xtr; ytr=S.ytr; Xte=S.Xte; yte=S.yte;
    end

    case 'svmguid'
        % SVMguide1 from LIBSVM dataset collection
        % Train: 3089, Test: 4000
        fn = fullfile(dataDir,'svmguide1.mat');
        if ~exist(fn,'file')
            urlTr = 'https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/svmguide1';
            urlTe = 'https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/svmguide1.t';
            websave(fullfile(dataDir,'svmguide1'), urlTr);
            websave(fullfile(dataDir,'svmguide1.t'), urlTe);
            [ytr,Xtr] = libsvmread(fullfile(dataDir,'svmguide1'));
            [yte,Xte] = libsvmread(fullfile(dataDir,'svmguide1.t'));
            Xtr = full(Xtr); Xte = full(Xte);
            ytr(ytr==0) = -1; yte(yte==0) = -1; % ensure +/-1
            save(fn,'Xtr','ytr','Xte','yte');
        else
            S=load(fn); Xtr=S.Xtr; ytr=S.ytr; Xte=S.Xte; yte=S.yte;
        end

    case 'phishing'
    % LIBSVM phishing dataset (single file only)
    % Paper Table I: use 5000 train, 5000 test
    fn = fullfile(dataDir,'phishing.mat');
    if ~exist(fn,'file')
        base = 'https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/';
        localFile = fullfile(dataDir,'phishing');

        if ~isfile(localFile)
            fprintf('Downloading phishing dataset...\n');
            websave(localFile, [base 'phishing']);
        end

        % Load full dataset
        [y, X] = libsvmread(localFile);
        X = full(X);
        y(y==0) = -1;   % ensure labels are +/-1

        % Match paper’s split: 5000 train, 5000 test
        if size(X,1) < 10000
            error('Phishing dataset rows less than expected. Got %d', size(X,1));
        end
        Xtr = X(1:5000,:); ytr = y(1:5000);
        Xte = X(5001:10000,:); yte = y(5001:10000);

        save(fn,'Xtr','ytr','Xte','yte');
    else
        S=load(fn); Xtr=S.Xtr; ytr=S.ytr; Xte=S.Xte; yte=S.yte;
    end


    case 'a9a'
        % Adult a9a dataset
        fn = fullfile(dataDir,'a9a.mat');
        if ~exist(fn,'file')
            urlTr = 'https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/a9a';
            urlTe = 'https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/a9a.t';
            websave(fullfile(dataDir,'a9a'), urlTr);
            websave(fullfile(dataDir,'a9a.t'), urlTe);
            [ytr,Xtr] = libsvmread(fullfile(dataDir,'a9a'));
            [yte,Xte] = libsvmread(fullfile(dataDir,'a9a.t'));
            Xtr = full(Xtr); Xte = full(Xte);
            ytr(ytr==0) = -1; yte(yte==0) = -1;
            save(fn,'Xtr','ytr','Xte','yte');
        else
            S=load(fn); Xtr=S.Xtr; ytr=S.ytr; Xte=S.Xte; yte=S.yte;
        end

    case 'ijcnn'
    % ijcnn1 dataset (train/test are compressed as .bz2 on LIBSVM site)
    fn = fullfile(dataDir,'ijcnn1.mat');
    if ~exist(fn,'file')
        base = 'https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary/';
        fntr = fullfile(dataDir, 'ijcnn1.tr');
        fnte = fullfile(dataDir, 'ijcnn1.t');

        % Train set
        if ~isfile(fntr)
            fprintf('Downloading ijcnn1.tr.bz2...\n');
            websave([fntr '.bz2'], [base 'ijcnn1.tr.bz2']);
            bunzip2([fntr '.bz2']);   % decompress -> ijcnn1.tr
        end

        % Test set
        if ~isfile(fnte)
            fprintf('Downloading ijcnn1.t.bz2...\n');
            websave([fnte '.bz2'], [base 'ijcnn1.t.bz2']);
            bunzip2([fnte '.bz2']);   % decompress -> ijcnn1.t
        end

        % Load datasets
        [ytr, Xtr] = libsvmread(fntr);
        [yte, Xte] = libsvmread(fnte);
        Xtr = full(Xtr); Xte = full(Xte);
        ytr(ytr==0) = -1; yte(yte==0) = -1;  % ensure ±1 labels

        save(fn,'Xtr','ytr','Xte','yte');
    else
        S=load(fn); Xtr=S.Xtr; ytr=S.ytr; Xte=S.Xte; yte=S.yte;
    end


                case 'skinnonskin'
        % Skin Segmentation dataset (ensure proper binary labels and stratified split)
        fn = fullfile(dataDir,'skinNonskin.mat');
        if ~exist(fn,'file')
            url = 'https://archive.ics.uci.edu/ml/machine-learning-databases/00229/Skin_NonSkin.txt';
            localTxt = fullfile(dataDir,'Skin_NonSkin.txt');
            if ~isfile(localTxt)
                websave(localTxt, url);
            end

            % Robust read (space or tab separated)
            M = readmatrix(localTxt);   % [R G B label]
            if size(M,2) < 4
                error('Skin_NonSkin.txt was not parsed correctly (expected 4 columns).');
            end

            X = M(:,1:3);
            y = M(:,4);

            % Map {1,2} -> {+1,-1} (UCI uses 1=skin, 2=non-skin)
            y(y==1) = +1;
            y(y==2) = -1;

            % Exact sizes used in the paper
            Ntr = 37492; 
            Nte = 5000; 

            % --- Stratified selection to guarantee both classes in train and test ---
            rng(42); % reproducible

            pos = find(y == +1);
            neg = find(y == -1);
            if isempty(pos) || isempty(neg)
                error('SkinNonskin raw file contains only one class (pos=%d, neg=%d).', numel(pos), numel(neg));
            end

            % Shuffle within each class
            pos = pos(randperm(numel(pos)));
            neg = neg(randperm(numel(neg)));

            % Allocate test set proportionally to class priors
            npos_total = numel(pos); 
            nneg_total = numel(neg);
            npos_te = round(Nte * npos_total / (npos_total + nneg_total));
            nneg_te = Nte - npos_te;

            te_idx = [pos(1:npos_te); neg(1:nneg_te)];
            tr_pool = [pos(npos_te+1:end); neg(nneg_te+1:end)];
            tr_pool = tr_pool(randperm(numel(tr_pool)));

            if numel(tr_pool) < Ntr
                error('Not enough samples to form the requested train size.');
            end
            tr_idx = tr_pool(1:Ntr);

            % Build splits
            Xtr = X(tr_idx,:);  ytr = y(tr_idx);
            Xte = X(te_idx,:);  yte = y(te_idx);

            % Sanity checks: both classes present in each split
            if numel(unique(ytr)) < 2 || numel(unique(yte)) < 2
                error('Stratified split failed: one of the splits is single-class.');
            end

            save(fn,'Xtr','ytr','Xte','yte');
        else
            S=load(fn); 
            Xtr=S.Xtr; ytr=S.ytr; 
            Xte=S.Xte; yte=s.yte;   % <-- fixed lowercase
        end
otherwise
        error('Unknown dataset: %s', name);
end   % <-- closes the switch




% --- Global label normalization to {-1, +1} ---
% Some datasets above already remap, but enforce consistency here.
allY = [ytr(:); yte(:)];
u = unique(allY);

% Safeguard: must have exactly 2 unique labels
if numel(u) ~= 2
    error('Dataset %s is not binary: found %d unique labels. Labels: %s', ...
          name, numel(u), mat2str(u));
end

% Map lowest to -1, highest to +1 (safe normalization)
neg = u(1); pos = u(2);
ytr(ytr == neg) = -1;  ytr(ytr == pos) = +1;
yte(yte == neg) = -1;  yte(yte == pos) = +1;

% Print summary for debug/logging
fprintf('Loaded dataset: %s\n', name);
fprintf('  Train size: %d, Test size: %d\n', size(Xtr,1), size(Xte,1));
fprintf('  Features: %d\n', size(Xtr,2));
fprintf('  Labels after normalization: %s\n\n', mat2str(unique([ytr(:); yte(:)])));

% Return dataset struct with guaranteed {-1,+1} labels
D = struct('name', name, 'Xtr', Xtr, 'ytr', ytr, 'Xte', Xte, 'yte', yte);
end



