clc;clear
x0 = 1;
sigma = 1;
T = 200;
xt = zeros(T+1,0);
xt(1) = x0;
pm = 0.4;
ps = 1 - 2*pm;

for i = 1:T
    if xt(i) == 1
        xt(i+1) = randsample([2 1],1,true,[2*pm 1-2*pm]);
    elseif xt(i) == 10
        xt(i+1) = randsample([9 10],1,true,[2*pm 1-2*pm]);
    else
        xt(i+1) = randsample([xt(i)+1 xt(i) xt(i)-1],1,true,[pm 1-2*pm pm]);
    end
end
yt = xt(2:T+1) + sigma^2*randn(1,T);


m = zeros(T,10);
m(1,:) = [ps 2*pm zeros(1,8)];
m(2,:) = [m(1,1)*ps+m(1,2)*pm m(1,1)*2*pm+m(1,2)*ps m(1,2)*pm zeros(1,7)];
m(3,:) = [m(2,1)*ps+m(2,2)*pm m(2,1)*2*pm+m(2,2)*ps+m(2,3)*pm m(2,2)*pm+m(2,3)*ps m(2,3)*pm zeros(1,6)];
m(4,:) = [m(3,1)*ps+m(3,2)*pm m(3,1)*2*pm+m(3,2)*ps+m(3,3)*pm m(3,2)*pm+m(3,3)*ps+m(3,4)*pm...
    m(3,3)*pm+m(3,4)*ps m(3,4)*pm zeros(1,5)];
m(5,:) = [m(4,1)*ps+m(4,2)*pm m(4,1)*2*pm+m(4,2)*ps+m(4,3)*pm m(4,2)*pm+m(4,3)*ps+m(4,4)*pm...
    m(4,3)*pm+m(4,4)*ps+m(4,5)*pm m(4,4)*pm+m(4,5)*ps m(4,5)*pm zeros(1,4)];
m(6,:) = [m(5,1)*ps+m(5,2)*pm m(5,1)*2*pm+m(5,2)*ps+m(5,3)*pm m(5,2)*pm+m(5,3)*ps+m(5,4)*pm...
    m(5,3)*pm+m(5,4)*ps+m(5,5)*pm m(5,4)*pm+m(5,5)*ps+m(5,6)*pm ...
    m(5,5)*pm+m(5,6)*ps m(5,6)*pm zeros(1,3)];
m(7,:) = [m(6,1)*ps+m(6,2)*pm m(6,1)*2*pm+m(6,2)*ps+m(6,3)*pm m(6,2)*pm+m(6,3)*ps+m(6,4)*pm...
    m(6,3)*pm+m(6,4)*ps+m(6,5)*pm m(6,4)*pm+m(6,5)*ps+m(6,6)*pm ...
    m(6,5)*pm+m(6,6)*ps+m(6,7)*pm m(6,6)*pm+m(6,7)*ps m(6,7)*pm zeros(1,2)];
m(8,:) = [m(7,1)*ps+m(7,2)*pm m(7,1)*2*pm+m(7,2)*ps+m(7,3)*pm m(7,2)*pm+m(7,3)*ps+m(7,4)*pm...
    m(7,3)*pm+m(7,4)*ps+m(7,5)*pm m(7,4)*pm+m(7,5)*ps+m(7,6)*pm ...
    m(7,5)*pm+m(7,6)*ps+m(7,7)*pm m(7,6)*pm+m(7,7)*ps+m(7,8)*pm m(7,7)*pm+m(7,8)*ps m(7,8)*pm zeros(1,1)];
m(9,:) = [m(8,1)*ps+m(8,2)*pm m(8,1)*2*pm+m(8,2)*ps+m(8,3)*pm m(8,2)*pm+m(8,3)*ps+m(8,4)*pm...
    m(8,3)*pm+m(8,4)*ps+m(8,5)*pm m(8,4)*pm+m(8,5)*ps+m(8,6)*pm ...
    m(8,5)*pm+m(8,6)*ps+m(8,7)*pm m(8,6)*pm+m(8,7)*ps+m(8,8)*pm ...
    m(8,7)*pm+m(8,8)*ps+m(8,9)*pm m(8,8)*pm+m(8,9)*ps m(8,9)*pm];
for i=10:T
    m(i,:) = [m(i-1,1)*ps+m(i-1,2)*pm m(i-1,1)*2*pm+m(i-1,2)*ps+m(i-1,3)*pm m(i-1,2)*pm+m(i-1,3)*ps+m(i-1,4)*pm...
    m(i-1,3)*pm+m(i-1,4)*ps+m(i-1,5)*pm m(i-1,4)*pm+m(i-1,5)*ps+m(i-1,6)*pm ...
    m(i-1,5)*pm+m(i-1,6)*ps+m(i-1,7)*pm m(i-1,6)*pm+m(i-1,7)*ps+m(i-1,8)*pm ...
    m(i-1,7)*pm+m(i-1,8)*ps+m(i-1,9)*pm m(i-1,8)*pm+m(i-1,9)*ps+m(i-1,10)*2*pm m(i-1,9)*pm+m(i-1,10)*ps];
end

G = zeros(T,10);
for j=1:T
    G(j,:) = normpdf(yt(j),1:10,sigma);
end

f = m.*G;
ff = f.*f;

p = zeros(T,10);
for k=1:T
    p(k,:) = ff(k,:)/sum(ff(k,:));
end

[~,I] = max(p,[],2);

figure
plot(0:T,xt,'-x',1:T,yt,'-*',1:T,I','-o');
xlabel('t')
legend('Trajectory','Observation','Estimation')
title('Robot Movement')