%Benjamin Johnson editing to play with parameters to get a tighter spiral
%salps params old
%All the parameters for the salp simulation
%all units are assumed to be degrees and mks
clear all;
close all;
clc;
global uAmplitudeEven xFinal valueHist alphaHist u1axis u2axis ...
    frontConnect backConnect connectR


%=============================================================
%general parameters
sLength = 0.14; %the length of a salp
sRadius = 0.02; %the radius of the salp.



%%=================================================================
%Parameters for the salp body 
%
%all frames of a single body are assumed to be aligned with CS1 (the front
%connection), which is then rotated with respect to the adjoining frame
%(the back connection of the previous salp).
%z points in the direction of forward travel. x is the "left-right"
%direction where salps are to the left and right of each other.
%%=================================================================
% 
sMass = 0.04; %about 40 grams %Mass of the salp
% giantMass = sMass*90;
% CURRENTLY ARBITRARY!
sInertia = [.0008 0 0; 0 .0008 0; 0 0 .0004]; %moment of inertia tensor of the salp.
% giantInertia = sInertia*30;
%CS1->CG
%vector pointing from the forward connection point (CS1) to the center of
%gravity (CG) in components of the body coordinate frame.
frontConnect = [0 -sRadius*1.1 -sLength]; 

%CG->CS2
%vector pointing from the center fo gravity (CG) to the back connection
%point (CS2) in components of the body coordinate frames.
backConnect = [0 sRadius*1.1 -sLength];

%axis of revolution of the universal joint
u1axis = [1 0 0];
u2axis = [0 1 0];

%CG->CS3
%the vector from the center of gravity to where the propulsion acts (CS3)
propulsionPosition = [0 0 -sLength*0.5];

%CS2_prev->CS1_current
%orientation vector of Euler angles (x y z) of one salp with respect to the
%previous salp. Orientation of CS1 to adjoining.
connectR = [0 0 170]; 
%The pi is necessary to "flip" each salp so the connections flip sides from
%salp to salp.

relRotInit = [0 0]; %the initial angles of the universal joint between salps

%Center of pressure position
COPPosition = [0 0 -sLength];

%Params for limiting the motion of the universal joint
angleLimit = 90; %needs to be in same units as angle sensor (degrees)
angleConstraintK = 400; %spring constant,
angleConstraintB = 25; %damping constant. a little over damped

%spring constant for springs joining a small mass that has the drag force
%applied to it to the main salp body.
kDrag = [360 360 360 100 100 100]*100*sMass;

%damping coefficients for same springs to get critically damped system
bDrag = 2*sqrt(kDrag*1.01*sMass);
%[360 360 360 10 10 10]*10;


%%=========================================
rho_water = 1e3;

%10times should only be temporary
cDrag = 30*rho_water*pi*[sRadius*sLength sRadius*sLength sRadius^2 ...
     2*sRadius*sLength^2*(pi*sLength/360) 2*sRadius*sLength^2*(pi*sLength/360) ...
     2*sLength*sRadius^2*2*pi*sRadius/360];
 %shrink angular drag by some factor
 cDrag(4:6) = cDrag(4:6)/380;
 %giantDrag = cDrag*90;
%6 drag coefficients for translational and angular 
%components. should be greater than 0 for drag.
%extra 1/10th in z rotation term, since just skin drag.
%temporariliy only leaving in one coeff, because want to test things.
%cDrag([1:2 3:5]) = zeros(1,5);
%cDrag(6) = 0;

%===========
% uFrequency = 1; %frequency for the base drive signal
% uDelay = 0.1; %delay for force signal between salps
%uAmplitudeOdd = [0.2 0.2 2];
uAmplitudeEven = [-0.2 0.2 2];
linPwrLimit = 0.1; %the maximal 1/velocity value
rotPwrLimit = 0.1; %the maximal 1/angular velocity value.
%uBias = 1; %bias is added before the amplitude scaling.
PropSignSw = [-1 -1 1];

oddTorque = [0 0 0];%0.1];
evenTorque = oddTorque; %[0 0 .1];


%allows the simulation to see the initial state variable

% stochGradSalp