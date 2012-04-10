function [radius, omega, speed] = getHelixParams(time, positions, angles)
%assumes data is column wise that is x is in the first column, y 2nd ...

%trim off transient behavior

angle2 = angles(:,2);
angle1 = angles(:,1);
L = length(angle1);
T = 200;

[min1, max1] = minAndMaxMarg(angle1(L-T:L));
[min2, max2] = minAndMaxMarg(angle2(L-T:L));

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


timeSS = time(smallestIndex:end);
positionSS = positions(smallestIndex:end, :);

[xfit, xRsq] = linSinFit(timeSS, positionSS(:,1));
[yfit, yRsq] = linSinFit(timeSS, positionSS(:,2));
[zfit, zRsq] = linSinFit(timeSS, positionSS(:,3));

speed = norm([xfit(2) yfit(2) zfit(2)]);
radius = mean([xfit(3) yfit(3) zfit(3)]);
omega = mean([xfit(4) yfit(4) zfit(4)]);
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