close all;
subplot(3,1,1);
plot(modelSet(1:19), radiuses(1:19,1), 'k')
hold on;
plot(modelSet(1:19), radiuses(1:19,2), 'c--')
plot(modelSet(1:19), radiuses(1:19,3), 'g-.')
hold off;
legend('\fontsize{16}First Node', '\fontsize{16}Middle', '\fontsize{16}Final Node'); 
title('\fontsize{16}\fontsize{20}Helix parameters');
ylabel('\fontsize{16}Radius');
xlabel('\fontsize{16}Number of Nodes');

subplot(3,1,2);
plot(modelSet(1:19), omegas(1:19,1), 'k');
hold on;
plot(modelSet(1:19), omegas(1:19,2), 'c--');
plot(modelSet(1:19), omegas(1:19,3), 'g-.');
hold off;
ylabel('\fontsize{16}Omega')
xlabel('\fontsize{16}Number of Nodes');


subplot(3,1,3);
plot(modelSet(1:19), speeds(1:19,1), 'k');
hold on;
plot(modelSet(1:19), speeds(1:19,2), 'c--');
plot(modelSet(1:19), speeds(1:19,3), 'g-.');
hold off;
ylabel('\fontsize{16}Speed');
xlabel('\fontsize{16}Number of Nodes');
