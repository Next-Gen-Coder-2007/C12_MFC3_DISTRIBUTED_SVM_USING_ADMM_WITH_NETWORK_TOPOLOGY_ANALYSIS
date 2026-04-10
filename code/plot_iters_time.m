function plot_iters_time(T, groupName, dsetName, plotsDir)
% Plot iterations and time vs degree (like Fig.3/4)
figure;
yyaxis left;
plot(T.degree, T.iters_mean, '-o','LineWidth',2); ylabel('Iterations (mean)');
yyaxis right;
plot(T.degree, T.time_mean, '-s','LineWidth',2); ylabel('Time (s, mean)');
xlabel('Degree d'); title(sprintf('Iterations & Time vs d: %s - %s', groupName, dsetName));
grid on;
saveas(gcf, fullfile(plotsDir, sprintf('%s_%s_iters_time.png', groupName, dsetName)));
close;
end
