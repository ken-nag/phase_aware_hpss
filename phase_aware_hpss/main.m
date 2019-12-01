%% functions
Updater = @(x_, x, a) a*x_ + (1-a)*x;
Power = @(x) abs(x).^2;
%% Path
mat_data_folder = './musd_W_phase_aware_hpss/data/mats2/';
h_si_sdr_mat_folder_path = strcat(mat_data_folder, 'h_si_sdr_mat/');
p_si_sdr_mat_folder_path = strcat(mat_data_folder, 'p_si_sdr_mat/');
%% Load Variables
load('config.mat');
load('audio_data.mat');
a = 1.0;
%% Iter all audio file
for index = 1:10
   %% Load Signal
%     data_path     = './phase_aware_hpss/data/';
%     folder_name   = 'take_five/';
% 
%     h_file_name   = 'harmonic.wav';
%     p_file_name   = 'percussive.wav';
%     mix_file_name = 'mix.wav';
% 
%     [h_data, fs_]  = audioread(strcat(data_path, folder_name, h_file_name));
%     [p_data, fs__] = audioread(strcat(data_path, folder_name, p_file_name));
%     [mix_data, fs] = audioread(strcat(data_path, folder_name, mix_file_name));
    mix_data = cell2mat(mix_data_cell(index,:));
    p_data   = cell2mat(p_data_cell(index,:));
    h_data = cell2mat(h_data_cell(index,:));
    pad_p_data = zeroPaddingForDGT(p_data, shiftLen, fftLen);
    pad_h_data = zeroPaddingForDGT(h_data, shiftLen, fftLen);
    pad_audio_data = zeroPaddingForDGT(mix_data, shiftLen, fftLen);

    %% DGT
    win = generalizedCosWin(windowLen, 'hann');
    win = calcCanonicalTightWindow(win, shiftLen);
    diffWin = numericalDiffWin(win);
    spec = DGT(pad_audio_data, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);

    %% IF
    diffSpec = DGT(pad_audio_data, diffWin, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    IF = calcInstFreq(spec, diffSpec, fftLen, windowLen, rotateFlag);
    %iPCspec = instPhaseCorrection(spec,IF,shiftLen,fftLen);

    %% initialize
    X_init = pad_audio_data;
    mf_spec_h = MF_h(abs(spec), mf_len);
    mf_spec_p = MF_p(abs(spec), mf_len);
    WinnerFilter_h = WinnerFilter(mf_spec_h, mf_spec_p);
    WinnerFilter_p = WinnerFilter(mf_spec_p, mf_spec_h);

    Yh_init = spec .* WinnerFilter_h;
    Yp_init = spec .* WinnerFilter_p;
    Xh_init = invDGT(Yh_init, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
    Xp_init = invDGT(Yp_init, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);

    epsilon = 1e-3;
    Wh_init  = epsilon ./ (abs(Yh_init/max(abs(Yh_init(:)))) + epsilon);
    Wp_init  = epsilon ./ (abs(Yp_init/max(abs(Yp_init(:)))) + epsilon);

    %% Primal Dual Loop
    % lambda = 1.0;
    p_si_sdr_array = [];
    h_si_sdr_array = [];
     
    lambda = 10.^linspace(-3, 3, 20);
    for m = 1:length(lambda)
        X  = X_init;
        Yh = zeros(size(Yh_init));
        Yp = zeros(size(Yp_init));
        Xh = Xh_init;
        Xp = Xp_init;
        Wh = Wh_init;
        Wp = Wp_init; 
        
        iter_p_si_sdr_array = [];
        iter_h_si_sdr_array = [];
        
        tic
        for n = 1:50
            [Xh_, Xp_] = Px(X, (Xh - m1*TLh(Yh, win, Wh, IF, shiftLen, fftLen, rotateFlag, zeroPhaseFlag)), (Xp - m1*invDGT(Wp .* Yp, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag)));
            Zh = Yh + Lh(2*Xh_ - Xh, win, Wh, IF, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
            Zp = Yp + Wp .* DGT(2*Xp_ - Xp, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
            Yh_ = Zh - m2*Prox_fro(Zh/m2, 1/m2);
    %         Yp_ = Zp - lambda*m2*Prox_l2_1(Zp/(lambda*m2), 1/(m2*lambda));
            Yp_ = Zp - m2*Prox_l2_1(Zp/(m2), lambda(m)/(m2));
            Xh = Updater(Xh_, Xh, a);
            Xp = Updater(Xp_, Xp, a);
            Yh = Updater(Yh_, Yh, a);
            Yp = Updater(Yp_, Yp, a);
            
            if rem(n, 5) == 0
                iter_p_si_sdr_val = SI_SDR(pad_p_data, Xp);
                iter_h_si_sdr_val = SI_SDR(pad_h_data, Xh);
                
                iter_p_si_sdr_array = [iter_p_si_sdr_array iter_p_si_sdr_val];
                iter_h_si_sdr_array = [iter_h_si_sdr_array iter_h_si_sdr_val];
            end
        end
        toc
        
        iter_h_si_sdr_data_file_path = strcat(mat_data_folder, 'iter_h_sdr_result/',  'index', string(index), '/', 'lambda', string(m), '.mat');
        iter_p_si_sdr_data_file_path = strcat(mat_data_folder, 'iter_p_sdr_result/',  'index', string(index), '/', 'lambda', string(m), '.mat');
        save(iter_h_si_sdr_data_file_path, 'iter_h_si_sdr_array');
        save(iter_p_si_sdr_data_file_path, 'iter_p_si_sdr_array');
       %% Evaluate
        PDR_result_data_file_path = strcat(mat_data_folder, 'pdr_result/', 'index', string(index), '/', 'lambda', string(m), '.mat'); 
        save(PDR_result_data_file_path, 'Xp', 'Xh');
        p_si_sdr_val = SI_SDR(pad_p_data, Xp);
        h_si_sdr_val = SI_SDR(pad_h_data, Xh);
        
        p_si_sdr_array = [p_si_sdr_array p_si_sdr_val];
        h_si_sdr_array = [h_si_sdr_array h_si_sdr_val];
    end
    p_si_sdr_mat_file_name = strcat(p_si_sdr_mat_folder_path, 'index', string(index), '.mat');
    h_si_sdr_mat_file_name = strcat(h_si_sdr_mat_folder_path, 'index', string(index), '.mat');
    save(p_si_sdr_mat_file_name, 'p_si_sdr_array');
    save(h_si_sdr_mat_file_name, 'h_si_sdr_array');
end
