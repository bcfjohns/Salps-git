function a2 = angleN(angles)
%takes 0 to 360 returns -180 to 180
a2 = angles;
for i = 1:length(angles)
if (angles(i)>180)
    a2(i) = angles(i)-360;
end
end