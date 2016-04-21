clc;clear
sequenceIndex = 2; % 1 or 2

nSamples = 500;
theta = zeros(nSamples,1);
theta(1) = 1;
p = [1/3 2/3];

for m = 1:nSamples-1
    if sequenceIndex == 1
        xi = randsrc(1,1,[1 2;0.5 0.5]); 
    elseif sequenceIndex == 2
        if theta(m) == 1
            xi = randsrc(1,1,[1 2;0.99 0.01]); 
        else
            xi = randsrc(1,1,[1 2;0.01 0.99]); 
        end
    end
    a = min(1,p(xi)/p(theta(m)));
    theta(m+1) = randsrc(1,1,[xi theta(m);a 1 - a]);
end

theta = theta(nSamples/10 + 1:end);
Pr_1 = length(find(theta==1))/length(theta)
Pr_2 = length(find(theta==2))/length(theta)

