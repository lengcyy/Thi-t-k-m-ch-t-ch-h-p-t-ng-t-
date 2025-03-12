%VNU.UET.FET.MEMS

%MOSFET

%Common-Source Stage Amplifier

%with Current Source Load

clear all, close all,

syms Vin Vin1_syms Vout_sat Vout_sat_n Vout_tri Vout_tri_n kn Vth Ids Vdd

% MOSFET Parameters
Vth_0 = 1.5; % Threshold voltage
kn_0 = 1e-3; % kn = 1/2 * umn * Cox * W/L
Ids_0 = 1e-3; % Current source load

% Circuit Parameters
Vdd_0 = 10;

% Solving for Vin1
Vin1_syms = solve((Vin1_syms - Vth) - (Ids / kn), Vin1_syms);
Vin1_n = subs(Vin1_syms, [Ids kn Vth], [Ids_0, kn_0, Vth_0]);
Vin1 = double(Vin1_n(1)); % Take the positive result

% In saturation region: Vout = Vdd - Ids * Rd (with current source, Rd is infinite)
Vout_sat = Vdd - Ids;
Vout_sat_n = subs(Vout_sat, [Vdd Ids], [Vdd_0, Ids_0]);

% Input signal
Vin_0 = 0:0.1:10;
Vout_n = zeros(1, length(Vin_0));
gm_n = zeros(1, length(Vin_0));

for i = 1:1:length(Vin_0)
    if Vin_0(i) <= Vth_0 % Threshold voltage
        Vout_n(i) = Vdd_0; % Turnoff
        gm_n(i) = 0;
    elseif Vin_0(i) <= Vin1 % Saturation region
        Vout_n(i) = double(subs(Vout_sat_n, Vin, Vin_0(i)));
        gm_n(i) = 2 * kn_0 * (Vin_0(i) - Vth_0);
    else % Triode region is avoided as we assume current source maintains saturation
        Vout_n(i) = Vout_n(i - 1);
        gm_n(i) = gm_n(i - 1);
    end
end

figure(1), grid on, hold on,

hl1 = plot(Vin_0, Vout_n);
hl2 = plot([Vth_0 Vth_0], [0 11]);
hl3 = plot([Vin1 Vin1], [0 11]);
ax1 = gca;
set(ax1, 'Xlim', [0 10]);
set(ax1, 'Ylim', [0 11]);
set(ax1, 'XColor', 'k', 'YColor', 'k');
set(get(ax1, 'Title'), 'String', 'Output - Input Voltage Characteristics', 'FontSize', 12);
set(get(ax1, 'XLabel'), 'String', 'Input Voltage - V', 'FontSize', 12);
set(get(ax1, 'YLabel'), 'String', 'Output Voltage - V', 'FontSize', 12);
set(ax1, 'FontSize', 12);
set(ax1, 'Box', 'On');

set(hl1, 'LineWidth', 2.5);
set(hl1, 'LineStyle', '-');
set(hl1, 'Color', 'b');

set(hl2, 'LineWidth', 2);
set(hl2, 'LineStyle', '--');
set(hl2, 'Color', 'k');

set(hl3, 'LineWidth', 2);
set(hl3, 'LineStyle', '--');
set(hl3, 'Color', 'k');

text(Vth_0, 0.5, 'Vth');
text(Vin1, 0.5, 'Vin1');

% Id - Vin Characteristics
Id_n = Ids_0 * ones(1, length(Vin_0));

figure(2), grid on, hold on,

hl1 = plot(Vin_0, Id_n);
hl2 = plot([Vth_0 Vth_0], [0 0.01]);
hl3 = plot([Vin1 Vin1], [0 0.01]);

ax1 = gca;
set(ax1, 'Xlim', [0 10]);
set(ax1, 'XColor', 'k', 'YColor', 'k');
set(get(ax1, 'Title'), 'String', 'Drain current - Gate-Source Voltage Characteristics', 'FontSize', 12);
set(get(ax1, 'XLabel'), 'String', 'Input Voltage - V', 'FontSize', 12);
set(get(ax1, 'YLabel'), 'String', 'Drain Current - A', 'FontSize', 12);
set(ax1, 'FontSize', 12);
set(ax1, 'Box', 'On');

set(hl1, 'LineWidth', 2.5);
set(hl1, 'LineStyle', '-');
set(hl1, 'Color', 'b');

set(hl2, 'LineWidth', 2);
set(hl2, 'LineStyle', '--');
set(hl2, 'Color', 'k');

set(hl3, 'LineWidth', 2);
set(hl3, 'LineStyle', '--');
set(hl3, 'Color', 'k');

text(Vth_0, 0.001, 'Vth');
text(Vin1, 0.006, 'Vin1');

figure(3), grid on, hold on,

hl1 = plot(Vin_0, gm_n);

ax1 = gca;
set(ax1, 'Xlim', [0 10]);
set(ax1, 'XColor', 'k', 'YColor', 'k');
set(get(ax1, 'Title'), 'String', 'Transconductance - Input Voltage Characteristics', 'FontSize', 12);
set(get(ax1, 'XLabel'), 'String', 'Input Voltage - V', 'FontSize', 12);
set(get(ax1, 'YLabel'), 'String', 'Gm - S', 'FontSize', 12);
set(ax1, 'FontSize', 12);
set(ax1, 'Box', 'On');

set(hl1, 'LineWidth', 2.5);
set(hl1, 'LineStyle', '-');
set(hl1, 'Color', 'b');

text(0.2, 0.2e-3, 'Turn-off');
text(2.5, 1.2e-3, 'Saturation');
