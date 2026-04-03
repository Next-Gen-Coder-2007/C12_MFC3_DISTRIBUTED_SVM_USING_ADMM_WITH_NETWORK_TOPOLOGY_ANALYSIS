function [lb, ub] = ramanujan_bounds_lambda2(d)
% Bounds for lambda2 for d-regular graphs (Ramanujan bounds), eq. (12)
% d - 2*sqrt(d-1) <= lambda2 <= d + 2*sqrt(d-1)
lb = d - 2*sqrt(d-1);
ub = d + 2*sqrt(d-1);
end
