function y = Prox_l2_1(x, p)
    l2_t = sqrt(sum(abs(x).^2, 1));
    right_term = max(1-(p./l2_t), 0);
    y = right_term.*x;
end