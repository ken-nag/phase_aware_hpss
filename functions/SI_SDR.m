function y = SI_SDR(s, s_)
    alpha = Inner_product(s, s_) / Inner_product(s, s); 
    y = 20*log10(norm(alpha*s) / norm(alpha*s - s_));
end

function y = Inner_product(v, u)
    y = v' * u; 
end