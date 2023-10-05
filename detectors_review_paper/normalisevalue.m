function [y] = normalisevalue(x)

y = x/sum(x(isfinite(x)));
end