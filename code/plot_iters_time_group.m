function plot_iters_time_group(S, plotsDir, outName)
% Overlay all datasets in group S (G1 or G2) with two stacked panels:
% (a) iterations (log y) and (b) elapsed time (log y).

% nice styles (fallback to '-o' if a dataset key isn't listed)
styles = containers.Map( ...
   {'svmguid','svmguide','ionosphere','phishing','a9a','skinnonskin','skinNonskin','ijcnn'}, ...
   {'b-*',     'b-*',      'k--o',      'b-*',     'k--o','r-s',        'r-s',        'm-x'} );

ds = S.datasets;
figure('Position',[100 100 900 700]);

% ----- (a) iterations -----
subplot(2,1,1); hold on; grid on;
title('The number of iterations in logarithmic scale');
xlabel('D-regular random graphs'); ylabel('Number of iterations');
set(gca,'YScale','log');

for i = 1:numel(ds)
    name = char(ds{i});
    T = S.results(name);                 % table: degree, iters_mean
    key = lower(name);
    if styles.isKey(name), sty = styles(name);
    elseif styles.isKey(key), sty = styles(key);
    else, sty = '-o';
    end
    plot(T.degree, T.iters_mean, sty, 'DisplayName', name, ...
         'LineWidth',1.2,'MarkerSize',6);
end
legend('Location','best');

% ----- (b) time -----
subplot(2,1,2); hold on; grid on;
title('The elapsed time of the solver in logarithmic scale');
xlabel('D-regular random graphs'); ylabel('Elapsed time');
set(gca,'YScale','log');

for i = 1:numel(ds)
    name = char(ds{i});
    T = S.results(name);                 % table: degree, time_mean
    key = lower(name);
    if styles.isKey(name), sty = styles(name);
    elseif styles.isKey(key), sty = styles(key);
    else, sty = '-o';
    end
    plot(T.degree, T.time_mean, sty, 'DisplayName', name, ...
         'LineWidth',1.2,'MarkerSize',6);
end
legend('Location','best');

if ~exist(plotsDir,'dir'), mkdir(plotsDir); end
saveas(gcf, fullfile(plotsDir, [outName '.png']));
close;
end
