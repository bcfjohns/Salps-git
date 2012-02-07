%double checking my dynamic equations for a single salp from helix parameters
%fitted from the results of a simulation with the same salp parameters

%parameters
v  = 0.5772;
a = 54;
k = 0.03023; %radians
phi_o = 29.93/180*pi+0.01595;
theta = 324.7*pi/180;
psi = 315*pi/180;

cth = cos(theta);
sth = sin(theta);
cpsi = cos(psi);
spsi = sin(psi);

ii = 0;
len = 10000;
xdd = 6.66*ones(1, len);
ydd = 6.66*ones(1, len);
zdd = 6.66*ones(1, len);
ts = 0:0.1:len/10;

for t = ts %time for plots 
    ii = ii+1; 
    phi = k*t+phi_o;
    cphi = cos(phi);
    sphi = sin(phi);
    
    xd = -k*a*sin(k*t);
    yd = k*a*cos(k*t);
    zd = v;
    phid = k;
    thd = 0;
    psid = 0;
    
    Rtrans = [cth*cphi spsi*cth*cphi-cpsi*sphi cpsi*sth*cphi+spsi*sphi;
              cth*sphi spsi*sth*sphi+cpsi*cphi cpsi*sth*sphi-spsi*cphi;
              -sphi     cth*spsi                cth*cpsi];
    ddots = Rtrans*([1;1;1]-[xd*abs(xd); yd*abs(yd); zd*abs(zd)]);
    xdd(ii) = ddots(1) + k^2*cos(k*t);
    ydd(ii) = ddots(2) + k^2*sin(k*t);
    zdd(ii) = ddots(3);

end
close all;
plot(ts, xdd, 'b');
hold on;
plot(ts, ydd, 'g');
plot(ts, zdd, 'r');

legend('xdd', 'ydd', 'zdd');
hold off;
%zdouble dot should be 0

