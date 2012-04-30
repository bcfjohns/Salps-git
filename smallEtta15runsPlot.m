close all;
colors = ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'b']
for ii =3
    ii
plot3(historyAll(1,:,ii), historyAll(2,:,ii),historyAll(3,:,ii),[colors(mod(ii,8)+1) '.']);
title('points visited by 15 runs of the optimization');
xlabel('alpha 1');
ylabel('alpha 2');
zlabel('cost');

hold on;
end
hold off;