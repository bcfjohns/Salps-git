function [alphaHist valueHist] = stochGradSalp
global uAmplitudeEven xFinal valueHist alphaHist Salp1_PandV Salp1_angles
    %set initial parameters for the gradient search
    alpha = [0.0744 0.1201]; %the angles of the output force assume normalized to 4
    
    stand_dev_beta = 0.01;
    etta = 460;
    sizeBeta = size(alpha);
    maxI = 200;
    
    alphaHist = zeros(length(alpha), maxI);
    valueHist = zeros(1, maxI);    
    
    for i = 1:maxI
%         tic
        i = i
        alpha = alpha
        etta = etta*0.99
        %================================================================
        %sim with alpha then compute J_alpha
        setUAmplitudeEven(alpha)
      
        tic
        sim('salpChain');
        toc
        
        J_alpha = valueFunction();
        
        %================================================================
        %sim with alpha+beta then compute J_alpha
        beta = stand_dev_beta*randn(sizeBeta);
        
        setUAmplitudeEven(alpha+beta)
        tic
        sim('salpChain');
        toc
        
        J_alpha_beta = valueFunction();
        
        dalpha = -etta*(J_alpha_beta-J_alpha)*beta;
       
        alphaHist(:,i) = alpha;
        valueHist(i) = J_alpha;
        alpha = alpha+dalpha; 
        
        %restrict the search for the propulsion, so it's in one corner
        if (alpha(1)<0)
            alpha(1) = 0;
        else if (alpha(1)>pi/2)
            alpha(1) = pi/2;
            end
        end
        if (alpha(2)<0)
            alpha(2) = 0;
        else if (alpha(2)>pi/2)
            alpha(2) = pi/2;
            end
        end
            figure(3);
            plot(valueHist(1:i));
            title('valueHist, so far');
%             legend(num2str(alpha));
%             ylabel(num2str(etta));
%         toc

    end
end


% % Moved to it's own file, for modularities sake.
% % function cost = valueFunction()
% % global Salp1_PandV Salp1_angles
% % 
% % %find steady state indices based on angles
% % T = 50*5; %at least one period to define the range we'll use.
% % margin = 0.1; %what margin to use, so don't cut data off if just a little different
% % time = Salp1_angles.time;
% % angle2 = Salp1_angles.signals(2).values;
% % angle1 = Salp1_angles.signals(1).values;
% % L = length(angle1);
% % 
% % 
% % min1 = min(angle1(L-T:L));
% % min1 = min1-margin*range(min1);
% % 
% % max1 = max(angle1(L-T:L));
% % max1 = max1+margin*range(max1);
% % 
% % min2 = min(angle2(L-T:L));
% % min2 = min2-margin*range(min2);
% % 
% % max2 = max(angle2(L-T:L));
% % max2 = max2+margin*range(max2);
% % 
% % smallestIndex = L-T;
% % 
% % jump = T;
% % while(smallestIndex > T)
% % angle1Part = angle1(smallestIndex-jump:smallestIndex);
% % angle2Part = angle2(smallestIndex-jump:smallestIndex);
% %     if(min(angle1Part) > min1 && min(angle2Part) > min2 && ...
% %             max(angle1Part) < max1 && max(angle2Part) < max2)
% %         smallestIndex = smallestIndex-jump;
% %     else
% %         break;
% %     end
% % end
% % 
% % figure(1)
% % plot(time(1:smallestIndex), angle1(1:smallestIndex), 'r');
% % hold on;
% % plot(time(smallestIndex: L), angle1(smallestIndex:L), 'b');
% % plot(time, min1*ones(L,1), '--k');
% % plot(time, max1*ones(L,1), '--k');
% % hold off;
% % title('angle1');
% % axis([0 time(L) min1-0.1 max1+0.1]);
% % 
% % figure(2);
% % plot(time(1:smallestIndex), angle2(1:smallestIndex), 'r');
% % hold on;
% % plot(time(smallestIndex: L), angle2(smallestIndex:L), 'b');
% % plot(time, min2*ones(L,1), '--k');
% % plot(time, max2*ones(L,1), '--k');
% % hold off;
% % title('angle2');
% % axis([0 time(L) min2-0.1 max2+0.1]);
% % 
% % 
% % % velocities = Salp1_PandV.signals(2).values(smallestIndex:L, :);
% % % velocity = sqrt(sum(velocities.^2,2));
% % % avgVeloc = mean(velocity);
% % % cost = -avgVeloc;
% % positions = Salp1_PandV.signals(2).values([smallestIndex L],:);
% % dpos = diff(positions)/(L-smallestIndex+1);
% % cost = -norm(dpos);
% % end


function cost = valueFunctionOld(finalState, currentAlpha)
    %just distance moved since beginning.
%     [xName yName zName] = finalState.signals(15:17).values;
%     %make sure getting the right states
%     if (~(strcmp(xName,'SixDoF.P1.Position') && strcmp(yName, 'SixDoF.P2.Position') && ...
%             strcmp(zName, 'SixDoF.P3.Position')))
        pos = finalState(15:17);
        value = norm(pos);
        cost = -value;
%     else
%         warning('Got wrong state variables for value function');
%     end
end
% % Moved to it's own file for modularities sake.
% % function setUAmplitudeEven(alpha)
% % global uAmplitudeEven
% % mag = 2;
% % %trying to assign angles, so a change in either will change z, when it's at
% % %the singularity point.
% % uAmplitudeEven(3) = mag*cos(alpha(2))*cos(alpha(1));
% % uAmplitudeEven(1) = -mag*cos(alpha(2))*sin(alpha(1));
% % uAmplitudeEven(2) = mag*sin(alpha(2));
% % 
% % uAmplitudeEven = uAmplitudeEven
% % 
% % end
% %     
    