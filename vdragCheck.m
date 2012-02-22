% for ii = 1:100

c = randn(3,1);
v = 4*randn(3,1);

Cmat = diag(c);
fdrag1 = Cmat*(v.*abs(v))
fdrag2 = (dot(c,v)*(dot(v/norm(v),v)))*v/norm(v)
% residual = norm((fdrag1-fdrag2)/fdrag1)

% end