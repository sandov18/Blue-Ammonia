%% Set formatting style
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

%% Inputs
% Load the CSV files
cashflow = readtable('cashflow_results.csv');
sensitivity = readtable('sensitivity_results.csv');

% Define variables
year = cashflow{:, 1};
cash = cashflow{:, 2};
d_rate = cashflow{:, 3};
NG_p = sensitivity{:, 1};
NG_s = sensitivity{:, 2};
El_p = sensitivity{:, 3};
El_s = sensitivity{:, 4};
DR = sensitivity{:, 5};
DR_s = sensitivity{:, 6};
CF = sensitivity{:, 7};
CF_s = sensitivity{:, 8};
Elw_s = sensitivity{:, 9};

%% Plot
figure;
ax1 = axes;
h1 = plot(NG_p, NG_s, 'b-o', 'LineWidth', 1.5, 'Parent', ax1); % Plot first curve
xlabel(ax1, 'NG Price (\$/Mcf)');
ylabel(ax1, 'LCOA (\$/ton)');
ax1.XColor = 'b';

% Create the second x-axis
ax2 = axes('Position', ax1.Position, ...
           'XAxisLocation', 'top', ...
           'YAxisLocation', 'left', ...
           'Color', 'none'); % Overlay axes for second x-axis
ax2.XColor = 'r'; % Color for second x-axis
xlabel(ax2, 'Electricity Price (\$/MWh)')
h2 = line(El_p, El_s, 'Parent', ax2, 'Color', 'r', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 1.5); hold on;% Second curve
h3 = line(El_p, Elw_s, 'Parent', ax2, 'Color', [0.5, 0, 0.5], 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 1.5);

linkaxes([ax1, ax2], 'y');
legend([h1,h2,h3], {'Natural Gas Sensitivity', 'Electricity Sensitivity', 'Electricity Sensitivity w/Wind'}, 'Location','best');
grid on

figure;
ax1 = axes;
h1 = plot(DR, DR_s, 'b-o', 'LineWidth', 1.5, 'Parent', ax1); % Plot first curve
xlabel(ax1, 'Discount rate (\%)');
ylabel(ax1, 'LCOA (\$/ton)');
ax1.XColor = 'b';

% Create the second x-axis
ax2 = axes('Position', ax1.Position, ...
           'XAxisLocation', 'top', ...
           'YAxisLocation', 'left', ...
           'Color', 'none'); % Overlay axes for second x-axis
ax2.XColor = 'r'; % Color for second x-axis
xlabel(ax2, 'Capacity Factor (\%)')
h2 = line(CF, CF_s, 'Parent', ax2, 'Color', 'r', 'Marker', 'o', 'LineStyle', '-', 'LineWidth', 1.5); % Second curve

linkaxes([ax1, ax2], 'y');
legend([h1,h2], {'Discount Rate Sensitivity', 'Capacity Factor Sensitivity'}, 'Location','best');
grid on

figure;
plot(year',cash, 'r-', 'LineWidth', 1.5); hold on;
plot(year',d_rate, 'b-', 'LineWidth', 1.5);
grid on
xlabel({'Years'}, 'FontSize', 12);
ylabel('Cash flow (M\$)','FontSize', 12)
legend({'Cash flow', 'Discounted cash flow'}, 'Location', 'Best');
title('Cash flow analysis', 'FontSize', 14);
