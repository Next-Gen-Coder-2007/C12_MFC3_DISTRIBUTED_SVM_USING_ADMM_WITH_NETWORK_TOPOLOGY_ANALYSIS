function tf = is_ramanujan(A)
% Check Ramanujan condition via adjacency eigenvalues
% A is adjacency; Ramanujan if mu2 <= 2*sqrt(d-1)
d = round(mean(sum(A,2)));
eA = sort(eig(A), 'descend');
mu2 = max(eA(2), abs(eA(end)));
tf = (mu2 <= 2*sqrt(d-1)+1e-8);
end
