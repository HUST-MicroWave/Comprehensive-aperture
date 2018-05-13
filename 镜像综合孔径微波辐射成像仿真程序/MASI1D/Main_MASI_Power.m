clear all;clc;tic;close all;tic;
%*************************************************************************
% 华中科技大学
%天线排列及其位置
height = [25 25.5 26 26.5 50 50.5 51 51.5]; % 波长归一化值，天线阵列与反射面的距离
% height = 1;
ant_num = 12;  % 天线数目
ant_spacing = [0 1 2 3 7 7 7 7 7 4 4 1]; %天线间隔
delta_u = 1; % 最小间隔
index = 1;
for k = 1:length(height)
    ant_pos = GetAntPos(height(k), ant_spacing, delta_u); %获取各天线到反射面的距离
    pair_sample = GetPairSample(ant_pos); %采样频率，获取每一对天线相关得到的采样频率
    cell_pair_sample(index,1) = {pair_sample};
    index = index + 1;
end
pair_sample_all = cell2mat(cell_pair_sample); %综合所有height值处的获取的pair_sample
unrpt_sample = GetUnrptSample(pair_sample_all); %pair_sample_all中的非重复采样频率
absent_sample = IsMissingSample(unrpt_sample); % 缺失的采样频率
all_sample = [unrpt_sample; absent_sample]; %所有采样频率
all_sample = sort(all_sample);%所有采样频率
A = GetA(unrpt_sample, pair_sample_all);
%*************************************************************************

%*************************************************************************
%系统参数
band = 1e7; % 带宽，Hz
tao = 1; % 积分时间，s
T_rec = 300; % 通道噪声，K


%%空间亮温分布及离散化信息
% N_l=500;
N_l = 3*round(max(all_sample)/delta_u); %空间离散化数,为满足G矩阵反演所需的足够离散度，P>3M,参考ESTAR,仅作参考
% d_theta = 0.00000000001;
% l_max = sqrt(1-sin(d_theta/2)); %l最大值，l=1时的奇点
l_max = 1/2/delta_u;
d_l = l_max/N_l; %l间距值
l =  0:d_l:l_max-d_l/2; %l值
l=l';

% load paper_Tb.mat
% Tb = zeros(1,N_l); %空间亮温分布
% Tb(1,122:486)= 200;% Tb(1,243:365)= 200;
Tb = zeros(N_l,1); % 空间亮温分布全部设置为0
Tb(100:550,1)= 100; 
Tb(250:400,1)= 200; 
% Tb(100:280,1)= 100; % 对单个反射板位置，下标不能超过N_l
% Tb(150:200,1)= 200; % 对单个反射板位置，下标不能超过N_l
Tb(50,1) = 200; % 一个点源
Tb(60,1) = 200; % 另一个点源

%单天线方向图
Fn = ones(N_l,1);
omega_ap = pi/3; %单天线立体角

figure;
plot(l, Tb, 'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on;xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)');
%*************************************************************************

%*************************************************************************
%同样阵列下的ASR成像，以与MIAS进行比较
P = sum(ant_spacing);
% sampling = 1/delta_u/(2*P+1);
V = zeros(2*P+1,1);
for p =1:P+1
    V(p) = 1/omega_ap*sum(Tb.*exp(-j*2*pi*(p-1)*delta_u*l)./sqrt(1-l.^2))*d_l;
end
for p=1:P
    V(2*P+2-p) = conj(V(p+1));
end
T_ASR =  real(fftshift(ifft(V)))*(2*P+1)*delta_u*omega_ap;
l_ASR = linspace(-1/2/delta_u,1/2/delta_u,2*P+1)';%视场及像素点
T_ASR = T_ASR.*sqrt(1-l_ASR.^2);%修正倾斜因子obliquity factor
figure;
plot(l_ASR(P+1:2*P+1), T_ASR(P+1:2*P+1), 'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on;xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)');title('ASR');
%*************************************************************************

%*************************************************************************
%各采样频率处的CV(cosine visibility)值
P_MIAS = max(all_sample); %cv对应的P值
CV_ideal = zeros(P_MIAS+1,1);
for p =1:P_MIAS+1
    CV_ideal(p) = 2/omega_ap*real(sum(Tb.*exp(-j*2*pi*(p-1)*delta_u*l)./sqrt(1-l.^2))*d_l);
end

%所有Height值处每对天线输出的相关值
R = zeros(size(pair_sample_all,1),1);
for k = 1:length(R)
    R(k) = CV_ideal(pair_sample_all(k,1)+1) - CV_ideal(pair_sample_all(k,2)+1);
end
%*************************************************************************

%*************************************************************************
%MIAS 理想coisne visibility 成像
l_MIAS = linspace(0,1/2/delta_u,P_MIAS+1);%视场及像素点
l_MIAS = l_MIAS';
T_MIAS_ideal = idct_cv(CV_ideal)*omega_ap*delta_u*(2*length(CV_ideal)-1);
T_MIAS_ideal = T_MIAS_ideal.*sqrt(1-l_MIAS.^2); %修正倾斜因子obliquity factor
figure;
plot(l_MIAS,T_MIAS_ideal,'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on; xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)'); title('MIAS with ideal CV');

%MIAS求解可见度及成像
cv_sol = pinv(A) * R; %求解cosine visibility， minimum norm least squre error
cv_all_sol = PadSample(unrpt_sample,cv_sol,'cubic'); %对缺失的基线插值,获得所有基线的cosine visibility
cv_all_sol = [CV_ideal(1); cv_all_sol]; %补充零基线
T_MIAS_sol = idct_cv(cv_all_sol)*omega_ap*delta_u*(2*length(cv_all_sol)-1);
T_MIAS_sol = T_MIAS_sol.*sqrt(1-l_MIAS.^2); %修正倾斜因子obliquity factor
figure;
plot(l_MIAS,T_MIAS_sol,'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on; xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)'); title('MIAS with solved CV');

% [U,s,V] = csvd(A);
% [cv_sol2,rho,eta] = tikhonov(U,s,V,R,0.000000001);
% cv_all_sol2 = PadSample(unrpt_sample,cv_sol2,'cubic'); %对缺失的基线插值,获得所有基线的cosine visibility
% cv_all_sol2 = [CV_ideal(1); cv_all_sol2]; %补充零基线
% T_MIAS_sol2 = idct_cv(cv_all_sol2)*omega_ap*delta_u*(2*length(cv_all_sol2)-1);
% T_MIAS_sol2 = T_MIAS_sol2.*sqrt(1-l_MIAS.^2); %修正倾斜因子obliquity factor
% figure;
% plot(l_MIAS,T_MIAS_sol2,'linewidth',5);
% set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
% axis([0 0.5 -50 250]); 
% grid on; xlabel('sin\theta'); ylabel('brightenss temperature (K)'); title('MIAS with solved CV_ tikhonov');



%构建成像矩阵,即将余弦变换表述成矩阵乘积形式
B = zeros(length(cv_all_sol),length(cv_all_sol));
B(:,1)=delta_u;
sampling_num = 2*length(cv_all_sol)-1;
for k = 1:length(cv_all_sol)
    for n = 2:length(cv_all_sol)
            B(k,n) = delta_u*2*cos(2*pi*(n-1)*(k-1)/sampling_num);
    end
end
B = B*omega_ap;
% T_MIAS_sol = B*cv_all_sol; %直接矩阵相乘获得亮温
% T_MIAS_sol=T_MIAS_sol.*sqrt(1-l_MIAS.^2); %修正倾斜因子obliquity factor
% figure;
% plot(l_MIAS,T_MIAS_sol,'linewidth',5);
% % set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
% % axis([0 0.5 -50 250]); 
% grid on; xlabel('sin\theta'); ylabel('brightenss temperature (K)'); title('MIAS with solved CV And Matrix');

%校正求解的可见度然后成像
% diff_cv = cv_all_sol-CV_ideal;
% cv_all_cal = cv_all_sol-diff_cv;
% T_MIAS_cal = idct_cv(cv_all_cal)*omega_ap*delta_u*(2*length(cv_all_cal)-1);
% T_MIAS_cal = T_MIAS_cal.*sqrt(1-l_MIAS.^2); %修正倾斜因子obliquity factor
% figure;
% plot(l_MIAS,T_MIAS_cal,'linewidth',5);
%  set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
%  axis([0 0.5 -50 250]); 
%  grid on;xlabel('sin\theta');ylabel('brightenss temperature (K)');%title('MIAS with calibrated CV');
%*************************************************************************

