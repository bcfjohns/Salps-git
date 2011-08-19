%find steady state indices based on angles
T = 50*5; %at least one period to define the range we'll use.
margin = 0.1; %what margin to use, so don't cut data off if just a little different
time = Salp1_angles.time;
angle2 = Salp1_angles.signals(2).values;
angle1 = Salp1_angles.signals(1).values;
L = length(angle1);


min1 = min(angle1(L-T:L));
min1 = min1-margin*abs(min1);

max1 = max(angle1(L-T:L));
max1 = max1+margin*abs(max1);

min2 = min(angle2(L-T:L));
min2 = min2-margin*abs(min2);

max2 = max(angle2(L-T:L));
max2 = max2+margin*abs(max2);

smallestIndex = L-T;

jump = T;
while(smallestIndex > T)
angle1Part = angle1(smallestIndex-jump:smallestIndex);
angle2Part = angle2(smallestIndex-jump:smallestIndex);
if(min(angle1Part) > min1 && min(angle2Part) > min2 && ...
        max(angle1Part) < max1 && max(angle2Part) < max2)
    smallestIndex = smallestIndex-jump;
else
    break;
end

end
% 
% figure(1)
% plot(time(1:smallestIndex), angle1(1:smallestIndex), 'r');
% hold on;
% plot(time(smallestIndex: L), angle1(smallestIndex:L), 'b');
% plot(time, min1*ones(L,1), '--k');
% plot(time, max1*ones(L,1), '--k');
% hold off;
% title('angle1');
% axis([0 time(L) min1-0.1 max1+0.1]);
% 
% figure(2);
% plot(time(1:smallestIndex), angle2(1:smallestIndex), 'r');
% hold on;
% plot(time(smallestIndex: L), angle2(smallestIndex:L), 'b');
% plot(time, min2*ones(L,1), '--k');
% plot(time, max2*ones(L,1), '--k');
% hold off;
% title('angle2');
% axis([0 time(L) min2-0.1 max2+0.1]);

velocities = Salp1_PandV.signals(2).values(smallestIndex:L, :);
velocity = sqrt(sum(velocities.^2,2));
avgVeloc = mean(velocity);
cost = -avgVeloc;