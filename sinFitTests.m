close all;
   
tries = 100;
results = zeros(1,tries);
terrors = [];
numIters = zeros(1,tries);
meanIters = zeros(1,100);
for maxIter = 1:100
    maxIter = maxIter
% maxIter = 55;

    for ii = 1:tries
    x = [1:1000]';
    ci = rand(1,4);
    y = ci(1)+ci(2)*x+ci(3)*sin(ci(4)*x);

    % plot(x,y)

    liney = fittype('a+b*x');
    opts = fitoptions(liney);
    opts.StartPoint = rand(1,2);
    
    fitLin = fit(x,y,liney, opts);
    guesses = coeffvalues(fitLin);

    g = fittype('a+b*x+c*sin(d*x)');

    bestRsq = 0;
    Rsq = 0;
    iter = 0;
    while(Rsq <0.999 && iter < maxIter)
        iter = iter + 1;
        opts = fitoptions('Method', 'NonlinearLeastSquares');
        opts.StartPoint = [guesses rand(1,2)];

        [fit1, Gqual] = fit(x,y,g, opts);
        % isa = coeffvalues(fit1)
        Rsq = Gqual.rsquare;
        if (Rsq>bestRsq)
            bestRsq = Rsq;
        end
    end
    numIters(ii) = iter;
    results(ii) = bestRsq;
    if(bestRsq<0.9)
        terrors = [terrors; ci];
    end


    end
    % % end
    % max(results)
    meanIters(maxIter)=mean(numIters);
%     subplot(2,1,1);
%     plot(results, 'b');
%     subplot(2,1,2);
%     plot(numIters, 'g');
%     hold on;
%     plot([0,tries], [maxIter, maxIter],'r');
end    
    
plot(meanIters);




