function inv_T=DFT_Inverse(Fov,Visibility_sample_contain0)
% 华中科技大学
d=0.875;
% max_arm=21;
% min_space=d;
% Fov_min_space=1.5/sqrt(3)/(3*max_arm)/min_space;
xi=real(Fov);
eta=imag(Fov);
tic
T=zeros(size(Fov));

for k=1:length(xi)
    T(k)=sqrt(1-xi(k)^2-eta(k)^2)*(sqrt(3)*d^2/2)*Visibility_sample_contain0(:,3)'*exp(1i*2*pi*(xi(k)*Visibility_sample_contain0(:,1)+eta(k)*Visibility_sample_contain0(:,2))); 
end
inv_T=real(T);
toc
% 
% tic
% % Fov=Fov*exp(1i*pi);
% Fov1=(Fov-1i*imag(Fov))*exp(1i*pi)+1i*imag(Fov);
% X=real(Fov1);
% Y=imag(Fov1);
% %% 画出反演图像
% r=Fov_min_space/sqrt(3);
% % 初始化六边形
% angle = 0:pi/3:5*pi/3;
% x = r*cos(angle);
% y = r*sin(angle);
% % 画图
% figure()
% for k = 1:length(T)
%     if (X(k)^2+Y(k)^2<=1)
%         xaxis = X(k)+x;
%         yaxis = Y(k)+y;
%         hold on
%         fill(xaxis,yaxis,inv_T(k),'linestyle', 'none');
%     end
% end
% title('SMOS反演图像');
% xlabel('\xi');
% ylabel('\eta');
% % colormap gray;
% toc
% % axis equal
end