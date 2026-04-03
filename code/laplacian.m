function L = laplacian(A)
% Graph Laplacian from adjacency A
deg = sum(A,2);
L = diag(deg) - A;
end
