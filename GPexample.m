% -------------------
% test script for GP
% -------------------

close all
clear all
clc;

N=400;
trials=20;

% generate inputs
x=linspace(0,30,N);
%x=sort(rand(1,N)*10); % this will work too


% generate covariance matrix
K=zeros(N,N);
dc=7;
alpha=2;
sigma2=5;

for k=1:N
    for l=1:N
        K(k,l)=sigma2*exp(-1/(dc)*abs((x(k)-x(l)))^alpha);  
        if (k==l)
            K(k,l)=K(k,l)+1e-3;
        end
    end
end


% generate GP output values
R=chol(K);

for k=1:trials
    y=randn(1,N)*R;
    plot(x,y);
    hold on;    
end
hold off;


keyboard

%%%%%%%%%%%%%%%%
% learning given last y
%%%%%%%%%%%%%%%%

dc_test=linspace(0.01,20,20);
sigma2_test=linspace(0.01,8,24);
LLF=zeros(length(dc_test),length(sigma2_test));

for m=1:length(dc_test)      
    for n=1:length(sigma2_test)
        K_trial=zeros(N,N);        
        for k=1:N
            for l=1:N                
                K_trial(k,l)=sigma2_test(n)*exp(-1/(dc_test(m))*abs((x(k)-x(l)))^alpha);  
                if (k==l)
                    K_trial(k,l)=K_trial(k,l)+1e-3;
                end
            end
        end                
%        correction=log(abs(det(K_trial))); % this is numerically unstable
        correction=sum(log(eig(K_trial)));

                                
        LLF(m,n)=-0.5*y*inv(K_trial)*y'-0.5*correction;        
    end
end


% find most likely values
[max_val, position] = max(LLF(:));
[i1,i2]=ind2sub(size(LLF),position);
dc_hat=dc_test(i1)
sigma2_hat=sigma2_test(i2)





%correction=sum(log(eig(K_trial)));
