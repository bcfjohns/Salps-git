function EA = rmToEAzyx(rm)
%Takes a rotation matrix and returns three angles that would form rm via
%Rx*Ry*Rz
%code transformed from psuedo code on page 10 of 
%http://www.geometrictools.com/Documentation/EulerAngles.pdf



if (rm(1,3) < +1)
    if (rm(1,3) > -1)
        thetaY = asin(rm(1,3));
        thetaX = atan2(-rm(2,3),rm(3,3));
        thetaZ = atan2(-rm(1,2),rm(1,1));
        
    else    %rm(1,3)=-1
        
        % Not a unique solution:  thetaZ - thetaX = atan2(rm(2,1),rm(2,2))
        thetaY = -pi/2;
        thetaX = -atan2(rm(2,1),rm(2,2));
        thetaZ = 0;
        warn = 'no unique'
    end
else  % rm(1,3) = +1
    
    % Not a unique solution:  thetaZ + thetaX = atan2(rm(2,1),rm(2,2))
    thetaY = pi/2;
    thetaX = atan2(rm(2,1),rm(2,2));
    thetaZ = 0;
    warn = 'no unique2'
end

EA = [thetaX thetaY thetaZ];
EA = EA*180/pi; %convert to degrees;
end

%this code seems to work with Rx