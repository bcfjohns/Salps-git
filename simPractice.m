function simPractice
global xInit uExternal
alphaVar = [1 pi/6, 1.2, 1.2, 12];
% options = simset('Solver', 'ode23t', 'OutputVariables', 'xy');
params.Solver = 'ode23t';
params.SaveFinalState = 'on';
params.FinalStateName = 'xFinal';
params.SaveFormat = 'Structure';
params.StartTime = '10';
params.StopTime = '13';
params.OutputTimes = 'linspace(10,13, 30*6)';
params.LoadExternalInput = 'on';
uExternal = ['[' num2str(alphaVar) ']'];
params.ExternalInput = 'uExternal';
    
simOut = sim('salpChain', params);

xInit = simOut.find('xFinal');

params.LoadInitialState = 'on';
params.InitialState = 'xInit';
params.StartTime = '13';
params.StopTime = '16';
params.OutputTimes = 'linspace(13,16, 30*6)';
% simget(options)
% input('simulate sext second');
simOut = sim('salpChain', params);

params.StartTime = '10';
params.StopTime = '16';
params.OutputTimes = 'linspace(10,16, 30*12)';
params.LoadInitialState = 'off';
simOut = sim('salpChain', params);

end
% 
% function [frequency, delay, amp] = UT(t)
%     frequency = 1;
%     delay = pi/6;
%     amp = [2 0.1 0.1];
% end
% 
