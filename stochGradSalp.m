function [alphaHist valueHist exitFlag finalAlpha finalCost finalIteration] = stochGradSalp
%exit flag says why it ended. 666-unknown reasons; 1-end of iterations; 2-didn't learn in first
%K iterations; 3-Simulation errored out
global valueHist alphaHist Salp1_PandV Salp1_angles uAmplitudeEven
exitFlag = 666;
%set initial parameters for the gradient search
    alpha = [rand(1)*1.5  rand(1)*1.5];
    %alpha = angles of propulsion
    
    lengthBeta = 0.1; %means length of Beta will be 0.14
    etta = [300 300];
    sizeBeta = size(alpha);
    maxI = 200;
    
    alphaHist = zeros(length(alpha), maxI);
    valueHist = zeros(1, maxI);   
    
    %params for error checking and restarting etc.
    maxSimErrors = 5; 
    %number of times to try a new beta before giving up on the optimization
    betaSimErrors = 3; %
    
    initialLearn = 10; %if haven't learned much by now, stop.
    
    for i = 1:maxI
%         i = i
        alpha = boundAngles(alpha);
        etta = etta;
        
       
        %check if learning at all in the first several itteration if not
        %stop.
        if (i==initialLearn)
            disp('checking if learned range of ValueHist is');
            disp(range(valueHist(1:i-1)));
            if range(valueHist(1:i-1))<0.01
                exitFlag = 2;
                finalAlpha = alphaHist(:,i-1);
                finalCost =  valueHist(i-1);
                finalIteration = i;
                return
            else
                disp('I think I learned');
            end
        end
        %================================================================
        %sim with alpha then compute J_alpha
        setUAmplitudeEven([alpha(1) alpha(2)])
        try
            sim('salpChain');
        catch simError
            disp(simError.identifier);
            if strcmp(simError.identifier, 'SL_SERVICES:utils:CNTRL_C_INTERRUPTION')
                rethrow(simError); %rethrow cntrl-c breaks;
            end
           exitFlag = 3;
           finalAlpha = alpha;
           if (i ==1)
               finalCost = 0.666;
           else
               finalCost = J_alpha; %this will be the cost from last time, 
               %but that's the best there is.
           end
           finalIteration = i;
           return
        end
        
        J_alpha = valueFunction();
        
        %================================================================
        %sim with alpha+beta then compute J_alpha
        randDirection = 2*pi*rand(1); %random direction in radians.
        beta = [cos(randDirection) sin(randDirection)];
        beta = beta*lengthBeta;%set the length of Beta.
        setUAmplitudeEven([alpha(1) alpha(2)])
%         updateParams(alpha+beta);
        needSim = true;
        while needSim
        try
            sim('salpChain');
            betaSimErrors = 0;
            needSim = false;
        catch simError
            disp(simError.identifier);
            if strcmp(simError.identifier, 'SL_SERVICES:utils:CNTRL_C_INTERRUPTION')
                rethrow(simError); %rethrow cntrl-c breaks;
            end
           if (betaSimErrors > maxSimErrors)
               exitFlag = 3;
               finalAlpha = alpha+beta;
               finalCost = J_alpha;
               finalIteration = i;
               return;
           end
           betaSimErrors = betaSimErrors+1;
           %find new beta and try again.
           beta = stand_dev_beta.*randn(sizeBeta);
           needSim = true;
        end
        end
         
        J_alpha_beta = valueFunction();
        
        dalpha = -etta.*(J_alpha_beta-J_alpha).*beta;
       
        alphaHist(:,i) = alpha;
        valueHist(i) = J_alpha;
        alpha = boundAngles(alpha+dalpha); 
        

        figure(1)
        subplot(2,1,1)
        plot3(alphaHist(1,1:i), alphaHist(2,1:i), valueHist(1:i));
        title('valueHist, so far');
        subplot(2,1,2);
        plot(valueHist(1:i));
        title('valueHist over itererations');
        xlabel('iteration number');

    end
    finalAlpha = alphaHist(:,end);
    finalCost = valueHist(end);
    exitFlag = 1;
    finalIteration = i;
end

function updateParams(alpha)  
global connectR frontConnect backConnect u1axis u2axis
    lengthConnect = 0.2;
    alpha = boundAngles(alpha);
    %update propulsion based on angle.
    setUAmplitudeEven([alpha(1) 0])
    %using this angle puts gives the propulsion x and z hat components,
    %which corresponds with a necessary change in sign in the model file
    %for the x hat component.


    %update vectors for where uJoint is connected.
    frontConnect = [alpha(2) alpha(3) 1]; %direction of the connection
    %normalize and make frontConnect lengthConnect long, so the connection
    %vectors are always that long.
    frontConnect = lengthConnect*frontConnect/norm(frontConnect);
    
    backConnect = [-frontConnect(1) -frontConnect(2) 1];

    %update u joint and things, so constrained orientation axis is
    %always along the axis of connection.

    v = backConnect';
    t = atan2(v(1),v(3));  
    Ry = [cos(t) 0 -sin(t);
         0       1 0;
         sin(t) 0  cos(t)];

    v2 = Ry*v;

    t = atan2(v2(2),v2(3));
    Rx = [1 0   0;
          0 cos(t) -sin(t);
          0 sin(t)  cos(t)];
    %vFinal = Rx*v2; %This should always be in the z hat directions
    
    %Rotation matix from backConnects direction to z hat direction
    Rspec_z = Rx*Ry;
    %rotation matrix for z direction to backConnect's direction
    R = Rspec_z';
    %rotate axis on u joint
    u1axis = [1 0 0]*R;
    u2axis = [0 1 0]*R;
    %rotate angle for fixed orientation
    connectR = 180/pi*[0 0 alpha(4)]*R;
end

function alpha = boundAngles(alpha)
    anglebound = 1.5;
    if (alpha(1)>anglebound)
        alpha(1)=anglebound;
    else if (alpha(1)<0)
            alpha(1) = 0;
        end
    end
    
        if (alpha(2)>anglebound)
        alpha(2)=anglebound;
    else if (alpha(1)<0)
            alpha(1) = 0;
        end
    end
    
end

    