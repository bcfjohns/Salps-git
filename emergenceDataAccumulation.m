% firstSalp_PandV
% firstSalp_angles
% middleSalp_PandV
% middleSalp_angles
% endSalp_PandV
% preEndSalp_angles
force_close_system('all');
salpsParams;
modelNames = cell(1,19);

%set up model names, and set solvers and save.
for ii = 2:20
    strn = ['salpChain' num2str(ii)];
    modelNames(ii-1) = {strn};
%     load_system(modelNames(ii));
%     set_param(strn, 'solver', 'ode15s');
%     set_param(strn, 'stop time', '400');
%     save_system(strn);
end

%go through sim all the models and plot stuff
jj = 1;
for mdl = modelNames
   mdl
   sim(char(mdl));
   time = firstSalp_PandV.time;
   positions = firstSalp_PandV.signals(1).values;
   angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
   [radius omega speed flag] = getHelixParams(time, positions, angles);
   radiuses(jj) = radius;
   omegas(jj) = omega;
   speeds(jj) = speed;
   flags(jj) = flag;
   figure(1);
   
   title('helix as a function of number of nodes');
   
   subplot(4,1,1);
   plot(radiuses, 'b')
   title('radius');
   subplot(4,1,2);
   plot(omegas, 'g');
   title('omega')
   subplot(4,1,3);
   plot(speeds, 'r');
   title('speed');
   subplot(4,1,4)
   title('flags');
   plot(flags);
   
%    figure(1);
%    subplot(6,3,jj);
%    plot(firstSalp_PandV.time, firstSalp_PandV.signals(1).values(:,1), 'g');
%    hold on;
%    plot(firstSalp_PandV.time, firstSalp_PandV.signals(1).values(:,2), 'c');
%    plot(firstSalp_PandV.time, firstSalp_PandV.signals(1).values(:,3), 'k');
%    hold off;
%    
%    figure(2)
%    subplot(6,3,jj);
%    plot(firstSalp_PandV.time, firstSalp_angles.signals(1).values(:,1), 'g');
%    hold on;
%    plot(firstSalp_PandV.time, firstSalp_angles.signals(2).values(:,1), 'c');
%    hold off;
   
   jj=jj+1;
end


%alternative plot
subplot(4,1,1);
plot(2:20, radiuses, 'b')
title('helix parameters');
ylabel('radius');
subplot(4,1,2);
plot(2:20, omegas, 'g');
ylabel('omega')
subplot(4,1,3);
plot(2:20, speeds, 'r');
ylabel('speed');
subplot(4,1,4)
plot(2:20, flags);
ylabel('Rsq>0.95');
xlabel('number of nodes');