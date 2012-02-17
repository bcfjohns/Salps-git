theta = sym('theta', 'real');
psi = sym('psi', 'real');
T = [1 0        -sin(theta);
     0 cos(psi)  cos(theta)*sin(psi);
     0 -sin(psi) cos(theta)*cos(psi)];
invT = simplify(inv(T))