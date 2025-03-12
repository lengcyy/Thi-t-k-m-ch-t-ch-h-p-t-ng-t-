clc; clear; close all;

%% Thông số MOSFET và mạch
Vth = 1.5;  % Điện áp ngưỡng (V)
kn = 1e-3;  % Hệ số khuếch đại (A/V^2)
Ids = 1e-3; % Dòng điện tải (A)
Vdd = 10;   % Điện áp nguồn (V)
Rs = 1e3;   % Điện trở nguồn suy biến (ohm)

%% Tính toán các điểm quan trọng
Vin1 = Vth + (Ids / kn); % Điểm chuyển đổi chế độ

%% Quét giá trị Vin
Vin = linspace(0, 10, 1000); 
Vout = zeros(size(Vin)); 
gm = zeros(size(Vin)); 

for i = 1:length(Vin)
    if Vin(i) < Vth 
        Vout(i) = Vdd; % MOSFET tắt
        gm(i) = 0;
    elseif Vin(i) < Vin1 
        Vout(i) = Vdd - Ids * Rs; % Vùng bão hòa
        gm(i) = 2 * kn * (Vin(i) - Vth);
    else 
        Vout(i) = Vdd - (Vin(i) - Vth) / (1 / kn + Rs); % Vùng tuyến tính
        gm(i) = gm(i-1);
    end
end

%% Vẽ đồ thị đặc tuyến Vout - Vin
figure;
plot(Vin, Vout, 'b', 'LineWidth', 2);
hold on;
plot([Vth Vth], [0 Vdd], '--k');
plot([Vin1 Vin1], [0 Vdd], '--r');
grid on;
xlabel('Điện áp vào (V)');
ylabel('Điện áp ra (V)');
title('Đặc tuyến điện áp ra theo điện áp vào');
legend('V_{out}', 'V_{th}', 'V_{in1}');
hold off;

%% Vẽ đồ thị gm - Vin
figure;
plot(Vin, gm, 'r', 'LineWidth', 2);
grid on;
xlabel('Điện áp vào (V)');
ylabel('Hệ số dẫn gm (S)');
title('Đặc tuyến hệ số dẫn gm theo điện áp vào');
legend('g_m');

%% Lưu hình ảnh
saveas(gcf, 'gm_vs_vin.png');
