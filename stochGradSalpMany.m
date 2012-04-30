%function stochGradSalpMany

numRuns = 50;
alphas=zeros(2,numRuns);
costs=zeros(1,numRuns);
endstate = zeros(1,numRuns);
historyAll = zeros(3,200,numRuns);
colorsFlag = ['k', 'c', 'r'];
colorsAll = ['b', 'g', 'r', 'c', 'm', 'y', 'k'];

for n = 1:numRuns
    currentOptimN = n
    [alphaHist, valueHist, exitFlag, finalAlpha, finalCost, finalIteration] = stochGradSalp;
    endstate(n) = exitFlag;
    if exitFlag == 1
        alphas(:,n) = alphaHist(:,end);
        costs(n) = valueHist(end);
    else
        alphas(:,n) = finalAlpha;
        costs(n) = finalCost;
    end
    %saveThe data from the run
    historyAll(1:2,:,n) = alphaHist;
    historyAll(3,:,n) = valueHist;
    %save the plots from stochGradSalp
    h = figure(1);
    saveas(h, ['run ' num2str(n) '.png']);
    
    figure(2);
    
    plot3(finalIteration, costs(n), n, [colorsFlag(exitFlag) '.']);
    hold on;
    title('cost reached after optimal.');
    xlabel('number of iterations');
    ylabel('cost');
    zlabel('run number');
    
    figure(3);
    plot3(historyAll(1,:,ii), historyAll(2,:,ii),historyAll(3,:,ii),[colorsAll(mod(ii,8)+1) '.']);
    title('points visited by 15 runs of the optimization');
    xlabel('alpha 1');
    ylabel('alpha 2');
    zlabel('cost');
    hold on
end

hold off;
figure(2);
hold off;