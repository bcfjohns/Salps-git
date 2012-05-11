lasti = 400;
plot3(alphaHist(1,1:lasti), alphaHist(2,1:lasti), valueHist(1:lasti));
xlabel('a1')
ylabel('a2')
zlabel('cost')
% figure()
% waterfall(alphaHist(1,:), alphaHist(2,:), valueHist);