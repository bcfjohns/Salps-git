function [answer, endVal] = stochGradTest
global params
params = abs(10*randn(4,1));

alpha = 70*randn(2,1);
plot3(alpha(1), alpha(2), quadBowlIdeal(alpha), 'go', 'MarkerSize', 9, 'LineWidth',5);
hold on;

etta = 0.00002;
stand_dev_beta = 100.59;
[answer, hist, jhist] = stochGrad(@quadBowl, alpha, etta, stand_dev_beta);
plot3(hist(1,:), hist(2,:), jhist, '-', 'LineWidth',1);

%plot value function for reference
t = 0:0.02:norm(alpha)*10;
alphaTest = [t.*sin(t); t.*cos(t)]/10;
J_ref = zeros(1, length(t));
for i = 1:length(t)
    J_ref(i) = quadBowlIdeal(alphaTest(:, i));
end
plot3(alphaTest(1, :), alphaTest(2, :), J_ref, 'pr', 'MarkerSize', 1);
plot3(answer(1), answer(2), quadBowlIdeal(answer), 'c*', 'MarkerSize', 9, 'LineWidth',5);

%find average alpha from the last 10% of the data
% lAlpha = length(hist);
% e_alpha = mean(hist(:, floor(lAlpha*0.7):lAlpha), 2);
% plot3(e_alpha(1), e_alpha(2), quadBowlIdeal(e_alpha), 'yp', 'MarkerSize', 9, 'LineWidth', 5);
% legend('Start', 'Gradient path', 'Value function', 'End', 'Expected value of last n%');

hold off;
endVal = quadBowl(answer);
end

function value = quadBowlIdeal(alpha)
global params
    value = alpha'*alpha/200+40*sin(alpha(1)/10+.3*alpha(2)/2);% + params(1)*norm(alpha*params(2), 'fro');
end

function value = quadBowl(alpha)
    value = quadBowlIdeal(alpha);
end