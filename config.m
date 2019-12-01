%% DGT Parameters
windowLen     = 2^12;
shiftLen      = windowLen/4;
fftLen        = windowLen;
rotateFlag    = true;
zeroPhaseFlag = true;

%% Median Filter Parameters
mf_len =17;

%% Primal-dual Splitting Parameters
k        = 0.001;
a        = 0.5;
m1       = 1;
m2       = 0.25;
iter_num = 100;
%% save as mat
file_name = './MF_hpss/config.mat';
save(file_name,...
    'windowLen', 'shiftLen', 'fftLen','rotateFlag', 'zeroPhaseFlag',...
    'mf_len',...
    'k', 'a', 'm1', 'm2', 'iter_num');