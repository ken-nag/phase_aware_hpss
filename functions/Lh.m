function y = Lh(x, win, W, IF, shiftLen, fftLen, rotateFlag, zeroPhaseFlag)
    spec = DGT(x,win,shiftLen,fftLen,rotateFlag,zeroPhaseFlag);
    y = W.*Dt(instPhaseCorrection(spec, IF, shiftLen, fftLen));
end

function y = Dt(x)
    y = x - [x(:,2:end) x(:,1)];
end