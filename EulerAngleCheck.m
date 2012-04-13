%This loop iterates through constantly moving the Salp more so that the
%helix moves along the z axis.
thetax = 1;
thetay = 1;
ii = 1;
% while (abs(thetax)+abs(thetay)>1e-4)
    ii = ii+1;
% for ii = 1:30
    
sim('salpChain');

%find the general vector the spiral was along, so the angles can be found
%and 'removed' So it's traveling along one of the axis.
x = Pos1(70:end,1);
y = Pos1(70:end,2);
z = Pos1(70:end,3);

%extra stuff for fitting later
time = Salp1_PandV.time;
timeFit = time(70:end);
xcent = x-mean(x);
ycent = y-mean(y);
zcent = z-mean(z);
%%
% %remove means, so just looking at direction of motion;
% x = x-mean(x);
% y = y-mean(y);
% z = z-mean(z);

%Least squares line
t = 1:length(x);
A = [t' ones(length(x),1)];
fitx = (A'*A)\(A'*x);
fity = (A'*A)\(A'*y);
fitz = (A'*A)\(A'*z);
figure(1)
plot(t, x)
hold on;
plot(t, t*fitx(1)+fitx(2), 'k');
hold
title('x')
figure(2)
plot(y, 'r')
hold on;
plot(t, t*fity(1)+fity(2), 'm');
title('y');
hold;
figure(3)
plot(z, 'g')
hold on;
plot(t, t*fitz(1)+fitz(2), 'c');
title('Z');
hold off;

%rotate about x, such that y slope is 0;
thetax = atan2(fity(1), fitz(1))*180/pi %=>thetax = 30.6671 with sim starting [0 0 0] x-y-z
%=> 2.4748e-04 with sim starting [30.6671 0 0]
%and thetay = 59.8797
thetay = atan2(fitx(1),sqrt(fitz(1)^2+fity(1)^2))*180/pi
format long;
connectR = connectR+[thetax*0.01 -thetay*0.01 0]%thetax
% if (abs(thetay)<1e-4)
%     connectR = connectR+[thetax 0 0]
% else
%     connectR = connectR+[0 -thetay 0]
% end
% if (abs(thetax)+abs(thetay)>1e-4)
%     ii=ii-1
% end
% end
%%
%take the list of rotation matrices convert to Euler angles for two salps
%and plot the euler angles to compare them.
EA1 = [];
EA2 = [];
for i = 1:length(RotM1)
    rmat = reshape(RotM1(i, :), 3,3); %this takes a vector from body and converts to world
    EA1p = rmToEAxyz(rmat);
%      EA1p = SpinCalc('DCMtoEA123', reshape(RotM1(i, :), 3,3), 0.1, 0);
    %convert things as needed, so life is happy
    %so at this point EA1p = [theta_x theta_y theta_z] with Euler convetion
    %xyz, cause rmat that I get is wrong.
% % % % % %     EA1b = SpinCalc('EA123toEA321', EA1p, 0.1, 0);
% % % % % %     %rearrange so still in theta_x, theta_y, theta_z order
% % % % % %     EA1p(1) = EA1b(3);
% % % % % %     EA1p(2) = EA1b(2);
% % % % % %     EA1p(3) = EA1b(1);
    EA1 = [EA1; EA1p];%[angleN(EA1p); EA1];
%     
%     EA2p = SpinCalc('DCMtoEA132', reshape(RotM2(i, :), 3,3), 0.1, 0);
%     EA2 = [angleN(EA2p); EA2];
%     
end

%%

%pull out time vector from other data, so thing line up right
time = Salp1_PandV.time;

figure();
xmax = 300
xmin = 0;
subplot(3,1,3)
plot(time, EA1(:,1), 'r');
title('theta_x');
xlim([xmin xmax])
xlabel('time (sec.)');
ylabel('angle 1 (degrees)');

subplot(3,1,2)
plot(time, EA1(:,2), 'r');
xlim([xmin xmax])
title('theta_y');
xlabel('time (sec.)');
ylabel('angle 2 (degrees)');

subplot(3,1,1)
plot(time, EA1(:,3), 'r');
title('theta_z');
xlim([xmin xmax])
xlabel('time (sec.)');
ylabel('angle 3 (degrees)');
%%
% % t = pi/4;
% % Rx = [1 0   0;
% %       0 cos(t) -sin(t);
% %       0 sin(t)  cos(t)];
% % 
% % t = -pi/6;  
% % Ry = [cos(t) 0 sin(t);
% %      0       1 0;
% %      -sin(t) 0  cos(t)];
% %  
% % 
% % t = 4*pi/3;
% % Rz = [cos(t) -sin(t) 0;
% %       sin(t)  cos(t) 0;
% %       0         0    1];
% % 
% % EAx = rmToEAxyz(Rx)
% % EAy = rmToEAxyz(Ry)
% % EAz = rmToEAxyz(Rz)
% % EAxyz = rmToEAxyz(Rz*Ry*Rx)
% % % % %recalc to double check
% 
% t = EAxyz(1)*pi/180;
% Rx = [1 0   0;
%       0 cos(t) -sin(t);
%       0 sin(t)  cos(t)];
% 
% t = EAxyz(2)*pi/180;
% Ry = [cos(t) 0 sin(t);
%      0       1 0;
%      -sin(t) 0  cos(t)];
%  
% t = EAxyz(3)*pi/180;
% Rz = [cos(t) -sin(t) 0;
%       sin(t)  cos(t) 0;
%       0         0    1];
%   
%   
% EAx = rmToEAxyz(Rx)
% EAy = rmToEAxyz(Ry)
% EAz = rmToEAxyz(Rz)
% EAxyz = rmToEAxyz(Rz'*Ry'*Rx')

%%
%doublle check angles and stuff.
EAxyz = connectR;
t = EAxyz(1)*pi/180
Rx = [1 0   0;
      0 cos(t) -sin(t);
      0 sin(t)  cos(t)]

t = EAxyz(2)*pi/180;
Ry = [cos(t) 0 sin(t);
     0       1 0;
     -sin(t) 0  cos(t)];
 
t = EAxyz(3)*pi/180;
Rz = [cos(t) -sin(t) 0;
      sin(t)  cos(t) 0;
      0         0    1];
  
EAx = rmToEAxyz(Rx)
EAy = rmToEAxyz(Ry)
EAz = rmToEAxyz(Rz);
EAxyz = rmToEAxyz(Rz*Ry*Rx)


% %%
% %Checking Angle conventions and ordering.
% clc
% t = -pi/4;
% Rx = [1 0   0;
%       0 cos(t) -sin(t);
%       0 sin(t)  cos(t)];
% 
% t = -.3*pi/4;  
% Ry = [cos(t) 0 sin(t);
%      0       1 0;
%      -sin(t) 0  cos(t)];
%  
% 
% t = -pi/4;
% Rz = [cos(t) -sin(t) 0;
%       sin(t)  cos(t) 0;
%       0         0    1];
% 
% 
% EAx = SpinCalc('DCMtoEA132', Rx, 0.1, 0)
% EAy = SpinCalc('DCMtoEA123', Ry, 0.1, 1)
% EAz = SpinCalc('DCMtoEA123', Rz, 0.1, 1)
% EAz = SpinCalc('DCMtoEA123', Rz*Ry*Rx, 0.1, 1)


% kt = 10;
% kbot = 0.01;
% EAx = [90 90 90];
% while(abs(EAx(1)-30)>0.0001) 
%     k = (kt+kbot)/2
%     EAx = SpinCalc('DCMtoEA123', k*Rx, 0.1, 0)
%     if EAx(1) > 30
%         kt =k;
%     else
%         kbot = k;
%     end
% end
% 
% EAxyz = SpinCalc('DCMtoEA123', Rz*Ry*Rx, 0.1, 0)
% t = EAxyz(1)*pi/180;
% Rx = [1 0   0;
%       0 cos(t) -sin(t);
%       0 sin(t)  cos(t)];
% 
% t = EAxyz(2)*pi/180;
% Ry = [cos(t) 0 sin(t);
%      0       1 0;
%      -sin(t) 0  cos(t)];
%  
% t = EAxyz(3)*pi/180;
% Rz = [cos(t) -sin(t) 0;
%       sin(t)  cos(t) 0;
%       0         0    1];
% 
% EAxyz = SpinCalc('DCMtoEA123', Rz*Ry*Rx, 0.1, 0)

%%
% %triple check
% t = EAxyz(1);
% Rx = [1 0   0;
%       0 cos(t) -sin(t);
%       0 sin(t)  cos(t)];
%   
% t = EAxyz(2);
% Ry = [cos(t) 0 sin(t);
%      0       1 0;
%      -sin(t) 0  cos(t)];
% 
% t = EAxyz(3);
% Rz = [cos(t) -sin(t) 0;
%       sin(t)  cos(t) 0;
%       0         0    1];
% EAxyz = rmToEAxyz(Rz*Ry*Rx)

 