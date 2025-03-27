clc;
close all;
clear;

% Daten einlesen
data = readtable("trajectory.csv");
time = (0:0.034:3.958)';

% Position (y)
y = abs(data.Markierung1_0_X(1:end-1));
y = y / 100;  % cm → m

% Geschwindigkeit
speed = diff(y) ./ diff(time);

% Beschleunigung
acceleration = diff(speed) ./ diff(time(1:end-1));
acceleration = movmean(acceleration, 8);  % Glättung

% Startzeitpunkt bestimmen
mNoMovement = mean(acceleration(1:10));
threshold = mNoMovement + 3 * std(acceleration(1:10));
idxStart = find(acceleration > threshold, 1, 'first');
t_start = time(idxStart);
v_start = speed(idxStart);
a_start = acceleration(idxStart);

% Extrempunkte bestimmen
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

%% === FIGURE 1: Position, Geschwindigkeit, Beschleunigung ===
figure;
hold on; grid on;

h1 = plot(time, y, "b", "LineWidth", 1.5);
h2 = plot(time(1:end-1), speed, "r", "LineWidth", 1.5);
h3 = plot(time(1:end-2), acceleration, "g", "LineWidth", 1.5);

h4 = plot(t_start, a_start, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
h5 = plot(t_maxAccBeforeMin, maxAccBeforeMin, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
h6 = plot(t_minAcc, minAcc, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
h7 = plot(t_maxAccAfterMin, maxAccAfterMin, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

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
xlabel("Zeit (s)");
ylabel("Position / Geschwindigkeit / Beschleunigung");
title("Analyse der Phasen im Gewichtheben");
legend([h1, h2, h3], ...
    ["Position", "Speed", "Acceleration"]);
hold off;

%% === FIGURE 2: Kräfteanalyse ===
figure;
hold on; grid on;

mass = 110;           % kg
compareMass = 225;    % kg
g = 9.81;             % m/s²

Force110 = mass * (acceleration + g);
Force225 = compareMass * (acceleration + g);

h1 = plot(time(1:end-2), Force110, "m", "LineWidth", 1.5);
h2 = plot(time(1:end-2), Force225, "c--", "LineWidth", 1.5);

dx = diff(y);
work110 = sum(Force110 .* dx(1:end-1));
work225 = sum(Force225 .* dx(1:end-1));

fill([time(1:end-2); flip(time(1:end-2))], [zeros(size(Force110)); flip(Force110)], ...
    'm', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Kraft an definierten Punkten (110 kg)
forceStart110 = mass * (a_start + g);
forceMaxAccBefore110 = mass * (maxAccBeforeMin + g);
forceMinAcc110 = mass * (minAcc + g);
forceMaxAccAfter110 = mass * (maxAccAfterMin + g);

% Kraft an definierten Punkten (225 kg)
forceStart225 = compareMass * (a_start + g);
forceMaxAccBefore225 = compareMass * (maxAccBeforeMin + g);
forceMinAcc225 = compareMass * (minAcc + g);
forceMaxAccAfter225 = compareMass * (maxAccAfterMin + g);

% Markierungen 110 kg
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

% Markierungen 225 kg
plot(t_start, forceStart225, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);
plot(t_maxAccBeforeMin, forceMaxAccBefore225, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);
plot(t_maxAccAfterMin, forceMaxAccAfter225, 'kx', 'MarkerSize', 8, 'LineWidth', 1.5);

text(t_maxAccBeforeMin, forceMaxAccBefore225, ...
     sprintf("F_{pull,225kg} = %.2f N", forceMaxAccBefore225), ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');

text(t_maxAccAfterMin, forceMaxAccAfter225, ...
     sprintf("F_{catch,225kg} = %.2f N", forceMaxAccAfter225), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

xlabel("Zeit (s)");
ylabel("Kraft (N)");
title("Kräfteanalyse in verschiedenen Phasen");
legend([h1, h2], "Kraft (110 kg)", "Kraft (225 kg)");

%% Ausgabe im Command Window
disp("===== Analyseergebnisse =====");
disp("Startzeitpunkt: " + t_start + " s");
disp("Geleistete Arbeit (110 kg): " + work110 + " J");
disp("Geleistete Arbeit (225 kg): " + work225 + " J");

disp(" ");
disp(">> PULL-PHASE <<");
disp("F_start (110 kg): " + forceStart110 + " N");
disp("F_pull (110 kg): " + forceMaxAccBefore110 + " N");
disp("F_pull (225 kg): " + forceMaxAccBefore225 + " N");

disp(">> RECOVERY <<");
disp("F_catch (110 kg): " + forceMaxAccAfter110 + " N");
disp("F_catch (225 kg): " + forceMaxAccAfter110 + " N");
