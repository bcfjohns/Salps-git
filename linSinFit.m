function [coeffs, bestRsq] = linSinFit(x,y)
    maxIter = 50;
    
    %do the linear fit
    liney = fittype('a+b*x');
    opts = fitoptions(liney);
    opts.StartPoint = rand(1,2);
    
    fitLin = fit(x,y,liney, opts);
    guesses = coeffvalues(fitLin);

    
    %do an fft on the nonlinear portion to get an estimated frequency
    y2 = y-guesses(1)-guesses(2)*x;
    amplitudeGuess = range(y2)/2;
    Y = fft(y2);
    NFFT = length(y2);
    Fs = 1/mean(diff(x));
    omega = 2*pi*Fs/2*linspace(0,1,floor(NFFT/2+1));

    [~, peakI] = max(abs(Y(1:floor(NFFT/2+1))));
    omegaGuess = omega(peakI);

    
    g = fittype('a+b*x+c*sin(d*x+e)');

    bestRsq = 0;
    Rsq = -1;
    iter = 0;
    while(Rsq <0.9999999 && iter < maxIter)
        iter = iter + 1;
        opts = fitoptions('Method', 'NonlinearLeastSquares');
        opts.StartPoint = [guesses amplitudeGuess omegaGuess 3*pi/2*rand(1)];%rand(1)

        [fit1, Gqual] = fit(x,y,g, opts);
        % isa = coeffvalues(fit1)
        Rsq = Gqual.rsquare;
        if (Rsq>bestRsq)
            bestRsq = Rsq;
            coeffs = coeffvalues(fit1);
        end
    end
    if (Rsq<0)
        what = 'things dont work';
        coeffs = [6 6 6 6 6];
        bestRsq = 0;
    end
end