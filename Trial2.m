clc;clear
x0 = 1;
sigma = 0.7;
pm = 0.4;
ps = 1 - 2*pm;

for T = 1:100

load('xt.mat');
load('yt.mat');
p = zeros(10,10,T-1);
pp = [pm ps pm];

pq = zeros(10,10);
pq(1,1:2) = [ps,2*pm];
pq(10,9:10) = [2*pm,ps];
for i=2:9
    pq(i,i-1:i+1) = pp;
end

for i=1:T-1
    if i<9
        p(1,1:2,i) = [ps 2*pm];
        for j = 2:i+1
            p(j,j-1:j+1,i) = pp;
        end
    else
        p(:,:,i) = pq;
    end
end

p_f = zeros(10,10,T-1);
for i=1:T-1
    noise = normpdf(yt(i),1:10,sigma);
    for j=1:10
        p_f(:,j,i) = p(:,j,i).*noise';
    end
end

p_1 = [ps 2*pm zeros(1,8)];
p_2 = normpdf(yt(T),1:10,sigma);

pf = p_1/sum(p_1);
i = 1;
while i<T
    pf = pf*p_f(:,:,i);
    pf = pf/sum(pf);
    i = i+1;
end

pb = p_2/sum(p_2);

pdf = pf.*pb;
pdf = pdf/sum(pdf);

I(T) = sum(pdf.*[1:10]);
x(T) = xt(end);
y(T) = yt(end);

end
figure
plot(0:T,xt,'-.',1:T,I,'-o');
xlabel('t')
legend('Trajectory','Expected value of estimated distribution')
title('Robot Movement')


