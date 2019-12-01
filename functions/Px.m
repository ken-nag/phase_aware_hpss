function [Xh_, Xp_] = Px(X, Xh, Xp)
    diff = (X - Xh -Xp)/2;
    Xh_ = Xh + diff;
    Xp_ = Xp + diff;
end