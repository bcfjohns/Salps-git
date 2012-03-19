%This file uses the fit parameters from simulation of a single node to
%define the equations for the helical motion. Then plots residuals between
%the right and left hand sides of the equations. Using fit values found on
%Feb. 19.
times = 0:0.1:10;
n = length(times);
velResid = 666*ones(3,n);
posddResid = 666*ones(3,n);
posdd =666*ones(3,n);

i = 0;
for t = times
    i = i+1
    y = 1.642*sin(0.9942*t+4.134);
    yd = 1.642*0.9942*cos(0.9942*t+4.134);
    ydd = -1.642*0.9942^2*sin(0.9942*t+4.134);
    x = 1.64*sin(0.9944*t-0.5836);
    xd = 1.64*0.9944*cos(0.9944*t-0.5836);
    xdd = -1.64*0.9944^2*sin(0.9944*t-0.5836);
    
    z = 1.51*t-65.64;
    zd = 1.51;
    zdd = 0;

    thx = 15.876*pi/180; %degrees?
    thxd = 0;
    thxdd = 0;
    thy = 42.32527*pi/180; %degrees?
    thyd = 0;
    thydd = 0;
    thz = 0.9943*t-6.899; %radians
    thzd = 0.9943;
    thzdd = 0;
    
    state = [x;y;z;xd;yd;zd;thx;thy;thz;thxd;thyd;thzd];
    
    stateD = salpDE(t, state);
    
    velResid(:,i) = [xd;yd;zd] - stateD(1:3);
    posddResid(:,i) = [xdd;ydd;zdd] - stateD(4:6);
    posdd(:,i) = [xdd;ydd;zdd];
    
    angled(:,i) = [thxd;thyd;thzd];
    angledResid(:,i) = [thxd;thyd;thzd] - stateD(7:9);
    angleddResid(:,i) = [thxdd;thydd;thzdd] - stateD(10:12);
    angledd(:,i) = [thxdd;thydd;thzdd];
    
end    
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


figure(3)
plot(times,angleddResid(1,:), 'b');
hold on;
plot(times,angleddResid(2,:), 'g');
plot(times,angleddResid(3,:), 'm');
plot(times,angledd(3,:), 'k');

hold off;
legend('thxdd', 'thydd', 'thzdd', 'thzdd value');
title('residuals');
xlabel('time');
ylabel('angular accelerations rad/s^2');


figure(4)
plot(times,angledResid(1,:), 'b');
hold on;
plot(times,angledResid(2,:), 'g');
plot(times,angledResid(3,:), 'm');
plot(times,angled(3,:), 'k');

hold off;
legend('thxdd', 'thydd', 'thzdd', 'thzdd value');
title('OMEGA residuals');
xlabel('time');
ylabel('angular velocity rad/s');
