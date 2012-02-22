function failureAnal(varargin)
global Salp1_PandV Salp1_angles
load handel;
hallChorus = y(1:(length(y)-1)/2);

load('salpRun3.mat');
%analyize salpRun3 to try and figure out why things didn't converge and
%oscillated, so much. To see if steady state has anything to do with it.
%startIndex is the index to start running at, so if I stop partway through
%can restart, keep going later.

%start not at the beginning if told to
if (nargin == 0)
    currentIndex = 1;
else
    currentIndex = varagin{1};
end

maxIndex = length(alphaHist);

ssStatus = zeros(1, maxIndex);
while(currentIndex<=maxIndex)
   

    %rerun a simulation
    alpha = alphaHist(:,currentIndex);
    setUAmplitudeEven(alpha);

    sim('salpChain');

    J_alpha = valueFunction();
    
    %play the hallelujah chorus, so I know I need to go look at the data
    sound(hallChorus,Fs);
    
    %show plots
    %ask me if it's steady state or not
%     assignin('base', 'y', 'y');
%     assignin('base', 'n', 'n');
%     assignin('base', 'b', 'b');
    y='y';
    n='x';
    b='b';
    obs = input('Did this steady state at the end? (y/n) (or b to break');
    if (obs == 'y')
        plotStyle = 'g.';
        ssStatus(currentIndex) = 'y';
    else if (obs == 'n')
            plotStyle = '.r';
            ssStatus(currentIndex) = 'n';
        else
        currentIndex = currentIndex
        return;
        end
    end
    %add point to plot appropriately color coded.
    figure(3)
    hold on;
    plot3(alpha(1), alpha(2), J_alpha, plotStyle);
    
end

end
