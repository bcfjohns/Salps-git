close all;
colors = ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'b']
for ii =1:15
    ii
plot3(historyAll(1,:,ii), historyAll(2,:,ii),historyAll(3,:,ii),[colors(mod(ii,8)+1) '.']);
hold on;
end
hold off;