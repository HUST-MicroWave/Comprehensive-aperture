% 由SMOS-L1a级数据（校正的可见度）反演亮温分布，
% 即由可见度构成的自相关矩阵得到亮温分布；
% 华中科技大学
clear; clc;
tic;
%% 构造Y型阵
lambda=0.2121;
channel_num=72;
ant_num=69;
arm_ant_num=21;
min_space=0.875;
ext_zero_num=0;%在最小补零方式的基础上继续补零；
zoom_para=2-ext_zero_num/20;%补零后用于计算Fov的最小间距；
window_name='Blackman';%选择窗函数，有{'Blackman','Hanning','Lanczos'}可选；
polor_flag='HHH';%选择使用的极化方式； 
Algorithm_flag='HFFT2';%选择反演算法；
cali_flag=1;%取1时使用定标天线，取0时不使用；
Remove_flag=0;%选择是否剔除同一基线获得的可见度中偏差较大的值，选1时剔除；

% path='数据\导出的可见度\clib_visibility_5VVV'; 
%clib_visibility_1HHH';
% path='数据\导出的可见度\clib_visibility_4518HHH';
path='数据\导出的可见度\clib_visibility_5VVV';
%此为用SMOSView导出的L1a级别的可见度数据，存储格式为txt；
% Constant_land_BT=192.3917;
Constant_land_BT=0;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%得到天线位置
arm_A=-1:-1:-21;
ant_min_space=0.875;
arm_A=ant_min_space*arm_A*1i;
arm_A_cal=ant_min_space*[3 1]*1i*exp(1i*2*pi/3);
%arm_A_cal=[];

arm_A=[arm_A_cal,arm_A]*exp(1i*pi/2);
arm_A=arm_A.';
arm_B=arm_A.*exp(-1i*2*pi/3);
arm_C=arm_B.*exp(-1i*2*pi/3);
arm_A=[real(arm_A),imag(arm_A)];
arm_B=[real(arm_B),imag(arm_B)];
arm_C=[real(arm_C),imag(arm_C)];
ant_pos=[arm_A;arm_B;arm_C]'; %天线位置以波长为单位；
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if cali_flag==0
    ant_pos=ant_pos(:,[1 3:23 24 26:46 47 49:69]);
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 得到UV分布
un_red_UV = GetUVfrom_ant(ant_pos);%得到非重复的采样频率；
ext_UV = Getext_UVfromant_pos(arm_ant_num,ext_zero_num);%得到补零后的UV平面；
[Visibility_unred_all,self_correlation_matrix]  = GetUnred_Visibility(path,ant_pos,un_red_UV,channel_num,Remove_flag,polor_flag,cali_flag);%得到冗余平均后的可见度；

%%%%保存去冗余的余弦可见度和uv采样点
save Visibility_unred_all.mat;
save un_red_UV.mat;
% % % % %%%%%%绘制自相关函数
% % % % Plot_self_Visibility(path);
% % % % %%%%%%绘制可见度
% % % % plot_Visibility_on_UV(Visibility_unred_all,un_red_UV);
Fov= Get_Fovfromant(ext_UV,arm_ant_num,zoom_para,min_space);

%% 校正部分：
% V_land=zeros(size(Visibility_unred_all));
% for k=1:size(un_red_UV,1)
%     V_land(k)=Constant_land_BT*ones(size(Fov'))*(exp(-1i*2*pi*(un_red_UV(k,1)*real(Fov)+un_red_UV(k,1)*imag(Fov)))./sqrt(1-abs(Fov).^2));
% end
% Visibility_unred_all=Visibility_unred_all-V_land;

%% 加窗
switch window_name
    case {'Blackman','Hanning','Lanczos'}
        W=zeros(size(Visibility_unred_all));
        for k1=1:size(Visibility_unred_all,1)
            dw=sqrt(un_red_UV(k1,1).^2+un_red_UV(k1,2).^2)/(sqrt(3)*arm_ant_num*min_space);
%             dw=abs(extent_UV(k))/(sqrt(3)*ant_num*min_space);
            switch window_name
                case 'Blackman'
                    W(k1)=0.42+0.5*cos(pi*dw)+0.08*cos(2*pi*dw);%加Blackman窗；
                case 'Hanning'
                    W(k1)=0.5+0.5*cos(pi*dw);
                case 'Lanczos'
                    W(k1)=sin(pi*dw)/(pi*dw+0.001);
            end
        end
        Visibility_unred_all=Visibility_unred_all.*W;
end


% % % % % % % % % Window_data = zeros(size(Visibility_unred_all));
% % % % % % % % % max_radius = sqrt(3) * max_arm * min_space;%Y型阵六边形采样平面的加窗半径；
% % % % % % % % % 
% % % % % % % % % for k = 1:length(Visibility_unred_all)
% % % % % % % % %     if (counter(k) ~= 0)
% % % % % % % % %     dw = abs(extent_UV(k)) / max_radius;
% % % % % % % % %     switch (window_name)  
% % % % % % % % %         case 'blackman'
% % % % % % % % %             Window_data(k) = 0.42 + 0.5 * cos(pi * dw) + 0.08 * cos(2 * pi * dw);
% % % % % % % % %         case 'bartlett'
% % % % % % % % %             Window_data(k) = 1 - dw;
% % % % % % % % %         case 'poisson'
% % % % % % % % %             alphak=0.6;%任取0～1之间的值即可；
% % % % % % % % %             Window_data(k) = exp(-abs(alphak) * dw);
% % % % % % % % %         case 'gauss'
% % % % % % % % %             alphak=0.6;%任取0～1之间的值即可；
% % % % % % % % %             Window_data(k) = exp(-abs(alphak) * dw * dw);
% % % % % % % % %         case 'lanczos'
% % % % % % % % %             Window_data(k) = sin(pi * dw) / (pi * dw);
% % % % % % % % %         case 'hamming'
% % % % % % % % %             Window_data(k) = 0.54 + 0.46 * cos(pi * dw);
% % % % % % % % %         case 'hanning'
% % % % % % % % %             Window_data(k) = 0.5 + 0.5 * cos(pi * dw);
% % % % % % % % %         case 'norton'
% % % % % % % % %             Window_data(k) = 0.548 - 0.0833 * (1 - dw * dw) + 0.5353 * (1 - dw * dw) * (1 - dw * dw);
% % % % % % % % %     end
% % % % % % % % %     else
% % % % % % % % %             Window_data(k) = 0;
% % % % % % % % %     end
% % % % % % % % % end
% % % % % % % % % save window_data
% % % % % % % % % Visibility_unred_all= Window_data .* Visibility_unred_all;


%% 存储可见度和对应的采样频率；
index = zeros(size(un_red_UV,1),1);
for k=1:size(un_red_UV,1)
    for k1=1:size(ext_UV,1)
        if abs(ext_UV(k1,1)-un_red_UV(k,1))<=1.0e-10 && abs(ext_UV(k1,2)-un_red_UV(k,2))<=1.0e-10
            index(k)=k1;
        end
    end
end

Visibility_sample_contain0=zeros(size(ext_UV,1),3);
Visibility_sample_contain0(:,1:2)=ext_UV;
Visibility_sample_contain0(index,3)=Visibility_unred_all;

switch Algorithm_flag
    case 'DFT'
        inv_T=DFT_Inverse(Fov,Visibility_sample_contain0);
    case 'HFFT'
        inv_T=HFFT_Inverse(Visibility_sample_contain0,ext_UV,min_space,arm_ant_num);
    case 'HFFT2'
        inv_T=HFFT_Inverse2(Visibility_sample_contain0,ext_UV,min_space,arm_ant_num);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 画图显示：
Draw_inverse_image(Fov,inv_T,zoom_para,Algorithm_flag); %画出亮温分布图；
%%
toc;