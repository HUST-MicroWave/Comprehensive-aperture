%% 由L1B傅氏分量数据反演亮温图像
% 华中科技大学
clc;
clear;
ant_num=69;
arm_ant_num=21;
min_space=0.875;
Algorithm_flag='Band_limit';
window_name='Hanning';%选择窗函数，有{'Blackman','Hanning','Lanczos'}可选；
zoom_para=2;
polar_flag='HH';
switch polar_flag
    case {'HH','VV'}
        Scene_BT_Fourier=load('数据\导出的傅氏分量\Scene_BT_Fourier_item4518HH.txt');
        Data1=Scene_BT_Fourier(2:1396)+1i*Scene_BT_Fourier(1397:2791);
        Scene_BT_Fourier_complex=[Scene_BT_Fourier(1)*(1+1i);Data1;conj(Data1)];
    case 'HV'
        Scene_BT_Fourier_real=load('数据\导出的傅氏分量\Scene_BT_Fourier_item3HV_real.txt');
        Scene_BT_Fourier_imag=load('数据\导出的傅氏分量\Scene_BT_Fourier_item4HV_imag.txt');
        Scene_BT_Fourier_complex=Scene_BT_Fourier_real+1i*Scene_BT_Fourier_imag;
end

load Fov.mat
load UV_sorted_mat.mat
load Visibility_sample_contain0.mat
rownum=size(Visibility_sample_contain0,1);
Visibility_padzero=zeros(rownum,2);
Visibility_padzero(:,1)=Visibility_sample_contain0(:,1)+1i*Visibility_sample_contain0(:,2);
% T_Fourier=T_fourier_complex;
T_Fourier=Scene_BT_Fourier_complex;
UV_sorted_all=UV_sorted_mat;
% %% 加窗；
% W=zeros(size(T_Fourier));
%  for k1=1:size(T_Fourier,1)
%      dw=sqrt(real(UV_sorted_all(k1)).^2+imag(UV_sorted_all(k1)).^2)/(sqrt(3)*arm_ant_num*min_space);
%      W(k1)=0.42+0.5*cos(pi*dw)+0.08*cos(2*pi*dw);%加Blackman窗；
%  end
% T_Fourier=T_Fourier.*W; 

%% 加窗
switch window_name
    case {'Blackman','Hanning','Lanczos'}
        W=zeros(size(T_Fourier));
        for k1=1:size(T_Fourier,1)
           dw=sqrt(real(UV_sorted_all(k1)).^2+imag(UV_sorted_all(k1)).^2)/(sqrt(3)*arm_ant_num*min_space);
                switch window_name
                    case 'Blackman'
                        W(k1)=0.42+0.5*cos(pi*dw)+0.08*cos(2*pi*dw);%加Blackman窗；
                    case 'Hanning'
                        W(k1)=0.5+0.5*cos(pi*dw);
                    case 'Lanczos'
                        W(k1)=sin(pi*dw)/(pi*dw+0.001);
                end
        end
      T_Fourier=T_Fourier.*W; 
end


% if size(un_red_UV,2)==2
% UV_sorted_all=un_red_UV(:,1)+1i*un_red_UV(:,2);
% end

V1=Visibility_padzero(:,1);
for k=1:size(UV_sorted_all,1)
    indexk=find(abs(V1-UV_sorted_all(k))<=100*eps);
    Visibility_padzero(indexk,2)=T_Fourier(k);
end   
    
d=0.875;
xi=real(Fov);
eta=imag(Fov);
tic
T=zeros(size(Fov));

for k=1:length(xi)
    le=sqrt(1-xi(k)^2-eta(k)^2);
    T(k)=le*(sqrt(3)*d^2/2)*T_Fourier'*exp(1i*2*pi*(xi(k)*real(UV_sorted_all)+eta(k)*imag(UV_sorted_all))); 
end
%{
for k=1:length(xi)
    T(k)=sqrt(1-xi(k)^2-eta(k)^2)*(sqrt(3)*d^2/2)*Visibility_padzero(:,2)'*exp(1i*2*pi*(xi(k)*real(Visibility_padzero(:,1))+eta(k)*imag(Visibility_padzero(:,2)))); 
end
%}
inv_T_J=real(T);
Draw_inverse_image( Fov,inv_T_J,zoom_para,Algorithm_flag)
