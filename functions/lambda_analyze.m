data_folder_path = './musd_W_phase_aware_hpss/data/mats/';
h_sdr_folder_name = 'h_sdr_mat/';
p_sdr_folder_name = 'p_sdr_mat/';
index_num = 10;

all_p_sdr_array = [];
all_h_sdr_array = [];

for index = 1:index_num
    p_sdr_file_path = strcat(data_folder_path, p_sdr_folder_name, 'index', string(index), '.mat');
    h_sdr_file_path = strcat(data_folder_path, h_sdr_folder_name, 'index', string(index), '.mat');
    
    load(p_sdr_file_path);
    load(h_sdr_file_path);
    
    all_p_sdr_array = [all_p_sdr_array; p_si_sdr_array];
    all_h_sdr_array = [all_h_sdr_array; h_si_sdr_array];
end

