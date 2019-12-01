function y = WinnerFilter(x, y)
    y = Power(x) ./ (Power(x) + Power(y));
end

function y = Power(x)
    y = abs(x).^2;
end