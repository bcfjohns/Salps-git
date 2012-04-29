
force_close_system('all');
salpsParams;
modelSet = [1:36];
modelNames = cell(1,length(modelSet));

radiuses=zeros(length(modelSet),3); %three rows for first, middle and final node.
omegas=zeros(length(modelSet),3);
speeds=zeros(length(modelSet),3);
Rsqs=zeros(length(modelSet),3);
haveData=zeros(length(modelSet),3); %records if have data for this number of nodes yet. 1 if yes 0 if false.

%set up model names, and set solvers and save.
for ii = 1:length(modelSet)
strn = ['salpChain' num2str(modelSet(ii))];
modelNames(ii) = {strn};
%     if modelSet(ii) >21
%         load_system(modelNames(ii));
%         set_param(strn, 'solver', 'ode15s');
%         set_param(strn, 'stop time', '400');
%         save_system(strn);
%     end
end
clear ii;
%go through sim all the models and plot stuff

for jj = 1:length(modelSet);
    strn = ['salpChain' num2str(modelSet(jj))];
    modelNames(jj) = {strn};
       
    if ~haveData(jj)
        %set solver and sim time and save the model
        load_system(modelNames(jj));
        set_param(strn, 'solver', 'ode15s');
        set_param(strn, 'stop time', '160');
        save_system(strn);

        mdl = modelNames(jj)
        sim(char(mdl));

        %%assign data to first middle or end, depending on if all of those exist
        switch modelSet(jj)
           case 1
               %end node is all three
               time = endSalp_PandV.time;
               angles = endSalp_PandV.signals(2).values(:,1:2);
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);
               radius2=radius3;
               radius1=radius3;
               omega2=omega3;
               omega1=omega3;
               speed2=speed3;
               speed1=speed3;
               Rsq2=Rsq3;
               Rsq1=Rsq3;


           case 2
               %first node is start and middle end is end
               time = firstSalp_PandV.time;
               positions = firstSalp_PandV.signals(1).values;
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               [radius1 omega1 speed1 Rsq1] = getHelixParams(time, positions, angles);

               %end salp.
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);
               radius2=radius3;
               omega2=omega3;
               speed2=speed3;
               Rsq2=Rsq3;

            case 3
               %doesn't have preEnd salp
               %all three nodes exist
               %first salp
               time = firstSalp_PandV.time;
               positions = firstSalp_PandV.signals(1).values;
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               [radius1 omega1 speed1 Rsq1] = getHelixParams(time, positions, angles);

               %middle salp. Time should be the same for all three
               angles=[middleSalp_angles.signals(1).values middleSalp_angles.signals(2).values];
               positions = middleSalp_PandV.signals(1).values;
               [radius2 omega2 speed2 Rsq2] = getHelixParams(time, positions, angles);

               %end salp. It doesn't have angles so use angles from
               %postultimate salp
               angles=[middleSalp_angles.signals(1).values middleSalp_angles.signals(2).values];
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);


           otherwise
               %all three nodes exist
               %first salp
               time = firstSalp_PandV.time;
               positions = firstSalp_PandV.signals(1).values;
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               [radius1 omega1 speed1 Rsq1] = getHelixParams(time, positions, angles);

               %middle salp. Time should be the same for all three
               angles=[middleSalp_angles.signals(1).values middleSalp_angles.signals(2).values];
               positions = middleSalp_PandV.signals(1).values;
               [radius2 omega2 speed2 Rsq2] = getHelixParams(time, positions, angles);

               %end salp. It doesn't have angles so use angles from
               %postultimate salp
               angles=[preEndSalp_angles.signals(1).values preEndSalp_angles.signals(2).values];
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);


        end

        %pull out middle and end nodes as well
        %duplicate info as needed or blanks when not applicable.
    %%
        radiuses(jj,:) = [radius1, radius2, radius3];
        omegas(jj,:) = [omega1, omega2, omega3];
        speeds(jj,:) = [speed1, speed2, speed3];
        Rsqs(jj,:) = [Rsq1, Rsq2, Rsq3];
        figure(1);

        title('helix as a function of number of nodes');

        subplot(4,1,1);
        plot(modelSet, radiuses(:,1), 'k')
        hold on;
        plot(modelSet, radiuses(:,2), 'c--')
        plot(modelSet, radiuses(:,3), 'g-.')
        hold off;
        legend('first', 'middle', 'end'); 
        title('radius');

        subplot(4,1,2);
        plot(modelSet, omegas(:,1), 'k');
        hold on;
        plot(modelSet, omegas(:,2), 'c--');
        plot(modelSet, omegas(:,3), 'g-.');
        hold off;
        title('omega')

        subplot(4,1,3);
        plot(modelSet, speeds(:,1), 'k');
        hold on;
        plot(modelSet, speeds(:,2), 'c--');
        plot(modelSet, speeds(:,3), 'g-.');
        hold off;
        title('speed');

        subplot(4,1,4)
        title('flags');
        plot(modelSet, Rsqs(:,1), 'k');
        hold on;
        plot(modelSet, Rsqs(:,2), 'c--');
        plot(modelSet, Rsqs(:,3), 'g-.');
        hold off;

        %%
        %    figure(1);
        %    subplot(6,3,jj);
        %    plot(firstSalp_PandV.time, firstSalp_PandV.signals(1).values(:,1), 'g-.');
        %    hold on;
        %    plot(firstSalp_PandV.time, firstSalp_PandV.signals(1).values(:,2), 'c--');
        %    plot(firstSalp_PandV.time, firstSalp_PandV.signals(1).values(:,3), 'k');
        %    hold off;
        %    
        %    figure(2)
        %    subplot(6,3,jj);
        %    plot(firstSalp_PandV.time, firstSalp_angles.signals(1).values(:,1), 'g-.');
        %    hold on;
        %    plot(firstSalp_PandV.time, firstSalp_angles.signals(2).values(:,1), 'c--');
        %    hold off;
        haveData(jj) = 1;
    end
end


%alternative plot
subplot(4,1,1);
plot(2:20, radiuses, 'b')
title('helix parameters');
ylabel('radius');
subplot(4,1,2);
plot(2:20, omegas, 'g-.');
ylabel('omega')
subplot(4,1,3);
plot(2:20, speeds, 'r');
ylabel('speed');
subplot(4,1,4)
plot(2:20, flags);
ylabel('Rsq>0.95');
xlabel('number of nodes');