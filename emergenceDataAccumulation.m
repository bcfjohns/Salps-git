force_close_system('all');
salpsParams;
modelSet = [1:35];
lmSet = length(modelSet);

modelNames = cell(1,lmSet);

radiuses=zeros(lmSet,3); %three rows for first, middle and final node.
omegas=zeros(lmSet,3);
speeds=zeros(lmSet,3);
Rsqs=zeros(lmSet,3);
haveData=zeros(lmSet,3); %records if have data for this number of nodes yet. 1 if yes 0 if false.
simTimes=zeros(lmSet,1);

%cell arrays for storing the position and angle data for all the
%simulations run, this way I don't have to rerun simulations to look back
%at the data.

timePoints = cell(1,lmSet);
firstNodePositions = cell(1,lmSet);
firstNodeVelocities = cell(1,lmSet);
firstNodeAngles = cell(1,lmSet);

middleNodePositions = cell(1,lmSet);
middleNodeVelocities = cell(1,lmSet);
middleNodeAngles = cell(1,lmSet);

endNodeAngles = cell(1,lmSet); %actual angles from 2nd to last node's connection to last node, but easier naming conventions
endNodePositions = cell(1,lmSet);
endNodeVelocities = cell(1,lmSet);



% set up model names, and set solvers and save.
for ii = 1:lmSet
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

for jj = 1:lmSet;
    strn = ['salpChain' num2str(modelSet(jj))];
    modelNames(jj) = {strn};
       
    if ~haveData(jj)
        %set solver and sim time and save the model
        load_system(modelNames(jj));
        set_param(strn, 'solver', 'ode15s');
        set_param(strn, 'stop time', '160');
        save_system(strn);

        mdl = modelNames(jj)
        tic
        sim(char(mdl));
        simTimes(jj) = toc;

        %%assign data to first middle or end, depending on if all of those exist
        switch modelSet(jj)
           case 1
               %end node is all three
               time = endSalp_PandV.time;
               velocities = endSalp_PandV.signals(2).values(:,1:2);
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, velocities);
               radius2=radius3;
               radius1=radius3;
               omega2=omega3;
               omega1=omega3;
               speed2=speed3;
               speed1=speed3;
               Rsq2=Rsq3;
               Rsq1=Rsq3;

               timePoints{jj} = time;
               firstNodePositions{jj} = positions;
               firstNodeVelocities{jj} = endSalp_PandV.signals(2).values;
               

           case 2
            %FIRST NODE. first is start and middle. end is end
               time = firstSalp_PandV.time;
               positions = firstSalp_PandV.signals(1).values;
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               [radius1 omega1 speed1 Rsq1] = getHelixParams(time, positions, angles);

               timePoints{jj} = time;
               firstNodePositions{jj} = positions;
               firstNodeVelocities{jj} = firstSalp_PandV.signals(2).values;
               firstNodeAngles{jj} = angles;
               
            %END SALP.
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);
               radius2=radius3;
               omega2=omega3;
               speed2=speed3;
               Rsq2=Rsq3;
               
               endNodeAngles = angles;
               endNodePositions = positions;
               endNodeVelocities = endSalp_PandV.signals(2).values;



            case 3
               %doesn't have preEnd salp
               %all three nodes exist
            %FIRST SALP
               time = firstSalp_PandV.time;
               positions = firstSalp_PandV.signals(1).values;
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               [radius1 omega1 speed1 Rsq1] = getHelixParams(time, positions, angles);
                
               %save data for first salp
               timePoints{jj} = time;
               firstNodePositions{jj} = positions;
               firstNodeVelocities{jj} = firstSalp_PandV.signals(2).values;
               firstNodeAngles{jj} = angles;
               
            %middle salp. Time should be the same for all three
               angles=[middleSalp_angles.signals(1).values middleSalp_angles.signals(2).values];
               positions = middleSalp_PandV.signals(1).values;
               [radius2 omega2 speed2 Rsq2] = getHelixParams(time, positions, angles);

               %save data
               middleNodePositions{jj} = positions;
               middleNodeVelocities{jj} = middleSalp_PandV.signals(2).values;
               middleNodeAngles{jj} = angles;
  
            %end salp. It doesn't have angles so use angles from
               %postultimate salp, in this case the middle salp, since
               %there are only 3.
               angles=[middleSalp_angles.signals(1).values middleSalp_angles.signals(2).values];
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);

               %save data
               endNodePositions = positions;
               endNodeVelocities = endSalp_PandV.signals(2).values;
               endNodeAngles = angles;

           otherwise
               %all three nodes exist
            %FIRST SALP
               time = firstSalp_PandV.time;
               positions = firstSalp_PandV.signals(1).values;
               angles=[firstSalp_angles.signals(1).values firstSalp_angles.signals(2).values];
               [radius1 omega1 speed1 Rsq1] = getHelixParams(time, positions, angles);

               %save data
               timePoints{jj} = time;
               firstNodePositions{jj} = positions;
               firstNodeVelocities{jj} = firstSalp_PandV.signals(2).values;
               firstNodeAngles{jj} = angles;
               
            %MIDDLE SALP Time should be the same for all three
               angles=[middleSalp_angles.signals(1).values middleSalp_angles.signals(2).values];
               positions = middleSalp_PandV.signals(1).values;
               [radius2 omega2 speed2 Rsq2] = getHelixParams(time, positions, angles);
               
               %save data
               middleNodePositions{jj} = positions;
               middleNodeVelocities{jj} = middleSalp_PandV.signals(2).values;
               middleNodeAngles{jj} = angles;
  
            %END SALP. It doesn't have angles so use angles from
               %postultimate salp
               angles=[preEndSalp_angles.signals(1).values preEndSalp_angles.signals(2).values];
               positions = endSalp_PandV.signals(1).values;
               [radius3 omega3 speed3 Rsq3] = getHelixParams(time, positions, angles);
               
               %save data
               endNodePositions = positions;
               endNodeVelocities = endSalp_PandV.signals(2).values;
               endNodeAngles = angles;


        end

        %pull out middle and end nodes as well
        %duplicate info as needed or blanks when not applicable.
    
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
        ylabel('radius (m)');

        subplot(4,1,2);
        plot(modelSet, omegas(:,1), 'k');
        hold on;
        plot(modelSet, omegas(:,2), 'c--');
        plot(modelSet, omegas(:,3), 'g-.');
        hold off;
        ylabel('omega (rad/s)')

        subplot(4,1,3);
        plot(modelSet, speeds(:,1), 'k');
        hold on;
        plot(modelSet, speeds(:,2), 'c--');
        plot(modelSet, speeds(:,3), 'g-.');
        hold off;
        ylabel('speed');

        subplot(4,1,4)
        plot(modelSet, Rsqs(:,1), 'k');
        hold on;
        plot(modelSet, Rsqs(:,2), 'c--');
        plot(modelSet, Rsqs(:,3), 'g-.');
        hold off;
        
        ylabel('flags');
        
        figure(2)
        plot(time, positions(:,1));
        hold on;
        plot(time, positions(:,2), 'm');
        plot(time, positions(:,3), 'c');
        hold off;
        title ('positions');

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