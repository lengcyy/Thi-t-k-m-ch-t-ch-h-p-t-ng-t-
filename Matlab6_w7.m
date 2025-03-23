clc; clear; close all;

% Thông số của transistor MOSFET
Vth = 1;  % Ngưỡng điện áp (V)
k = 0.5e-3; % Hệ số khuếch đại (A/V^2)
Vdd = 12; % Điện áp cung cấp (V)
Rd = 5e3; % Điện trở tải (Ohm)
Vb = 2;  % Điện áp phân cực cho M2

% Dải điện áp cửa - nguồn của M1
Vgs1 = linspace(0, Vdd, 100);
Id = zeros(size(Vgs1));

% Xác định dòng điện Id dựa vào miền hoạt động của MOSFET M1
for i = 1:length(Vgs1)
    if Vgs1(i) < Vth
        Id(i) = 0; % Miền cắt
    else
        Id(i) = k * (Vgs1(i) - Vth)^2; % Miền bão hòa
    end
end

% Điện áp tại nút X (nối giữa M1 và M2)
Vx = Vb - Id * Rd;

% Điện áp ra Vout
Vout = Vdd - Id * Rd;

% Vẽ đặc tuyến truyền
figure;
plot(Vgs1, Vout, 'b', 'LineWidth', 2);
grid on;
xlabel('V_{GS1} (V)');
ylabel('V_{out} (V)');
title('Đặc tuyến truyền của mạch Cascode với cấu trúc M1-M2');
legend('V_{out} vs V_{GS1}');

% Hiển thị miền hoạt động
hold on;
idx_cutoff = find(Vgs1 < Vth, 1, 'last');
idx_active = find(Vgs1 >= Vth, 1, 'first');

plot(Vgs1(idx_cutoff), Vout(idx_cutoff), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
plot(Vgs1(idx_active), Vout(idx_active), 'go', 'MarkerSize', 8, 'LineWidth', 2);
legend('V_{out} vs V_{GS1}', 'Miền cắt', 'Miền bão hòa');

% Xuất kết quả
fprintf('Điểm chuyển chế độ: V_GS1 = %.2f V, V_out = %.2f V\n', Vgs1(idx_active), Vout(idx_active));
