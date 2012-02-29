close all;
   
tries = 10;%0;
results = zeros(1,tries);
terrors = [];
numIters = zeros(1,tries);
meanIters = zeros(1,100);

%for maxIter = 1:100
    maxIter =50;% maxIter
% maxIter = 55;

    for ii = 1:tries
    x = [1:1000]';
    ci = rand(1,5);
    y = ci(1)+ci(2)*x+ci(3)*sin(ci(4)*x+3*pi/2*ci(5));
    tic
    [fitCoeffs, Rsqfit] = linSinFit(x,y)
    toc
%     % plot(x,y)
%     
%     %do the linear fit
%     liney = fittype('a+b*x');
%     opts = fitoptions(liney);
%     opts.StartPoint = rand(1,2);
%     
%     fitLin = fit(x,y,liney, opts);
%     guesses = coeffvalues(fitLin);
% 
%     
%     %do an fft on the nonlinear portion to get an estimated frequency
%     y2 = y-guesses(1)-guesses(2)*x;
%     amplitudeGuess = range(y2)/2;
%     Y = fft(y2);
%     NFFT = length(y2);
%     Fs = 1/mean(diff(x));
%     omega = 2*pi*Fs/2*linspace(0,1,NFFT/2+1);
% 
%     [~, peakI] = max(abs(Y(1:NFFT/2+1)));
%     omegaGuess = omega(peakI);
% 
%     
%     g = fittype('a+b*x+c*sin(d*x+e)');
% 
%     bestRsq = 0;
%     Rsq = 0;
%     iter = 0;
%     while(Rsq <0.9999999 && iter < maxIter)
%         iter = iter + 1;
%         opts = fitoptions('Method', 'NonlinearLeastSquares');
%         opts.StartPoint = [guesses amplitudeGuess omegaGuess 3*pi/2*rand(1)];%rand(1)
% 
%         [fit1, Gqual] = fit(x,y,g, opts);
%         % isa = coeffvalues(fit1)
%         Rsq = Gqual.rsquare;
%         if (Rsq>bestRsq)
%             bestRsq = Rsq;
%         end
%     end
%     numIters(ii) = iter;
%     results(ii) = bestRsq;
%     if(bestRsq<0.9)
%         terrors = [terrors; ci];
%     end


    end
    % % end
    % max(results)
%     meanIters(maxIter)=mean(numIters);
%     subplot(2,1,1);
%     plot(results-1, 'b');
%     subplot(2,1,2);
%     plot(numIters, 'g');
%     hold on;
%     plot([0,tries], [maxIter, maxIter],'r');
% end    
%     
% plot(meanIters);




