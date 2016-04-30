clc;clear
%% Generate observation samples
K = 3; % Number of components
N = 20; % Sample size
mu = [-3;0.6;3]; % Mean value
sigma = cat(3,1,1,1); % Variance
p = [0.25,0.45,0.3]; % Weights
% Gaussian mixture distribution
obj = gmdistribution(mu,sigma,p);
X = linspace(-6,6,100)';
y = pdf(obj,X); % True pdf
x = random(obj,N);

%% Gibbs Sampling
alpha = ones(3,1);
s = 1;
% Parameter initialization
z = zeros(N,1);
Pr = zeros(K,1);
nz = zeros(K,1);
summ = zeros(K,1);
pk = zeros(K,1);
lambda = gamrnd(alpha,1);
% Initial distribution of mean values and weights
Pi = lambda/sum(lambda);
mu_k = randn(3,1);

plot(X,y,'Linewidth',2); hold on
plot(x,zeros(N,1),'ro')
title('A Gaussian mixture PDF and a few samples');

% Markov chain Monte Carlo
for j=1:20
    for i=1:N
        for k=1:K
            % Conditional probability on z_i=k
            Pr(k) = Pi(k)*normpdf(x(i),mu_k(k),1);
        end
        Pr = Pr/sum(Pr);
        z(i) = randsample(1:K,1,true,Pr); % Sample z
    end
    for k=1:K
        % Find number of observations belong to the kth compoment
        nz(k) = length(find(z==k));
        summ(k) = sum(x(z==k));
        pk(k) = length(x(z==k))/length(x);
    end
    u = summ./(nz+1/s); 
    sigma = 1./(nz+1/s);
    mu_k = normrnd(u,sqrt(sigma)); % Sample mean value
    lambda = gamrnd(alpha/K+nz,1);
    Pi = lambda/sum(lambda); % Sample weights
    if j==2||j==4||j==10||j==20
    sigma = cat(3,1,1,1); % Variance
    newObj = gmdistribution(u,sigma,pk'); % Estimated model
    newPdf = pdf(newObj,X); % Estimated pdf
    plot(X,newPdf,'Linewidth',2); hold on
    else
    end
end
xlabel('Observations');
legend('true pdf','Observation samples','after 2 iterations','after 4 iterations',...
    'after 10 iterations','after 20 iterations','Location','NorthWest');
