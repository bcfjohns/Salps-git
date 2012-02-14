function stateD = salpDE(t, state)
%This implements the equations I derived by newton's laws for a single
%salp, to compare to the results from SimMechanics

salpsParams

stateD = zeros(12,1);
%xdot = x dot
stateD(1:3) = state(4:6);

%prepare for x double dot
t = state(7);
Rx = [1 0   0;
      0 cos(t) -sin(t);
      0 sin(t)  cos(t)];

t = state(8);  
Ry = [cos(t) 0 sin(t);
     0       1 0;
     -sin(t) 0  cos(t)];
 

t = state(9);
Rz = [cos(t) -sin(t) 0;
      sin(t)  cos(t) 0;
      0         0    1];
R = Rx*Ry*Rz;

%compute translational drag
Fdrag = -cDrag(1:3)'.*(R*state(4:6)).*abs(state(4:6));

%set x doubledot
stateD(4:6) = R'/sMass*(uAmplitudeEven'+Fdrag);
theta = state(8);
psi = state(7);

T = [1 0 -sin(theta);
    0 cos(psi) cos(theta)*sin(psi);
    0 -sin(psi) cos(theta)*cos(psi)];
%set time derivaties of the Euler angles
stateD(7:9) = inv(T)*state(10:12);

wx = state(10);
wy = state(11);
wz = state(12);

%assume moment of Inertia is diagonal
Ix = sInertia(1,1);
Iy = sInertia(2,2);
Iz = sInertia(3,3);

Tdrag = -cDrag(4:6)'.*abs(state(10:12)).*state(10:12);

stateD(10:12) = inv(sInertia)*[(Iy-Iz)*wz*wy; (Iz-Ix)*wz*wx; (Ix-Iy)*wx*wy]...
    + inv(sInertia)*(cross(propulsionPosition', uAmplitudeEven') + evenTorque' + ...
    + cross(COPPosition', Fdrag)+Tdrag);



