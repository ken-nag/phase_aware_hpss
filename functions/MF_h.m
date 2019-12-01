function y = MF_h(x, mf_len)
    y = medfilt1(x, mf_len, [], 2);
end