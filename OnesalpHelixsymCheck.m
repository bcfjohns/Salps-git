psi = sym('psi', 'real');
theta = sym('theta', 'real'); 
phi = sym('phi', 'real');

Rx = [1 0           0;
      0 cos(psi)  sin(psi);
      0 -sin(psi) cos(psi)];

Ry = [cos(theta) 0 -sin(theta);
      0          1 0;
      sin(theta) 0  cos(theta)];
 

Rz = [cos(phi)  sin(phi) 0;
      -sin(phi) cos(phi) 0;
      0           0          1];
R = Rx*Ry*Rz
R = simplify(R)
