clc;clear
load('trainingdata.mat')
N = length(xt);
a1_test = 137;
a2_test = 0.004;
a3_test = 120;
LLF=zeros(length(a1_test),length(a2_test),length(a3_test));

for m=1:length(a1_test)      
    for n=1:length(a2_test)
        for p = 1:length(a3_test)
        K_trial=zeros(N,N);        
        for k=1:N
            for l=1:N                
                %K_trial(k,l)=a1_test(n)*exp(-(a2_test(m))*abs((xt(k)-xt(l))));
                K_trial(k,l)=a1_test(m)*exp(-a2_test(n)*sin(abs(xt(k)-xt(l))/a3_test(p))^2);
                if (k==l)
                    K_trial(k,l)=K_trial(k,l)+1e-3;
                end
            end
        end                
%        correction=log(abs(det(K_trial))); % this is numerically unstable
        correction=sum(log(eig(K_trial)));                            
        LLF(m,n,p)=-0.5*yt/K_trial*yt'-0.5*correction;
        end
    end
end

[max_val, position] = max(LLF(:));
[i1,i2,i3]=ind2sub(size(LLF),position);
a1_hat = a1_test(i1);
a2_hat = a2_test(i2);
a3_hat = a3_test(i3);

K = zeros(N,N);
for k=1:N
    for l=1:N
        %K(k,l)=a1_hat*exp(-a2_hat*abs((xt(k)-xt(l))));  
        K(k,l)=a1_hat*exp(-a2_hat*sin(abs(xt(k)-xt(l))/a3_hat)^2); 
        if (k==l)
            K(k,l)=K(k,l)+0.03^2;
        end
    end
end

x = 0:1000;
N = length(x);
K = zeros(N,N);
for k=1:N
    for l=1:N
        %K(k,l)=a1_hat*exp(-a2_hat*abs(x(k)-x(l)));  
        %K(k,l)=a1_hat*exp(-a2_hat*abs(x(k)-x(l))^2); 
        K(k,l)=a1_hat*exp(-a2_hat*sin(abs(x(k)-x(l))/a3_hat)^2); 
        if (k==l)
            K(k,l)=K(k,l)+0.03^2;
        end
    end
end

trials=3;
R=chol(K);
figure
plot(xt,yt,'.');hold on
for k=1:trials
    y=randn(1,N)*R;
    plot(x,y,'.');
    hold on;    
end
hold off;
title('Zero-mean Gaussian realizations');
xlabel('x');
legend('training data');