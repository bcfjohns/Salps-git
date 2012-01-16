%take the list of rotation matrices convert to Euler angles for two salps
%and plot the euler angles to compare them.
EA1 = [];
EA2 = [];
for i = 1:length(RotM1)
    EA1p = SpinCalc('DCMtoEA132', reshape(RotM1(i, :), 3,3), 0.1, 0);
    
    EA1 = [angleN(EA1p); EA1];
%     
%     EA2p = SpinCalc('DCMtoEA132', reshape(RotM2(i, :), 3,3), 0.1, 0);
%     EA2 = [angleN(EA2p); EA2];
%     
end


%%
subplot(3,1,1)
plot(EA1(:,1), 'r');
% hold on;
% plot(EA2(:,1), 'g');
% hold off;

subplot(3,1,2)
plot(EA1(:,2), 'r');
% hold on;
% plot(EA2(:,2), 'g');
% hold off;

subplot(3,1,3)
plot(EA1(:,3), 'r');
% hold on;
% plot(EA2(:,3), 'g');
% hold off;

