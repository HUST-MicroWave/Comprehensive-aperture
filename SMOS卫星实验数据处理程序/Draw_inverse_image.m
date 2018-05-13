function Draw_inverse_image( Fov,inv_T,zoom_para,Algorithm_flag)
%�������ݵõ�������ͼ��
% ���пƼ���ѧ
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
        Fov1=(Fov-1i*imag(Fov))*exp(1i*pi)+1i*imag(Fov);%�������DFT���ݣ����ͼ��������任�����ҶԻ�����
    case 'Band_limit'
        Fov1=Fov*exp(-1i*pi);%������ô��������㷨������ת180�ȣ�
    case 'HFFT'
        Fov1=(Fov-real(Fov))*exp(1i*pi)+real(Fov);%�������HFFT���ݣ����ͼ�����½�����
    case 'HFFT2'
        Fov1=Fov*exp(-1i*pi/3);%�������HFFT2�㷨����˳ʱ����ת60�ȣ�
end

X=real(Fov1);
Y=imag(Fov1);
%% ��������ͼ��
% r=(max(real(Fov))-min(real(Fov)))/42/3;
r=Fov_min_space/sqrt(3);
%  r=sqrt(2)*Fov_min_space/2;
% ��ʼ��������
angle = 0:pi/3:5*pi/3;
% angle = pi/4:pi/2:7*pi/4
x = r*cos(angle);
y = r*sin(angle);
% ��ͼ
figure()
for k = 1:length(inv_T)
    if (X(k)^2+Y(k)^2<=1)
        xaxis = X(k)+x;
        yaxis = Y(k)+y;
        hold on
        fill(xaxis,yaxis,inv_T(k),'linestyle', 'none');
    end
end
% title('SMOS����ͼ��');
xlabel('\xi');
ylabel('\eta');
% colorbar
colorbar('location','EastOutside');
switch Algorithm_flag
    case 'DFT'
%         title('\bfSMOS���·���ͼ��(DFT�㷨)')
          title('SMOS���·���ͼ��(DFT�㷨)')
    case 'Band_limit'
        title('SMOS���·���ͼ��(���Ϸ��������㷨)')
    case 'HFFT'
%         title('SMOS���·���ͼ��(ȡģHFFT�㷨)')
        title('SMOS���·���ͼ��(ȡģHFFT�㷨)')
    case 'HFFT2'
        title('SMOS���·���ͼ��(ƽ��HFFT�㷨)')
end

% axis equal
% caxis([0.5,900])
end

