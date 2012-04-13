% close all;
sim('SalpChain');
time = Salp1_PandV.time;
pos = Salp1_PandV.signals(1).values;
vel = Salp1_PandV.signals(2).values;
AVs1; %angular velocities;
[radius omega speed Rsq phase] = getHelixParams(time, pos, vel);
%find angles
EA1 = [];
for i = 1:length(RotM1)
    rmat = reshape(RotM1(i, :), 3,3); %this takes a vector from body and converts to world
    EA1p = rmToEAxyz(rmat);
    EA1 = [EA1; EA1p]; 
end

%just look at last half to determine what things are.
len = length(EA1);
hlen = floor(len/2);
thx = mean(EA1(hlen:end,1));
thy = mean(EA1(hlen:end,2));

%fit z which should be linear
%unwrap z
EA1(:,3) = 180/pi*unboundTheta(EA1(:,3)*pi/180);
liney = fittype('a+b*x');
opts = fitoptions(liney);
opts.StartPoint = rand(1,2);

fitLin = fit(time(hlen:end), EA1(hlen:end,3),liney, opts);
thzCoeff = coeffvalues(fitLin);

thzSlope = thzCoeff(2);
thzPhase = thzCoeff(1);

a = radius;
k = mean([omega thzSlope*pi/180]);
v = speed;

%intialize residual varaibles
testTimes = 0:0.1:10;
n = length(testTimes);
velResid   =  zeros(3,n);
posddResid =  zeros(3,n);
angledResid = zeros(3,n);
omegadResid = zeros(3,n); 
posdd=zeros(3,n);
i = 1;
for t = testTimes
    %define helical solution
    x = a*cos(k*t);
    y = a*sin(k*t);
    z = v*t;
    phi = k*t+thzPhase*pi/180-phase; %+phase?
    theta = thy*pi/180;
    psi = thx*pi/180;

    xd = -k*a*sin(k*t);
    yd = k*a*cos(k*t);
    zd = v;
    phid = k;
    thetad = 0;
    psid = 0;
    omega = [-sin(theta); cos(theta)*sin(psi); cos(theta)*cos(psi)]*phid;


    xdd = -k^2*a*cos(k*t);
    ydd = -k^2*a*sin(k*t);
    zdd = 0;
    omegad = zeros(3,1);

    state =[x;y;z;xd;yd;zd; psi; theta; phi; omega];
    stateD = salpDE(t, state);
    stateDhypo = [xd;yd;zd;xdd;ydd;zdd; psid;thetad;phid;omegad];
    
    posdd(:,i)=[xdd,ydd,zdd];
    pos2dd(:,i)=stateD(4:6);
    velResid(:,i) = [xd;yd;zd] - stateD(1:3);
    posddResid(:,i) = [xdd;ydd;zdd] - stateD(4:6);
    angledResid(:,i) = [psid;thetad;phid] - stateD(7:9);
    omegadResid(:,i) = omegad - stateD(10:12);
    i = i+1;
    
end
%plot residuals
times = testTimes;
figure(1)
plot(times,posddResid(1,:), 'b');
hold on;
plot(times,posddResid(2,:), 'g');
plot(times,posddResid(3,:), 'm');
plot(times,posdd(1,:), 'k');

hold off;
legend('xdd', 'ydd', 'zdd', 'xdd value');
title('residuals');
xlabel('time');
ylabel('acceleration m/s^2');


figure(2)
plot(times,posddResid(1,:)./posdd(1,:), 'b');
hold on;
plot(times,posddResid(2,:)./posdd(2,:), 'g');
plot(times,posddResid(3,:)./posdd(3,:), 'm');
hold off;
legend('xdd', 'ydd', 'zdd');
title('percent residuals');
xlabel('time');
ylabel('acceleration m/s^2');
%%

figure(3)
plot(times,omegadResid(1,:), 'b');
hold on;
plot(times,omegadResid(2,:), 'g');
plot(times,omegadResid(3,:), 'm');
plot(times,omegad(3,:), 'k');

hold off;
legend('omegaxd', 'omegayd', 'omegazd', 'omegazd value');
title('omega dot residuals');
xlabel('time');
ylabel('angular accelerations rad/s^2');


figure(4)
plot(times,angledResid(1,:), 'b');
hold on;
plot(times,angledResid(2,:), 'g');
plot(times,angledResid(3,:), 'm');
plot(times, phid,'k-.');
hold off;
legend('thxd', 'thyd', 'thzd', 'thzd value');
title('angle Dot residuals');
xlabel('time');
ylabel('angular velocity rad/s');

% 

% %%
% %plots and comparisons for angles, and euler convention check.
% for i = 1:2
% %%plots of angles over time
% figure();
% xmax = 300
% xmin = 0;
% subplot(3,1,3)
% plot(time, EA1(:,1), 'r');
% title('theta_x');
% xlim([xmin xmax])
% xlabel('time (sec.)');
% ylabel('angle 1 (degrees)');
% 
% subplot(3,1,2)
% plot(time, EA1(:,2), 'r');
% xlim([xmin xmax])
% title('theta_y');
% xlabel('time (sec.)');
% ylabel('angle 2 (degrees)');
% 
% subplot(3,1,1)
% plot(time, EA1(:,3), 'r');
% title('theta_z');
% xlim([xmin xmax])
% xlabel('time (sec.)');
% ylabel('angle 3 (degrees)');
% 
% %I'll replot the second time with a different conversion
% EA1sec = [];
%     for i = 1:length(RotM1)
%         rmat = reshape(RotM1(i, :), 3,3); %this takes a vector from body and converts to world
%         EA1p = rmToEAzyx(rmat);
% 
%         EA1b = SpinCalc('EA123toEA321', EA1p, 0.1, 0);
%         %rearrange so still in theta_x, theta_y, theta_z order
%         EA1p(1) = EA1b(3);
%         EA1p(2) = EA1b(2);
% 
% 
%         EA1sec = [EA1sec; EA1p]; 
%     end
%     EA1sec(:,3) = 180/pi*unboundTheta(EA1sec(:,3)*pi/180);
% end
% 
% EA1diff = EA1sec-EA1;
% figure
% plot(EA1diff(:,1), 'g');
% hold on;
% plot(EA1diff(:,2), 'r');
% plot(EA1diff(:,3), 'k');
% hold off
% title('diffs');