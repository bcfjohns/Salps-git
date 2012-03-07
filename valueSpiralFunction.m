
function cost = valueSpiralFunction()
global Salp1_PandV Salp1_angles backConnect

%find steady state indices based on angles
T = 50*5; %at least one period to define the range we'll use.
time = Salp1_angles.time;
angle2 = Salp1_angles.signals(2).values;
angle1 = Salp1_angles.signals(1).values;
L = length(angle1);


[min1, max1] = minAndMaxMarg(angle1(L-T:L));
[min2, max2] = minAndMaxMarg(angle2(L-T:L));
% 
% min2 = min(angle2(L-T:L));
% min2 = min2-margin*range(min2);
% 
% max2 = max(angle2(L-T:L));
% max2 = max2+margin*range(max2);

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

%fit x,y and z positions to linear plus sine to determine velocity
positions = Salp1_PandV.signals(1).values(smallestIndex:L,:);
[xfit, xRsq] = linSinFit(time(smallestIndex:L), positions(:,1));
[yfit, yRsq] = linSinFit(time(smallestIndex:L), positions(:,2));
[zfit, zRsq] = linSinFit(time(smallestIndex:L), positions(:,3));
cost = -norm([xfit(2) yfit(2) zfit(2)]); %the cost is the negative of the
%velocity, that is the the slope of the linear term from the fits.

%add in a component of the cost that value a larger radius salp.
cost = cost - norm([xfit(3) yfit(3) zfit(3)]);
%add in with the lengths, so don't get longer and longer things.
cost = cost + norm(10*backConnect)^2;
end

function [mini, maxi] = minAndMaxMarg(nums)
    margin = 0.1*range(nums); %what margin to use, so don't cut data off if just a little different
    minMargin = 0.05;

    maxi = max(nums);
    mini = min(nums);

    %if the actual value of the margin, such as 10% is too small 
    if (margin <minMargin)
        %add/subtract a minimum amount for the margin
        mini = mini-minMargin;
        maxi = maxi+minMargin;
    else
        mini = mini-margin;
        maxi = maxi+margin;
    end
end
