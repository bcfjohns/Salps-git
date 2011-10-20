function failureAnal()
%analyize salpRun3 to try and figure out why things didn't converge and
%oscillated, so much. To see if steady state has anything to do with it.

%rerun a simulation
%show plots
%ask me if it's steady state or not
y = 'y';
n = 'n';
observation = input('Did this steady state at the end? (y/n)');
%add point to plot appropriately color coded.

end

%-----------------------copied from stochGradSalp----------------------

function cost = valueFunction()
global Salp1_PandV Salp1_angles

%find steady state indices based on angles
T = 50*5; %at least one period to define the range we'll use.
margin = 0.1; %what margin to use, so don't cut data off if just a little different
time = Salp1_angles.time;
angle2 = Salp1_angles.signals(2).values;
angle1 = Salp1_angles.signals(1).values;
L = length(angle1);


min1 = min(angle1(L-T:L));
min1 = min1-margin*range(min1);

max1 = max(angle1(L-T:L));
max1 = max1+margin*range(max1);

min2 = min(angle2(L-T:L));
min2 = min2-margin*range(min2);

max2 = max(angle2(L-T:L));
max2 = max2+margin*range(max2);

smallestIndex = L-T;

jump = T;
while(smallestIndex > T)
angle1Part = angle1(smallestIndex-jump:smallestIndex);
angle2Part = angle2(smallestIndex-jump:smallestIndex);
    if(min(angle1Part) > min1 && min(angle2Part) > min2 && ...
            max(angle1Part) < max1 && max(angle2Part) < max2)
        smallestIndex = smallestIndex-jump;
    else
        break;
    end
end

figure(1)
plot(time(1:smallestIndex), angle1(1:smallestIndex), 'r');
hold on;
plot(time(smallestIndex: L), angle1(smallestIndex:L), 'b');
plot(time, min1*ones(L,1), '--k');
plot(time, max1*ones(L,1), '--k');
hold off;
title('angle1');
axis([0 time(L) min1-0.1 max1+0.1]);

figure(2);
plot(time(1:smallestIndex), angle2(1:smallestIndex), 'r');
hold on;
plot(time(smallestIndex: L), angle2(smallestIndex:L), 'b');
plot(time, min2*ones(L,1), '--k');
plot(time, max2*ones(L,1), '--k');
hold off;
title('angle2');
axis([0 time(L) min2-0.1 max2+0.1]);


% velocities = Salp1_PandV.signals(2).values(smallestIndex:L, :);
% velocity = sqrt(sum(velocities.^2,2));
% avgVeloc = mean(velocity);
% cost = -avgVeloc;
positions = Salp1_PandV.signals(2).values([smallestIndex L],:);
dpos = diff(positions)/(L-smallestIndex+1);
cost = -norm(dpos);
end


function setUAmplitudeEven(alpha)
global uAmplitudeEven
mag = 2;
%trying to assign angles, so a change in either will change z, when it's at
%the singularity point.
uAmplitudeEven(3) = mag*cos(alpha(2))*cos(alpha(1));
uAmplitudeEven(1) = -mag*cos(alpha(2))*sin(alpha(1));
uAmplitudeEven(2) = mag*sin(alpha(2));

uAmplitudeEven = uAmplitudeEven
end