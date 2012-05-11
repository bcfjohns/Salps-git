
function setUAmplitudeEven(alpha)
% uAmplitudeEven = zeros(1,3);
global uAmplitudeEven
mag = 2;
%trying to assign angles, so a change in either will change z, when it's at
%the singularity point.
uAmplitudeEven(3) = mag*cos(alpha(2))*cos(alpha(1));
uAmplitudeEven(1) = -mag*cos(alpha(2))*sin(alpha(1));
uAmplitudeEven(2) = mag*sin(alpha(2));
% assignin('base', 'uAmplitudeEven', uAmplitudeEven);
end