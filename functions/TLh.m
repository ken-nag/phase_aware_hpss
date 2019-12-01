function y = TLh(x, win, W, IF, shiftLen, fftLen, rotateFlag, zeroPhaseFlag)
    temp_x = TDt(W.*x);
%     temp_w = ones(size(temp_x));
%     temp_x = temp_x .* temp_w;
   spec = invInstPhaseCorrection(temp_x, IF,shiftLen,fftLen);
   y = invDGT(spec, win, shiftLen, fftLen, rotateFlag, zeroPhaseFlag);
end

function y = TDt(x)
%     y = [x(1,:) ; (x(2:end,:) - x(1:end-1,:)); -x(end,:)];
    y = x - [x(:,end) x(:,1:end-1)];
end