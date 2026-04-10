function plot_topology_effect(perDeg, datasetName, groupName, plotsDir)
    figure; 
    yyaxis left;
    plot(perDeg.lambda2, perDeg.iters_mean, 'o-', 'LineWidth', 1.5);
    ylabel('Iterations (mean)');

    yyaxis right;
    plot(perDeg.lambda2, perDeg.converged_rate, 's--', 'LineWidth', 1.5);
    ylabel('Converged Rate');

    xlabel('\lambda_2 (Spectral Gap)');
    title(sprintf('Topology effect on ADMM: %s (%s)', datasetName, groupName));
    legend('Iterations','Converged Rate','Location','Best');
    grid on;

    saveas(gcf, fullfile(plotsDir, sprintf('%s_%s_topology.png', groupName, datasetName)));
end
