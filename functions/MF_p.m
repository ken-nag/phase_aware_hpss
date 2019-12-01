function y = MF_p(x, mf_len)
    y = medfilt1(x, mf_len, [], 1);
end