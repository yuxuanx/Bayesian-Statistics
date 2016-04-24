theta = 0:0.01:6;
y1 = 1/4*(theta-3).^2 + 1/4;
y2 = 1/121*(theta-1).^2 + 100/121;
y3 = ones(length(theta),1)';
figure;
plot(theta,[y1;y2;y3]);
xlabel('\theta');
legend('R(\theta,y_1(x)=3)','R(\theta,y_2(x)=1)','R(\theta,y(x)=x)');
%axis([0 6 0 6]);
