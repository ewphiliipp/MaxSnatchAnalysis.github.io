clc;
close all;
clear;

% Load data
data = readtable("trajectory.csv");
time = (0:0.034:3.958)';

% Position (y)
y = abs(data.Markierung1_0_X(1:end-1));
y = y / 100;  % cm → m

% Velocity
speed = diff(y) ./ diff(time);

% Acceleration
acceleration = diff(speed) ./ diff(time(1:end-1));
acceleration = movmean(acceleration, 8);  % Smoothing

% Detect movement start
mNoMovement = mean(acceleration(1:10));
threshold = mNoMovement + 3 * std(acceleration(1:10));
idxStart = find(acceleration > threshold, 1, 'first');
t_start = time(idxStart);
v_start = speed(idxStart);
a_start = acceleration(idxStart);

% Detect extrema
[minAcc, idxMinAcc] = min(acceleration);
t_minAcc = time(idxMinAcc);
v_minAcc = speed(idxMinAcc);

[maxAccBeforeMin, idxMaxAccBeforeMin] = max(acceleration(1:idxMinAcc-1));
t_maxAccBeforeMin = time(idxMaxAccBeforeMin);
v_maxAccBeforeMin = speed(idxMaxAccBeforeMin);

[maxAccAfterMin, idxMaxAccAfterMin_relative] = max(acceleration(idxMinAcc+1:end));
idxMaxAccAfterMin = idxMinAcc + idxMaxAccAfterMin_relative;
t_maxAccAfterMin = time(idxMaxAccAfterMin);
v_maxAccAfterMin = speed(idxMaxAccAfterMin);

%% === FIGURE 1: Position, Velocity, Acceleration ===
figure;
hold on; grid on;

h1 = plot(time, y, "b", "LineWidth", 1.5);
h2 = plot(time(1:end-1), speed, "r", "LineWidth", 1.5);
h3 = plot(time(1:end-2), acceleration, "g", "LineWidth", 1.5);

% Mark events
plot(t_start, a_start, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(t_maxAccBeforeMin, maxAccBeforeMin, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(t_minAcc, minAcc, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(t_maxAccAfterMin, maxAccAfterMin, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Annotate events
text(t_start, a_start, ...
     sprintf("Start (t = %.2fs)", t_start), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k');

text(t_maxAccBeforeMin, maxAccBeforeMin, ...
     sprintf("a_{max} = %.2f m/s²\nPull", maxAccBeforeMin), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k');

text(t_minAcc, minAcc, ...
     sprintf("a_{min} = %.2f m/s²\nTurnover", minAcc), ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'right', 'Color', 'k');

text(t_maxAccAfterMin, maxAccAfterMin, ...
     sprintf("a_{max} = %.2f m/s²\nCatch", maxAccAfterMin), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k');

ylim([-11, 6]);
xlabel("Time (s)");
ylabel("Position / Velocity / Acceleration");
title("Phase Analysis in Olympic Weightlifting");
legend([h1, h2, h3], ...
    ["Position", "Velocity", "Acceleration"]);
hold off;

%% === FIGURE 2: Force Analysis ===
figure;
hold on; grid on;

mass = 110;           % kg
compareMass = 225;    % kg
g = 9.81;             % m/s²

Force110 = mass * (acceleration + g);
Force225 = compareMass * (acceleration + g);

h1 = plot(time(1:end-2), Force110, "m", "LineWidth", 1.5);
h2 = plot(time(1:end-2), Force225, "c--", "LineWidth", 1.5);

% Work estimation
dx = diff(y);
work110 = sum(Force110 .* dx(1:end-1));
work225 = sum(Force225 .* dx(1:end-1));

fill([time(1:end-2); flip(time(1:end-2))], [zeros(size(Force110)); flip(Force110)], ...
    'm', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Forces at key events (110 kg)
forceStart110 = mass * (a_start + g);
forceMaxAccBefore110 = mass * (maxAccBeforeMin + g);
forceMinAcc110 = mass * (minAcc + g);
forceMaxAccAfter110 = mass * (maxAccAfterMin + g);

% Forces at key events (225 kg)
forceStart225 = compareMass * (a_start + g);
forceMaxAccBefore225 = compareMass * (maxAccBeforeMin + g);
forceMinAcc225 = compareMass * (minAcc + g);
forceMaxAccAfter225 = compareMass * (maxAccAfterMin + g);

% Markers for 110 kg
plot(t_start, forceStart110, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(t_maxAccBeforeMin, forceMaxAccBefore110, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(t_minAcc, forceMinAcc110, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(t_maxAccAfterMin, forceMaxAccAfter110, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

text(t_start, forceStart110, ...
     "Start", 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');

text(t_maxAccBeforeMin, forceMaxAccBefore110, ...
     sprintf("F_{pull,110kg} = %.2f N", forceMaxAccBefore110), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');

text(t_minAcc, forceMinAcc110, "Turnover", ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');

text(t_maxAccAfterMin, forceMaxAccAfter110, ...
     sprintf("F_{catch,110kg} = %.2f N", forceMaxAccAfter110), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');

% Markers for 225 kg
plot(t_start, forceStart225, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);
plot(t_maxAccBeforeMin, forceMaxAccBefore225, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);
plot(t_maxAccAfterMin, forceMaxAccAfter225, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);

text(t_maxAccBeforeMin, forceMaxAccBefore225, ...
     sprintf("F_{pull,225kg} = %.2f N", forceMaxAccBefore225), ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');

text(t_maxAccAfterMin, forceMaxAccAfter225, ...
     sprintf("F_{catch,225kg} = %.2f N", forceMaxAccAfter225), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

xlabel("Time (s)");
ylabel("Force (N)");
title("Force Profiles During Weightlifting Phases");
legend([h1, h2], "Force (110 kg)", "Force (225 kg)");
hold off;

%% Command Window Output
disp("===== Analysis Results =====");
disp("Start time: " + t_start + " s");
disp("Work performed (110 kg): " + work110 + " J");
disp("Work performed (225 kg): " + work225 + " J");

disp(" ");
disp(">> PULL PHASE <<");
disp("F_start (110 kg): " + forceStart110 + " N");
disp("F_pull (110 kg): " + forceMaxAccBefore110 + " N");
disp("F_pull (225 kg): " + forceMaxAccBefore225 + " N");

disp(">> RECOVERY <<");
disp("F_catch (110 kg): " + forceMaxAccAfter110 + " N");
disp("F_catch (225 kg): " + forceMaxAccAfter225 + " N");
