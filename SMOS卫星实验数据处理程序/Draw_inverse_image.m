function Draw_inverse_image( Fov,inv_T,zoom_para,Algorithm_flag)
%画出反演得到的亮温图像；
% 华中科技大学
%   Detailed explanation goes here
d=0.875;
max_arm=21;
min_space=d;
Fov_min_space=zoom_para/sqrt(3)/(3*max_arm)/min_space;
% Fov_min_space=zoom_para;
% xi=real(Fov);
% eta=imag(Fov);
% lean_parameter=sqrt(1-xi.^2-eta.^2);
% inv_T=lean_parameter.*inv_T;
inv_T=real(inv_T);
Fov1=Fov;
switch Algorithm_flag
    case 'DFT'
%       Fov=Fov*exp(-1i*pi);
        Fov1=(Fov-1i*imag(Fov))*exp(1i*pi)+1i*imag(Fov);%如果采用DFT反演，则对图像作镜像变换（左右对换）；
    case 'Band_limit'
        Fov1=Fov*exp(-1i*pi);%如果采用带限正则化算法，则旋转180度；
    case 'HFFT'
        Fov1=(Fov-real(Fov))*exp(1i*pi)+real(Fov);%如果采用HFFT反演，则对图像上下交换；
    case 'HFFT2'
        Fov1=Fov*exp(-1i*pi/3);%如果采用HFFT2算法，则顺时针旋转60度；
end

X=real(Fov1);
Y=imag(Fov1);
%% 画出反演图像
% r=(max(real(Fov))-min(real(Fov)))/42/3;
r=Fov_min_space/sqrt(3);
%  r=sqrt(2)*Fov_min_space/2;
% 初始化六边形
angle = 0:pi/3:5*pi/3;
% angle = pi/4:pi/2:7*pi/4
x = r*cos(angle);
y = r*sin(angle);
% 画图
figure()
for k = 1:length(inv_T)
    if (X(k)^2+Y(k)^2<=1)
        xaxis = X(k)+x;
        yaxis = Y(k)+y;
        hold on
        fill(xaxis,yaxis,inv_T(k),'linestyle', 'none');
    end
end
% title('SMOS反演图像');
xlabel('\xi');
ylabel('\eta');
% colorbar
colorbar('location','EastOutside');
switch Algorithm_flag
    case 'DFT'
%         title('\bfSMOS亮温反演图像(DFT算法)')
          title('SMOS亮温反演图像(DFT算法)')
    case 'Band_limit'
        title('SMOS亮温反演图像(傅氏分量反演算法)')
    case 'HFFT'
%         title('SMOS亮温反演图像(取模HFFT算法)')
        title('SMOS亮温反演图像(取模HFFT算法)')
    case 'HFFT2'
        title('SMOS亮温反演图像(平移HFFT算法)')
end

% axis equal
% caxis([0.5,900])
end

