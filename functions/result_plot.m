%% Path
data_path = './musd_W_phase_aware_hpss/data/mats2/';
index_num = 3;
lambda_num = 12;

pdr_result_path = strcat(data_path, '/pdr_result/index', string(index_num), '/lambda', string(lambda_num), '.mat');
h_si_sdr_path = strcat(data_path, 'h_si_sdr_mat/', 'index', string(index_num), '.mat');
p_si_sdr_path = strcat(data_path, 'p_si_sdr_mat/', 'index', string(index_num), '.mat');
iter_p_si_sdr_path = strcat(data_path, 'iter_p_si_sdr_result/', 'index', string(index_num), '/lambda', string(lambda_num), '.mat');
iter_h_si_sdr_path = strcat(data_path, 'iter_h_si_sdr_result/', 'index', string(index_num), '/lambda', string(lambda_num), '.mat');
%% Load Data
load(h_si_sdr_path);
load(p_si_sdr_path);
load(pdr_result_path);
load(iter_p_si_sdr_path);
load(iter_h_si_sdr_path);
%% Plot
figure;
plot(p_si_sdr_array);
title('P SI-SDR');
xlabel('lambda');
ylabel('si sdr');

figure;
plot(h_si_sdr_array);
title('H SI-SDR')
xlabel('lambda');
ylabel('si sdr');

figure;
plot(iter_h_si_sdr_array');
title('iter h sdr');
xlabel('iter num')
ylabel('si sdr');

figure;
plot(iter_p_si_sdr_array);
title('iter p sdr');
xlabel('iter num');
ylabel('si sdr');