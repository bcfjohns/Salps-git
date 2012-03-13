function salpParamOver()
global uAmplitudeEven Salp1_PandV Salp1_angles
%Simulate n times with random parameters, then plot showing value and red
%if errored out, probably cause the nonlinear iteration couldn't converge
n = 100; %number of trials to do.

costs = -6.66*ones(n,2); %keep track of various costs.
clrs = ones(n,1); %variable for keeping track of colors, red if the
%simulation errored out otherwise blue.
alphaHist = zeros(n, 4);

for ii = 1:n   
    alpha = [rand(1)*pi/2.5 10*(randn(1,2)-0.5) rand(1)*2*pi];
    %a bad alpha [1.2057    1.7150  -17.0749    5.3352]?
    %alpha = [1.2057    1.7150  -17.0749    5.3352]

    updateParams(alpha);
    try
        sim('SalpChain');
        clrs(ii) = 'b';
    catch ME
        clrs(ii) = 'r';
        disp('I caught an error :o')
        alpha = alpha
        disp(ME.identifier)
    end
    costs(ii,1)=valueFunction();
    costs(ii,2)=valueSpiralFunction();
    
    figure(1)
    title('params errored or not plot1')
    xlabel('prop angle');
    ylabel('linkage l1');
    zlabel('linkage l2');
    hold on;
    plot3(alpha(1), alpha(2), alpha(3), clrs(ii));
    hold off;
    
    figure(2)
    title('params errored or not plot1')
    xlabel('relative node angle');
    ylabel('linkage l1');
    zlabel('linkage l2');
    hold on;
    plot3(alpha(4), alpha(2), alpha(3), clrs(ii));
    hold off;
    
    figure(3)
    subplot(2,1,1);
    title('forward -speed as a function of angles')
    hold on;
    plot3(alpha(1), alpha(2), costs(ii,1), clrs(ii));
    hold off;
    xlabel('propulsion angle');
    ylabel('relative node angle');
    
    subplot(2,1,2);
    title('forward -speed as a function of relative linkage lengths');
    hold on;
    plot3(alpha(3), alpha(4), costs(ii,2), clrs(ii));
    hold off;
    xlabel('L1');
    ylabel('L2');
    
    
end



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
% matName = ['optFromRandomStrtPt3-13,' num2str(iji)];
% save(matName);
% 
% end

function alpha = boundAngles(alpha)
    angle1bound = pi/2.5;
    if (alpha(1)>angle1bound)
        alpha(1)=angle1bound;
    else if (alpha(1)<0)
            alpha(1) = 0;
        end
    end
    
    alpha(4) = mod(alpha(4), 2*pi);
end
