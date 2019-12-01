%% Path
mat_data_folder =  './MF_hpss/secret_mountain/';
%% Load Variables
load('config.mat');
load('./good_audio_data.mat');
mf_len = 15;
%% Iter all audio file
mf_h_si_sdr_array = [];
mf_p_si_sdr_array = [];
mf_p_sdr_array = [];
mf_h_sdr_array = [];
mf_h_sar_array = [];
mf_p_sar_array = [];
mf_p_sir_array = [];
mf_h_sir_array = [];
for index = 4:4;
    mix_data = cell2mat(mix_data_cell(index,:));
    p_data   = cell2mat(p_data_cell(index,:));
    p_l2_t = sqrt(sum(abs(p_data).^2, 1));
    h_data = cell2mat(h_data_cell(index,:));
    pad_p_data = zeroPaddingForDGT(p_data, shiftLen, fftLen);
    pad_h_data = zeroPaddingForDGT(h_data, shiftLen, fftLen);
    pad_audio_data = zeroPaddingForDGT(mix_data, shiftLen, fftLen);
    
   %% DGT
    win = generalizedCosWin(windowLen, 'hann');
    win = calcCanonicalTightWindow(win, shiftLen);
    diffWin = numericalDiffWin(win);
    spec = DGT(pad_audio_data, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    p_spec = DGT(pad_p_data, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    h_spec = DGT(pad_h_data, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    plot_amp(p_data, spec, '_spec')
    plot_amp(p_data, p_spec, '_spec')
    plot_amp(p_data, h_spec, '_spec')
    %% IF
    diffSpec = DGT(pad_audio_data, diffWin, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    IF = calcInstFreq(spec, diffSpec, fftLen, windowLen, rotateFlag);
    
    X_init = pad_audio_data;
    mf_spec_h = MF_h(abs(spec), mf_len);
    mf_spec_p = MF_p(abs(spec), mf_len);
    WinnerFilter_h = WinnerFilter(mf_spec_h, mf_spec_p);
    WinnerFilter_p = WinnerFilter(mf_spec_p, mf_spec_h);

    Yh_init = spec .* WinnerFilter_h;
    Yp_init = spec .* WinnerFilter_p;
    mf_Xh = invDGT(Yh_init, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    mf_Xp = invDGT(Yp_init, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    
    mf_p_si_sdr_val = SI_SDR(pad_p_data, mf_Xp);
    mf_h_si_sdr_val = SI_SDR(pad_h_data, mf_Xh);
    
    mf_p_si_sdr_array = [mf_p_si_sdr_array mf_p_si_sdr_val];
    mf_h_si_sdr_array = [mf_h_si_sdr_array mf_h_si_sdr_val];

    est_data = [mf_Xh mf_Xp];
    ora_data = [pad_h_data pad_p_data];
    [SDR,SIR,SAR, perm] = bss_eval_sources(est_data',  ora_data');
%     
%     PDR_result_data_file_path = strcat(mat_data_folder, 'pdr_result/', 'index', string(index),'.mat'); 
%     save(PDR_result_data_file_path, 'mf_Xp', 'mf_Xh');
    
    mf_h_sdr_array = [mf_h_sdr_array SDR(1)];
    mf_p_sdr_array = [mf_p_sdr_array SDR(2)];
    mf_h_sir_array = [mf_h_sir_array SIR(1)];
    mf_p_sir_array = [mf_p_sir_array SIR(2)];
    mf_h_sar_array = [mf_h_sar_array SAR(1)];
    mf_p_sar_array = [mf_p_sar_array SAR(2)];
end


% p_si_sdr_mat_file_name = strcat(mat_data_folder, 'mf_p_si_sdr.mat');
% h_si_sdr_mat_file_name = strcat(mat_data_folder, 'mf_h_si_sdr.mat');
% save(p_si_sdr_mat_file_name, 'mf_p_si_sdr_array');
% save(h_si_sdr_mat_file_name, 'mf_h_si_sdr_array');
% 
% p_sdr_mat_file_name = strcat(mat_data_folder, 'mf_p_sdr.mat');
% h_sdr_mat_file_name = strcat(mat_data_folder, 'mf_h_sdr.mat');
% save(p_sdr_mat_file_name, 'mf_p_sdr_array');
% save(h_sdr_mat_file_name, 'mf_h_sdr_array');
% 
% p_sir_mat_file_name = strcat(mat_data_folder, 'mf_p_sir.mat');
% h_sir_mat_file_name = strcat(mat_data_folder, 'mf_h_sir.mat');
% save(p_sir_mat_file_name, 'mf_p_sir_array');
% save(h_sir_mat_file_name, 'mf_h_sir_array');
% 
% p_sar_mat_file_name = strcat(mat_data_folder, 'mf_p_sar.mat');
% h_sar_mat_file_name = strcat(mat_data_folder, 'mf_h_sar.mat');
% save(p_sar_mat_file_name, 'mf_p_sar_array');
% save(h_sar_mat_file_name, 'mf_h_sar_array');
