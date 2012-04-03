%function stochGradSalpMany

numRuns = 50;
alphas=zeros(2,numRuns);
costs=zeros(1,numRuns);
endstate = zeros(1,numRuns);
colors = ['k', 'c', 'r'];
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
    figure(5);
    hold on;
    plot3(finalIteration, costs(n), n, [colors(exitFlag) '.']);
    hold off;
    title('cost reached after optimal.');
    xlabel('number of iterations');
    ylabel('cost');
    zlabel('run number');
end