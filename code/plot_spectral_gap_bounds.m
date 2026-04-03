function plot_spectral_gap_bounds(T, groupName, dsetName, plotsDir)
% Plot λ2 with Ramanujan bounds (like Fig.1/2)
figure;
hold on;
for i=1:height(T)
    plot([i i],[T.lambda2_lb(i), T.lambda2_ub(i)],'-','LineWidth',2);
end
plot(1:height(T), T.lambda2, '*','MarkerSize',8);
xticks(1:height(T)); xticklabels(string(T.degree));
xlabel('Degree d'); ylabel('\lambda_2 (Laplacian)');
title(sprintf('Spectral gap bounds vs realized \\lambda_2: %s - %s', groupName, dsetName));
grid on;
saveas(gcf, fullfile(plotsDir, sprintf('%s_%s_lambda2_bounds.png', groupName, dsetName)));
close;
end
