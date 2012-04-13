function [radius, omega, speed, RsqMean, phase] = getHelixParams(time, positions, angles)
%assumes data is column wise that is x is in the first column, y 2nd ...
RsqMean = 1; %mean of the Rsquared values from the three fits.
angle2 = angles(:,2);
angle1 = angles(:,1);
L = length(angle1);
T = floor(L/4);

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

%if things seem low print out, so can try and ID whats up.
if (xRsq<0.96 | yRsq<0.96 | zRsq<0.96)
    disp('r-sqaured values too small');
    disp([xRsq yRsq zRsq]); 
end

RsqMean = mean([xRsq yRsq zRsq]);
speed = norm([xfit(2) yfit(2) zfit(2)]);
radius = mean([abs(xfit(3)) abs(yfit(3)) abs(zfit(3))]);
omega = mean(abs([xfit(4) yfit(4) zfit(4)]));

%alter phase as needed depending on sign of magnitude and frequency
if yfit(3)<0 %negative amplitude
    if yfit(4)<0 %negative 
        phase = -yfit(5);
    else
        phase = yfit(5)+pi;
    end
else
    if yfit(4)<0 %negative 
        phase = -yfit(5)+pi;
    else
        phase = yfit(5);
    end
end
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