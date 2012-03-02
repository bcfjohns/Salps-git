function values = unboundTheta(thetas)
%takes data bounded between +- pi and undbounds it, so there aren't
%discontinuities.
boundLimit = 1.5; %the abs of a number to count as a turning point
delta = 1.5; %how much the delta has to be between two numbers to assume there's a wrap around
values = zeros(size(thetas));
shift = 0;
values(1) = thetas(1);
for i = 2:length(thetas);
    if (thetas(i)-thetas(i-1) > delta && thetas(i) > boundLimit)
        shift = shift-2*pi;
    else
        if (thetas(i)-thetas(i-1) < -delta && thetas(i) < -boundLimit)
            shift = shift+2*pi;
        end
    end
    values(i) = thetas(i)+shift;
end