clc;clear;
N1 = 20;
N2 = 200;
mu = [-3;0.6;3];
sigma = cat(3,1,1,1);
p = [0.25,0.45,0.3];
obj = gmdistribution(mu,sigma,p);
X = linspace(-6,6,100)';
y = pdf(obj,X);
r1 = random(obj,N1);
r2 = random(obj,N2);
plot(X,y,'Linewidth',2); hold on;
plot(r2,zeros(N2,1),'yo')
plot(r1,zeros(N1,1),'ro')
title('A Gaussian mixture PDF and a few samples');
legend('PDF of Gaussian mixture','One realization of 200 samples','One realization of 20 samples');
