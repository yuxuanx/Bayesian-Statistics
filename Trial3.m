clc;clear
sigma = 0.7;
T = 100;
pm = 0.4;
ps = 1 - 2*pm;
load('xt.mat');
load('yt.mat');

p = zeros(10,10,T-2);
pp = [pm ps pm];

pq = zeros(10,10);
pq(1,1:2) = [ps,2*pm];
pq(10,9:10) = [2*pm,ps];

for i=2:9
    pq(i,i-1:i+1) = pp;
end

for i=1:T-2
    if i<9
        p(1,1:2,i) = [ps 2*pm];
        for j = 2:i+1
            p(j,j-1:j+1,i) = pp;
        end
    else
        p(:,:,i) = pq;
    end
end

p_f = zeros(10,10,T-2);
for i=1:T-2
    noise = normpdf(yt(i),1:10,sigma);
    for j=1:10
        p_f(:,j,i) = p(:,j,i).*noise';
    end
end

p_b = zeros(10,10,T-2);
for i=1:T-2
    noise = normpdf(yt(T-i),1:10,sigma);
    for j=1:10
        p_b(:,j,i) = p(:,j,i).*noise';
    end
end

p_1 = [ps 2*pm zeros(1,8)];
p_2 = [ps 2*pm zeros(1,8)];

pdf = zeros(T-1,10);
for t = 1:T-1
    pf = p_1/sum(p_1);
    i = 1;
    while i<t
        pf = pf*p_f(:,:,i);
        pf = pf/sum(pf);
        i = i+1;
    end

    pb = p_2/sum(p_2);
    i = 1;
    while i<T-t
        pb = pb*p_b(:,:,i);
        pb = pb/sum(pb);
        i = i+1;
    end

    pdf(t,:) = pf.*pb.*normpdf(yt(t),1:10,sigma);
    pdf(t,:) = pdf(t,:)/sum(pdf(t,:));
    s(t) = sum(pdf(t,:).*[1:10]);
end

figure
plot(0:T,xt,'-.',1:T-1,s,'-o');
xlabel('t')
legend('Trajectory','Expected value of estimated distribution')
title('Robot Movement')

