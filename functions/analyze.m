data_folder_path = './musd_W_phase_aware_hpss/data/test_data/';
h_sdr_folder_name = 'h_si_sdr_mat/';
p_sdr_folder_name = 'p_si_sdr_mat/';
index_num = 10;

all_p_si_sdr_array = [];
all_h_si_sdr_array = [];

for index = 1:index_num
    p_si_sdr_file_path = strcat(data_folder_path, p_sdr_folder_name, 'index', string(index), '.mat');
    h_si_sdr_file_path = strcat(data_folder_path, h_sdr_folder_name, 'index', string(index), '.mat');
    
    load(p_si_sdr_file_path);
    load(h_si_sdr_file_path);
    
    all_p_si_sdr_array = [all_p_si_sdr_array; p_si_sdr_array];
    all_h_si_sdr_array = [all_h_si_sdr_array; h_si_sdr_array];
end

mean_p_si_sdr = mean(all_p_si_sdr_array);
mean_h_si_sdr = mean(all_h_si_sdr_array);
std_p_si_sdr = std(all_p_si_sdr_array);
std_h_si_sdr = std(all_h_si_sdr_array);

x_axis = 10.^linspace(-3, 3, 20);

% figure;
% errorbar(x_axis, mean_p_sdr, std_p_sdr' .* ones(size(mean_p_sdr,2), 1));
% set(gca, 'Xscale', 'log')
% 
% figure;
% errorbar(x_axis, mean_h_sdr, std_h_sdr' .* ones(size(mean_h_sdr,2), 1));
% set(gca, 'Xscale', 'log')
% 
% figure;
% semilogx(x_axis, mean_p_sdr);
% xlabel('lambda');
% ylabel('sdr mean');
% 
% figure;
% semilogx(x_axis, mean_h_sdr);
% xlabel('lambda');
% ylabel('sdr mean');