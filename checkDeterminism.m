function checkDeterminism
%exit flag says why it ended. 666-unknown reasons; 1-end of iterations; 2-didn't learn in first
%K iterations; 3-Simulation errored out
global valueHist alphaHist Salp1_PandV Salp1_angles uAmplitudeEven
maxI = 100;
alpha = [rand(1)*1.5  rand(1)*1.5];
%alpha = angles of propulsion
alphaHist = zeros(length(alpha), maxI);
valueHist = zeros(1, maxI);   



for i = 1:maxI
    i=i
    
    alpha = boundAngles(alpha);


    setUAmplitudeEven([alpha(1) alpha(2)]);
    try
        sim('salpChain');
    catch simError
        disp(simError.identifier);
        if strcmp(simError.identifier, 'SL_SERVICES:utils:CNTRL_C_INTERRUPTION')
            rethrow(simError); %rethrow cntrl-c breaks;
        end
        return
    end

    J_alpha = valueFunction();

    alphaHist(:,i) = alpha;
    valueHist(i) = J_alpha;

    rangeSoFar = range(valueHist(1:i))
    figure(3);
    plot3(alphaHist(1,1:i), alphaHist(2,1:i), valueHist(1:i),'.');
    title('valueHist, so far');
    xlabel('alpha1');
    ylabel('alpha2');
    zlabel('cost');

end

end

function alpha = boundAngles(alpha)
    anglebound = 1.5;
    if (alpha(1)>anglebound)
        alpha(1)=anglebound;
    else if (alpha(1)<0)
            alpha(1) = 0;
        end
    end
    
        if (alpha(2)>anglebound)
        alpha(2)=anglebound;
    else if (alpha(1)<0)
            alpha(1) = 0;
        end
    end
    
end

    