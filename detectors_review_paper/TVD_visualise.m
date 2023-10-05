% Define two probability distributions as vectors
P = [0.2, 0.3, 0.5]; % Replace with your values
Q = [0.1, 0.4, 0.5]; % Replace with your values

% Check if the distributions have the same length
if length(P) ~= length(Q)
    error('Distributions must have the same number of elements.');
end

% Values for the random variable (x)
x = 1:length(P);

% Create bar plots for the two distributions
figure;
bar(x, P, 'b', 'BarWidth', 0.4); % Blue bars for P
hold on;
bar(x, Q, 'r', 'BarWidth', 0.4); % Red bars for Q

% Add labels and legend
xlabel('Random Variable (x)');
ylabel('Probability');
legend('P', 'Q');

% Calculate the total variance distance
TVD = 0.5 * sum(abs(P - Q));

% Display the TVD as a text annotation on the plot
text(0.5, max([P, Q]), sprintf('TVD = %.4f', TVD), 'FontSize', 12, 'FontWeight', 'bold');

% Set axis properties
axis([0.5, length(P) + 0.5, 0, max([P, Q]) + 0.1]);

% Title for the plot
title('Probability Distributions and TVD');

% Draw a line to represent TVD visually
line([length(P) + 1, length(P) + 1], [0, max([P, Q]) + 0.1], 'Color', 'k', 'LineStyle', '--', 'LineWidth',2);

% Add a text label to indicate the TVD visually
text(length(P) + 1.2, max([P, Q]) / 2, 'TVD', 'FontSize', 12, 'FontWeight', 'bold');

% Hold off to end the plot
hold off;