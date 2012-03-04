function [alphaHist valueHist] = stochGradSalp
global uAmplitudeEven xFinal valueHist alphaHist Salp1_PandV Salp1_angles
%set initial parameters for the gradient search
    alpha = randn(1,5);
    %angle of propulsion, 3 components of direction to linkage (assuming
    %front and back are symmetric. 1 angle for the relative rotation between two salps.
    
    stand_dev_beta = 0.1;
    etta = 500;
    sizeBeta = size(alpha);
    maxI = 200;
    
    alphaHist = zeros(length(alpha), maxI);
    valueHist = zeros(1, maxI);    
    
    for i = 1:maxI
        i = i
        alpha = alpha
        etta = etta*0.99
        %================================================================
        %sim with alpha then compute J_alpha
        updateParams(alpha);
        
        
      
        tic
        sim('salpChain');
        toc
        
        J_alpha = valueFunction();
        
        %================================================================
        %sim with alpha+beta then compute J_alpha
        beta = stand_dev_beta.*randn(sizeBeta);
        
        setUAmplitudeEven(alpha+beta)
        tic
        sim('salpChain');
        toc
        %sound(y, Fs)
        %input('hows it going?');
        
        J_alpha_beta = valueFunction();
        
        dalpha = -etta*(J_alpha_beta-J_alpha)*beta;
       
        alphaHist(:,i) = alpha;
        valueHist(i) = J_alpha;
        alpha = alpha+dalpha; 
        
        %restrict the search for the propulsion, so it's in one corner
        if (alpha(1)<0)
            alpha(1) = 0;
        else if (alpha(1)>pi/2.5)
            alpha(1) = pi/2.5;
            end
        end
        if (alpha(2)<0)
            alpha(2) = 0;
        else if (alpha(2)>pi/2.5)
            alpha(2) = pi/2.5;
            end
        end
            figure(3);
            plot3(alphaHist(1,1:i), alphaHist(1,1:i), valueHist(1:i));
            title('valueHist, so far');
            figure(4);
            plot(valueHist(1:i));
            title('valueHist over itererations');
%             legend(num2str(alpha));
%             ylabel(num2str(etta));
%         toc

    end
end

function updateParams(alpha)  
global connectR frontConnect backConnect u1axis u2axis

    %Check that the angles are withing appropriate bounds.
    angle1bound = pi/2.5;
    if (alpha(1)>angle1bound)
        alpha(1)=angle1bound)
    else if (alpha(1)<0)
            alpha(1) = 0;
        end
    end
    
    alpha(5)= mod(alpha(5),angle2bound);
    
    
    %update propulsion based on angle.
    setUAmplitudeEven([alpha(1) 0])
    %using this angle puts gives the propulsion x and z hat components,
    %which corresponds with a necessary change in sign in the model file
    %for the x hat component.


    %update vectors for where uJoint is connected.
    frontConnect = [alpha(2) alpha(3) alpha(4)];
    backConnect = [-alpha(2) -alpha(3) alpha(4)];

    %update u joint and things, so constrained orientation axis is
    %always along the axis of connection.

    v = backConnect;
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
    connectR = 180/pi*[0 0 alpha(5)]*R;
end
    