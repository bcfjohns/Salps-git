close all;
clear all;
[TOUT,YOUT] = ode15s(@salpDE, [0 1000], [0; -0.5; -2; zeros(9,1)]);

subplot(2,1,1)
plot(TOUT, YOUT(:,1:3));
legend('x', 'y', 'z');
subplot(2,1,2);
plot(TOUT, YOUT(:,4:6));
legend('x', 'y', 'z');
title('DE sim');

salpsParams
sim('salpChain');
%%
figure;
pos = Salp1_PandV.signals(1,1).values;
vel = Salp1_PandV.signals(1,2).values;
TOUT = Salp1_PandV.time;
subplot(2,1,1)

plot(TOUT, pos);
legend('x', 'y', 'z');
title('simMechanics position');
subplot(2,1,2);
plot(TOUT, vel);
title('velocity');
legend('x', 'y', 'z');