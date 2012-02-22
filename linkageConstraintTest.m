t = 1:0.01:20;
a = 1;
b = 1;
c = 1;
d = .1;
T = -pi/2;
w = 1;

t2 = a*cos(w*t)+b;
t3 = c*sin(w*t)+d;
t2b = a*cos(w*t+T)+b;
t3b = c*sin(w*t+T)+d;

x0 = cos(t2).*cos(t3)+cos(t2b).*cos(t3b);
plot(x0)
title('constant for helix condition to be met');
ylabel('value');
xlabel('time');