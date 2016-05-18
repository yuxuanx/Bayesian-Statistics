clc;clear
sigma = 0.7; % Standard deviation of noise
T = 100; % Number of time steps
pm = 0.4; % Transition probability
ps = 1 - 2*pm;
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

% Construct conditional matrix
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

% Forward message
p_f = zeros(10,10,T-1);
for i=1:T-1
    noise = normpdf(yt(i),1:10,sigma);
    for j=1:10
        p_f(:,j,i) = p(:,j,i).*noise';
    end
end

% Backward message
p_b = zeros(10,10,T-1);
for i=1:T-1
    noise = normpdf(yt(T-i+1),1:10,sigma);
    for j=1:10
        p_b(:,j,i) = pq(:,j).*noise';
    end
end

% Initial forward and backward message
p_1 = [ps 2*pm zeros(1,8)];
p_2 = ones(1,10);

% Belief propagation
pdf = zeros(T,10);
s = zeros(T,1);
for t = 1:T
    pf = p_1/sum(p_1);
    i = 1;
    while i<t
        pf = pf*p_f(:,:,i);
        pf = pf/sum(pf);
        i = i+1;
    end

    pb = p_2/sum(p_2);
    i = 1;
    while i<T-t+1
        pb = pb*p_b(:,:,i);
        pb = pb/sum(pb);
        i = i+1;
    end
    % Get marginal distribution
    pdf(t,:) = pf.*pb.*normpdf(yt(t),1:10,sigma);
    pdf(t,:) = pdf(t,:)/sum(pdf(t,:));
    % Expectation
    s(t) = sum(pdf(t,:).*[1:10]);
end

figure
plot(0:T,xt,'-.',1:T,s','-o');
xlabel('t')
legend('Trajectory','Expected value of estimated distribution')
title('Robot Movement')
figure
colormap('jet')
surf(1:100, 1:10, pdf', 'MeshStyle', 'row')
ylabel('Position')
xlabel('Time step')
title('Probability density distribution for each time step')
view(2)

