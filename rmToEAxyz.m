function EA = rmToEAxyz(rm)


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