clc;clear
mu_dist1 = [1 3]; cov_dist1 = [1 1.5;1.5 3];
mu_dist2 = [5 1]; cov_dist2 = [3 -1.5;-1.5 1];
% Gaussian mixture density of samples
pdf = @(x) 0.7*mvnpdf(x,mu_dist1,cov_dist1) + 0.3*mvnpdf(x,mu_dist2,cov_dist2);

alpha = 0.5;
cov_p = alpha*eye(2);
% Proposal density
proppdf = @(x,mu) mvnpdf(x,mu,cov_p);
% Proposal sample generator
proprnd = @(mu) mvnrnd(mu,cov_p);

nsamples = 10000; % Number of samples
start = [1 1]; % Initial start point
% Generate Markov chain
[smpl, accept] = mhsample([1 1],nsamples,'pdf',pdf,'proppdf',proppdf,'proprnd',proprnd);

figure;
plot(smpl(1000:end,1),smpl(1000:end,2),'.');hold on
phi = linspace(0,2*pi,100); % Create grid in interval [0,2*pi]
mu_1 = [1;3]; % Mean of a 2?D normal random variable
P_1 = [1 1.5;1.5 3]; % Covariance of a 2?D normal random variable
x1 = repmat(mu_1,1,100)+sqrt(3)*sqrtm(P_1)*[cos(phi);sin(phi)]; %The ellipsoid 
plot(x1(1,:),x1(2,:),'r','LineWidth',1);hold on

mu_2 = [5;1]; % Mean of a 2?D normal random variable
P_2 = [3 -1.5;-1.5 1]; % Covariance of a 2?D normal random variable
x2 = repmat(mu_2,1,100)+sqrt(3)*sqrtm(P_2)*[cos(phi);sin(phi)]; %The ellipsoid 
plot(x2(1,:),x2(2,:),'r','LineWidth',1)
xlabel('x','FontSize',12);
ylabel('y','FontSize',12);
title('Samples from the Markov chain');


