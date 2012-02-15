%Benjamin Johnson editing to play with parameters to get a tighter spiral

%All the parameters for the salp simulation
%all units are assumed to be degrees and mks
%clear all;
%close all;
global uAmplitudeEven xFinal valueHist alphaHist oddTorque evenTorque

%=============================================================
%general parameters
sLength = 1; %the length of a salp
sRadius = 0.5; %the radius of the salp.



%%=================================================================
%Parameters for the salp body 
%
%all frames of a single body are assumed to be aligned with CS1 (the front
%connection), which is then rotated with respect to the adjoining frame
%(the back connection of the previous salp).
%z points in the direction of forward travel. x is the "left-right"
%direction where salps are to the left and right of each other.
%%=================================================================
% CURRENTLY ARBITRARY!
sMass = 1; %about 40 grams %Mass of the salp

% CURRENTLY ARBITRARY!
sInertia = eye(3); %moment of inertia tensor of the salp.


%CS1->CG
%vector pointing from the forward connection point (CS1) to the center of
%gravity (CG) in components of the body coordinate frame.
frontConnect = [0 -sRadius*1 -sLength]; 

%CG->CS2
%vector pointing from the center fo gravity (CG) to the back connection
%point (CS2) in components of the body coordinate frames.
backConnect = [0 sRadius*1 -sLength];

%CG->CS3
%the vector from the center of gravity to where the propulsion acts (CS3)
propulsionPosition = [0 0 0];% -sLength]; %[0 sRadius*0.5 -sLength*0.5];

%CS2_prev->CS1_current
%orientation vector of Euler angles (x y z) of one salp with respect to the
%previous salp. Orientation of CS1 to adjoining.
connectR = [0 0 0];% [-35.273179319375458 -44.991438141137614 0];
%can use this to set the initial orientation fo the salp, when there's only
%one.

relRotInit = [0 0]; %the initial angles of the universal joint between salps


%Params for limiting the motion of the universal joint
angleLimit = 90; %needs to be in same units as angle sensor (degrees)
angleConstraintK = 400; %spring constant,
angleConstraintB = 25; %damping constant. a little over damped

%Center of pressure position
COPPosition = [0 0 -sLength];

%spring constant for springs joining a small mass that has the drag force
%applied to it to the main salp body.
kDrag = [360 360 360 100 100 100]*sMass;%*100

%damping coefficients for same springs to get critically damped system
bDrag = 2*sqrt(kDrag*1.01*sMass);
%[360 360 360 10 10 10]*10;


%%=========================================
rho_water = 1e3;

%10times should only be temporary
% cDrag = 30*rho_water*pi*[sRadius*sLength sRadius*sLength sRadius^2 ...
%      2*sRadius*sLength^2*(pi*sLength/360) 2*sRadius*sLength^2*(pi*sLength/360) ...
%      2*sLength*sRadius^2*2*pi*sRadius/360];
%  %shrink angular drag by some factor
%  cDrag(4:6) = cDrag(4:6)*2*sRadius*pi/360;
cDrag = ones(1,6);

%6 drag coefficients for translational and angular 
%components. should be greater than 0 for drag.
%extra 1/10th in z rotation term, since just skin drag.


%===========
%uAmplitudeOdd = [0.2 0.2 2];
uAmplitudeEven = [0 10 0];%[-.1 0 1];
oddTorque = [0 0 0];
evenTorque = oddTorque; %[0 0 .1];
%allows the simulation to see the initial state variable


% stochGradSalp



