clc;clear
x0 = 1;
sigma = 0.1;
sigma2 = 0.5;
sigma3 = 1;
T = 100;
xt = zeros(T+1,0);
yt = zeros(T,0);
xt(1) = x0;
%% No memory
for i = 1:T
    xt(i+1) = randi(10,1);
    yt(i) = xt(i+1) + sigma^2*randn;
    yt2(i) = xt(i+1) + sigma2^2*randn;
    yt3(i) = xt(i+1) + sigma3^2*randn;
end
figure
plot(0:T,xt,'-.',1:T,yt,'*',1:T,yt2,'x',1:T,yt3,'o');
xlabel('t')
legend('Trajectory','Observation with \sigma=0.1','Observation with \sigma=0.5'...
    ,'Observation with \sigma=1')
title('Robot Movement')
%% Actual process
pm = 0.2;
for i = 1:T
    if xt(i) == 1
        xt(i+1) = randsample([2 1],1,true,[2*pm 1-2*pm]);
    elseif xt(i) == 10
        xt(i+1) = randsample([9 10],1,true,[2*pm 1-2*pm]);
    else
        xt(i+1) = randsample([xt(i)+1 xt(i) xt(i)-1],1,true,[pm 1-2*pm pm]);
    end
end
yt = xt(2:T+1) + 0.7^2*randn(1,T);
figure
plot(0:T,xt,'-.',1:T,yt,'-x');
xlabel('t')
legend('Trajectory','Observation with \sigma=0.7')
title('Robot Movement')


