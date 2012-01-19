%find the general vector the spiral was along, so the angles can be found
%and 'removed' So it's traveling along one of the axis.
x = Pos1(60:end,1);
y = Pos1(60:end,2);
z = Pos1(60:end,3);

% %remove means, so just looking at direction of motion;
% x = x-mean(x);
% y = y-mean(y);
% z = z-mean(z);

%Least squares line
t = 1:length(x);
A = [t' ones(length(x),1)];
fitx = inv(A'*A)*A'*x;
fity = inv(A'*A)*A'*y;
fitz = inv(A'*A)*A'*z;
plot(t, x)
hold on;
plot(t, t*fitx(1)+fitx(2), 'k');

plot(y, 'r')
plot(t, t*fity(1)+fity(2), 'm');

plot(z, 'g')
plot(t, t*fitz(1)+fitz(2), 'c');
hold off;

%rotate about x, such that y slope is 0;
thetax = atan(fity(1)/fitz(1))*180/pi %=>thetax = 30.6671 with sim starting [0 0 0] x-y-z
%=> 2.4748e-04 with sim starting [30.6671 0 0]
%and thetay = 59.8797
thetay = atan(fitx(1)/fitz(1))*180/pi
%%
%take the list of rotation matrices convert to Euler angles for two salps
%and plot the euler angles to compare them.
EA1 = [];
EA2 = [];
for i = 1:length(RotM1)
    EA1p = SpinCalc('DCMtoEA123', reshape(RotM1(i, :), 3,3), 0.1, 0);
    
    EA1 = [angleN(EA1p); EA1];
%     
%     EA2p = SpinCalc('DCMtoEA132', reshape(RotM2(i, :), 3,3), 0.1, 0);
%     EA2 = [angleN(EA2p); EA2];
%     
end


%%
subplot(3,1,1)
plot(EA1(:,1), 'r');
title('angle 1');
% xlim([50 1250])
% hold on;
% plot(EA2(:,1), 'g');
% hold off;

subplot(3,1,2)
plot(EA1(:,2), 'r');
xlim([50 1250])
title('angle 2');
% hold on;
% plot(EA2(:,2), 'g');
% hold off;

subplot(3,1,3)
plot(EA1(:,3), 'r');
title('angle 3');
xlim([50 1250])
% hold on;
% plot(EA2(:,3), 'g');
% hold off;


%%
%Checking Angle conventions and ordering.
t = pi/6;
Rz = [cos(t) -sin(t) 0;
      sin(t)  cos(t) 0;
      0         0    0]
Rx = [0 0   0;
      0 cos(t) -sin(t);
      0 sin(t)  cos(t)]
Ry = [cos(t) 0 sin(t);
     0      0 0;
     -sin(t) 0  cos(t)]


EAz = SpinCalc('DCMtoEA123', Rz, 0.1, 0)
EAy = SpinCalc('DCMtoEA123', Ry, 0.1, 0)
EAx = SpinCalc('DCMtoEA123', Rx, 0.1, 0)
