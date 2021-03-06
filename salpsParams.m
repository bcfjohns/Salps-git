%Benjamin Johnson editing to play with parameters

%All the parameters for the salp simulation
%all units are assumed to be degrees and mks
clear all;
close all;
global uAmplitudeEven xFinal valueHist alphaHist

%=============================================================
%general parameters
sLength = 0.16; %the length of a salp
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
% CURRENTLY ARBITRARY!
sMass = 100; %Mass of the salp

% CURRENTLY ARBITRARY!
sInertia = [.1 0 0; 0 .1 0; 0 0 .03]; %moment of inertia tensor of the salp.


%CS1->CG
%vector pointing from the forward connection point (CS1) to the center of
%gravity (CG) in components of the body coordinate frame.
frontConnect = [0 -sRadius*1.1 -sLength]; 

%CG->CS2
%vector pointing from the center fo gravity (CG) to the back connection
%point (CS2) in components of the body coordinate frames.
backConnect = [0 sRadius*1.1 -sLength];

%CG->CS3
%the vector from the center of gravity to where the propulsion acts (CS3)
propulsionPosition = [0 sRadius*0.5 -sLength*0.5];

%CS2_prev->CS1_current
%orientation vector of Euler angles (x y z) of one salp with respect to the
%previous salp. Orientation of CS1 to adjoining.
connectR = [14.8581-.028-5.46e-05-1e-4 -59.8797-3.4805-0.1162-0.0037 0]; 
%can use this to set the initial orientation fo the salp, when there's only
%one.

relRotInit = [0 0]; %the initial angles of the universal joint between salps

%Center of pressure position
COPPosition = [0 0 -sLength];

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
uAmplitudeEven = [-.1 0 1];
%uBias = 1; %bias is added before the amplitude scaling.


%allows the simulation to see the initial state variable


% stochGradSalp



