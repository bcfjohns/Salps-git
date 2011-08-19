function [alpha, alphaHist, valueHist] = stochGrad(valueFunction, alpha, etta, stand_dev_beta)
    sizeBeta = size(alpha);
    maxI = 1e4;
    alphaHist = zeros(length(alpha), maxI);
    valueHist = zeros(1, maxI);
    for i = 1:maxI
        beta = stand_dev_beta*randn(sizeBeta);
        J_alpha = valueFunction(alpha);
        J_alpha_beta = valueFunction(alpha+beta);
        dalpha = -etta*(J_alpha_beta-J_alpha)*beta;
        
        alphaHist(:,i) = alpha;
        valueHist(i) = J_alpha;
        alpha = alpha+dalpha; 
    end
    
    
end