function EA = rmToEAxyz(rm)
%Takes a rotation matrix and returns three angles that would form rm via
%Rz*Ry*Rx
%code transformed from psuedo code on page 10 of 
%http://www.geometrictools.com/Documentation/EulerAngles.pdf



if (rm(3,1) < +1)
    if (rm(3,1) > -1)
        thetaY = asin(-rm(3,1));
        thetaZ = atan2(rm(2,1),rm(1,1));
        thetaX = atan2(rm(3,2),rm(3,3));
        
    else % rm(3,1) = -1
        
        % Not a unique solution:  thetaX - thetaZ = atan2(-rm(2,3),rm(2,2))
        thetaY = +pi/2;
        thetaZ = -atan2(-rm(2,3),rm(2,2));
        thetaX = 0;
    end
else % rm(3,1) = +1
    
    % Not a unique solution:  thetaX + thetaZ = atan2(-rm(2,3),rm(2,2))
    thetaY = -pi/2;
    thetaZ = atan2(-rm(2,3),rm(2,2));
    thetaX = 0;
end

EA = [thetaX thetaY thetaZ];
EA = EA*180/pi; %convert to degrees;
end

%this code seems to work with Rx