close all;
clear all;
salpsParams
tic
tSim = 80;
[TOUT,YOUT] = ode15s(@salpDE, linspace(0, tSim, tSim*10), [frontConnect'; zeros(9,1)]);
toc

figure(1)
subplot(2,2,1)
plot(TOUT, YOUT(:,1:3));
legend('x', 'y', 'z');
title('DE sim position');
subplot(2,2,2);
plot(TOUT, YOUT(:,4:6));
legend('x', 'y', 'z');
title('DE sim velocity');

figure(2);
subplot(2,2,1)
plot(TOUT, YOUT(:,7:9));
legend('x', 'y', 'z');
title('DE sim angles');
subplot(2,2,2);
plot(TOUT, YOUT(:,10:12));
legend('x', 'y', 'z');
title('DE sim angular velocity');

tic
sim('salpChain');
toc
%
figure(1);
pos = Salp1_PandV.signals(1,1).values;
vel = Salp1_PandV.signals(1,2).values;
TOUT = Salp1_PandV.time;
subplot(2,2,3)

plot(TOUT, pos);
legend('x', 'y', 'z');
title('simMechanics position');
subplot(2,2,4);
plot(TOUT, vel);
title('velocity');
legend('x', 'y', 'z');


figure(2)
subplot(2,2,4)

plot(TOUT, AVs1);
legend('x', 'y', 'z');
title('simMechanics angular velocity');

figure(3);
%plot residuals
subplot(2,2,1);
plot(TOUT, YOUT(:,1:3)-pos)
title('residuals in position');
subplot(1,2,2)
plot(TOUT, YOUT(:, 4:6)-vel);
title('residuals in velocity');

subplot(2,2,3);
plot(TOUT, YOUT(:,10:12)-AVs1);
title('residuals in angular velocity');



