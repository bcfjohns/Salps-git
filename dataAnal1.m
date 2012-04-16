%plotting data from propDirOpt50times1.mat to look for
%if the different runs of the algorithm converged on similar things.

% load('propDirOpt50times1.mat')
%%
%simple plot of the final alphas reached

% close all;

figure(3);
plot3(alphas(1,:), alphas(2,:), costs, '.');
xlabel('alpha1');
ylabel('alpha2');
zlabel('cost');

colors = ['k', 'c', 'r'];

%%
figure(1);

plot3(alphas(1,1), alphas(2,1), costs(1), 'k*');
hold on;    
for n = 1:50
%     alphas(1,n)
%     alphas(2,n)
%     costs(n)
%     [colors(endstate(n)) '.']
%     
%     
    plot3(alphas(1,n), alphas(2,n), costs(n), [colors(endstate(n)) '*']);
    
    title('cost reached after optimal.');
    xlabel('alpha1');
    ylabel('alpha2');
    zlabel('cost');
end
legend('Got to final iteration', 'Errored out', 'Didnt learn');
hold off;
%% 
figure(2);
plot3(alphaHist(1,:), alphaHist(2,:), valueHist, '.');
xlabel('alpha1');
ylabel('alpha2');
zlabel('cost');
title('alpha Hist from last run');
