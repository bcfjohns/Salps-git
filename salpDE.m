function stateD = salpDE(time, state)
%This implements the equations I derived by newton's laws for a single
%salp, to compare to the results from SimMechanics

salpsParams

stateD = zeros(12,1);
%xdot = x dot
globalVel = state(4:6);
stateD(1:3) = globalVel;

%prepare for x double dot
psi = state(7);
Rx = [1 0           0;
      0 cos(psi)  sin(psi);
      0 -sin(psi) cos(psi)];

theta = state(8);  
Ry = [cos(theta) 0 -sin(theta);
      0          1 0;
      sin(theta) 0  cos(theta)];
 

phi = state(9);
Rz = [cos(phi)  sin(phi) 0;
      -sin(phi) cos(phi) 0;
      0           0          1];
R = Rx*Ry*Rz;

%compute translational drag
localVel = R*globalVel;
Fdrag = cDrag(1:3)'.*localVel.*abs(localVel);

%set x doubledot
stateD(4:6) = R'*(uAmplitudeEven'-Fdrag)./sMass;
% theta = state(8);
% psi = state(7);

%This is for world axis
% T = [cos(theta)*cos(psi)  -sin(psi) 0;
%     cos(theta)*sin(psi) cos(psi) 0;
%     -sin(theta) 0 1];
%for body axis components
T = [1 0        -sin(theta);
     0 cos(psi)  cos(theta)*sin(psi);
     0 -sin(psi) cos(theta)*cos(psi)];

%invers of T computed symbolically for omegas in world frame:
% invT =[ cos(psi)/cos(theta), sin(psi)/cos(theta), 0;
%                   -sin(psi),            cos(psi), 0;
%         cos(psi)*tan(theta), sin(psi)*tan(theta), 1];
%For body frame
invT=[1, sin(psi)*tan(theta), cos(psi)*tan(theta);
      0,            cos(psi),           -sin(psi);
      0, sin(psi)/cos(theta), cos(psi)/cos(theta)];
    
%set time derivaties of the Euler angles
stateD(7:9) = invT*state(10:12);

wx = state(10);
wy = state(11);
wz = state(12);

%assume moment of Inertia is diagonal
Ix = sInertia(1,1);
Iy = sInertia(2,2);
Iz = sInertia(3,3);

invInertia = [1/Ix 0 0; 0 1/Iy 0; 0 0 1/Iz];

Tdrag = -cDrag(4:6)'.*abs(state(10:12)).*state(10:12);

stateD(10:12) = invInertia*[(Iy-Iz)*wz*wy; (Iz-Ix)*wz*wx; (Ix-Iy)*wx*wy]...
    + invInertia*(cross(propulsionPosition', uAmplitudeEven') + evenTorque' + ...
    - cross(COPPosition', Fdrag)+Tdrag);



