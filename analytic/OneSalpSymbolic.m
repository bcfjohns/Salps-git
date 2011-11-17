%Variables will be designated Lsf with L the Letter of the variable name, s
%any particle subscript for what I'm refering to and f refers to the frame
%g for global l for local, so Fpl is the local propulsion force.

%=======================================================
%define local constants
% ==================================================

Fpl = sym('Fpl', [3 1]); 
Fpl = sym(Fpl, 'positive');
%propulsion in the local frame, all values are positive because since I'm
%assuming cylindrical symmetry and negative value would just put something
%in a different quadrant, and I always want the center of pressure behind
%the center of mass

rpl = sym('rpl', [3 1]); 
rpl = sym(rpl, 'positive');
%vector from center of mass to the point the propulsion hits at. Same
%arguments for positiveness as for propulsion.

d_cp = sym('d_cp', 'positive'); 
%the distance the center of pressure is behind the center of mass in the 
%local frame. Assume centered when viewed fro mthe front so just need the
%one number.

rcop_l = sym([0; 0; d_cp]); %vector to center of pressure in the local frame.

c = sym('c', [3 1]); %local drag coefficients as a vector
c = sym(c, 'positive');
c = -c; %cause want drag coefficients negative.

b = sym('b', [3 1]); %local drag coefficients for spinning
b = sym(b, 'positive');
b = -b;

%moment of inertia tensor in local frame, assuming it's diagonal
%and due to symmetry Ixx and Iyy are the same
Izz = sym('Izz', 'real');
Iyy = sym('Iyy', 'real');

Iil = diag([Iyy Iyy Izz]);

%======================================================================
%Rotation matrix definition
%converts from local to global coordinates
%======================================================================

phi = sym('phi', 'real');
theta = sym('theta', 'real');
psi = sym('psi', 'real');

Rphi = [cos(phi) sin(phi) 0;
        -sin(phi) cos(phi) 0;
        0           0       1];

Rtheta = [1 0           0;
          0 cos(theta)  sin(theta);
          0 -sin(theta) cos(theta)];
Rpsi = [cos(psi) sin(psi) 0
       -sin(psi) cos(psi) 0;
            0       0     1];
 
Rlg = Rpsi*Rtheta*Rphi;
Rgl = simplify(inv(Rlg));
%====================================================================
%Global state variables and the related local variables
%===================================================================

orientation = [phi; theta; psi];
omega_g = sym('omega_g', [3 1]);
omega_g = sym(omega_g, 'real');
omega_l = Rgl*omega_g;

vg = sym('vg', [3 1]);
vg = sym(vg, 'real'); %velocity in the global frame
vl = Rgl*vg; %velocity in the global frame

%Drag equations
Fdl = c.*vl.^2;
Fdg = simplify(Rlg*Fdl);

Tdl = b.*omega_g.^2;
Tdg = simplify(Rlg*Tdl);



%======================================================================
%Give global equations

%the mass*acceleration equations
MAg = simplify(Rlg*Fpl+Fdg)
omega_global = simplify(inv(Rlg*Iil))*(simplify(cross(Rlg*rpl, Rlg*Fpl))+...
                             simplify(cross(Rlg*rcop_l, Fdg))+Tdg)



%result
% MAg =
%  
%  Fpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + Fpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + Fpl3*sin(psi)*sin(theta) - c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 - c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2
%  Fpl3*cos(psi)*sin(theta) - Fpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - Fpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2
%                                                                                                                                                Fpl3*cos(theta) - c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta) + c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 - c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2
%  
%  
% omega_global =
%  
%    (sin(phi)*sin(theta)*(b2*cos(phi)*sin(theta)*omega_g2^2 - b1*sin(phi)*sin(theta)*omega_g1^2 - b3*cos(theta)*omega_g3^2 - Fpl1*rpl2*cos(theta) + Fpl2*rpl1*cos(theta) - Fpl1*rpl3*cos(phi)*sin(theta) + Fpl3*rpl1*cos(phi)*sin(theta) - Fpl2*rpl3*sin(phi)*sin(theta) + Fpl3*rpl2*sin(phi)*sin(theta) + d_cp*cos(psi)*sin(theta)*(c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 + c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*sin(psi)*sin(theta)*(c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2)))/Iyy - ((cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(b1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*omega_g1^2 + b2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*omega_g2^2 - b3*cos(psi)*sin(theta)*omega_g3^2 + (rpl3*cos(theta) - rpl2*cos(phi)*sin(theta) + rpl1*sin(phi)*sin(theta))*(Fpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + Fpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + Fpl3*sin(psi)*sin(theta)) - (rpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + rpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + rpl3*sin(psi)*sin(theta))*(Fpl3*cos(theta) - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta)) - d_cp*cos(theta)*(c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 + c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*sin(psi)*sin(theta)*(c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2)))/Iyy - ((cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(b1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*omega_g1^2 + b2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*omega_g2^2 + b3*sin(psi)*sin(theta)*omega_g3^2 - (rpl3*cos(theta) - rpl2*cos(phi)*sin(theta) + rpl1*sin(phi)*sin(theta))*(Fpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + Fpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - Fpl3*cos(psi)*sin(theta)) + (rpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + rpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - rpl3*cos(psi)*sin(theta))*(Fpl3*cos(theta) - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta)) + d_cp*cos(theta)*(c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*cos(psi)*sin(theta)*(c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2)))/Iyy
%  - ((cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(b1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*omega_g1^2 + b2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*omega_g2^2 + b3*sin(psi)*sin(theta)*omega_g3^2 - (rpl3*cos(theta) - rpl2*cos(phi)*sin(theta) + rpl1*sin(phi)*sin(theta))*(Fpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + Fpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - Fpl3*cos(psi)*sin(theta)) + (rpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + rpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - rpl3*cos(psi)*sin(theta))*(Fpl3*cos(theta) - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta)) + d_cp*cos(theta)*(c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*cos(psi)*sin(theta)*(c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2)))/Iyy - ((sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(b1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*omega_g1^2 + b2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*omega_g2^2 - b3*cos(psi)*sin(theta)*omega_g3^2 + (rpl3*cos(theta) - rpl2*cos(phi)*sin(theta) + rpl1*sin(phi)*sin(theta))*(Fpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + Fpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + Fpl3*sin(psi)*sin(theta)) - (rpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + rpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + rpl3*sin(psi)*sin(theta))*(Fpl3*cos(theta) - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta)) - d_cp*cos(theta)*(c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 + c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*sin(psi)*sin(theta)*(c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2)))/Iyy - (cos(phi)*sin(theta)*(b2*cos(phi)*sin(theta)*omega_g2^2 - b1*sin(phi)*sin(theta)*omega_g1^2 - b3*cos(theta)*omega_g3^2 - Fpl1*rpl2*cos(theta) + Fpl2*rpl1*cos(theta) - Fpl1*rpl3*cos(phi)*sin(theta) + Fpl3*rpl1*cos(phi)*sin(theta) - Fpl2*rpl3*sin(phi)*sin(theta) + Fpl3*rpl2*sin(phi)*sin(theta) + d_cp*cos(psi)*sin(theta)*(c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 + c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*sin(psi)*sin(theta)*(c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2)))/Iyy
%                                                                           (cos(theta)*(b2*cos(phi)*sin(theta)*omega_g2^2 - b1*sin(phi)*sin(theta)*omega_g1^2 - b3*cos(theta)*omega_g3^2 - Fpl1*rpl2*cos(theta) + Fpl2*rpl1*cos(theta) - Fpl1*rpl3*cos(phi)*sin(theta) + Fpl3*rpl1*cos(phi)*sin(theta) - Fpl2*rpl3*sin(phi)*sin(theta) + Fpl3*rpl2*sin(phi)*sin(theta) + d_cp*cos(psi)*sin(theta)*(c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 + c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*sin(psi)*sin(theta)*(c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2)))/Izz - (sin(psi)*sin(theta)*(b1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*omega_g1^2 + b2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*omega_g2^2 + b3*sin(psi)*sin(theta)*omega_g3^2 - (rpl3*cos(theta) - rpl2*cos(phi)*sin(theta) + rpl1*sin(phi)*sin(theta))*(Fpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + Fpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - Fpl3*cos(psi)*sin(theta)) + (rpl1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + rpl2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - rpl3*cos(psi)*sin(theta))*(Fpl3*cos(theta) - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta)) + d_cp*cos(theta)*(c2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 - c3*cos(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*cos(psi)*sin(theta)*(c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2)))/Izz + (cos(psi)*sin(theta)*(b1*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi))*omega_g1^2 + b2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta))*omega_g2^2 - b3*cos(psi)*sin(theta)*omega_g3^2 + (rpl3*cos(theta) - rpl2*cos(phi)*sin(theta) + rpl1*sin(phi)*sin(theta))*(Fpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + Fpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + Fpl3*sin(psi)*sin(theta)) - (rpl1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) + rpl2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + rpl3*sin(psi)*sin(theta))*(Fpl3*cos(theta) - Fpl2*cos(phi)*sin(theta) + Fpl1*sin(phi)*sin(theta)) - d_cp*cos(theta)*(c2*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi))*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi))*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2 + c3*sin(psi)*sin(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2) + d_cp*sin(psi)*sin(theta)*(c3*cos(theta)*(vg3*cos(theta) + vg2*cos(psi)*sin(theta) + vg1*sin(psi)*sin(theta))^2 - c2*cos(phi)*sin(theta)*(vg2*(sin(phi)*sin(psi) - cos(phi)*cos(psi)*cos(theta)) - vg1*(cos(psi)*sin(phi) + cos(phi)*cos(theta)*sin(psi)) + vg3*cos(phi)*sin(theta))^2 + c1*sin(phi)*sin(theta)*(vg1*(cos(phi)*cos(psi) - cos(theta)*sin(phi)*sin(psi)) - vg2*(cos(phi)*sin(psi) + cos(psi)*cos(theta)*sin(phi)) + vg3*sin(phi)*sin(theta))^2)))/Izz
%  


