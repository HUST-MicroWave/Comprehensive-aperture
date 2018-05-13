clear all;clc;tic;close all;tic;
%*************************************************************************
% ���пƼ���ѧ
%�������м���λ��
height = [25 25.5 26 26.5 50 50.5 51 51.5]; % ������һ��ֵ�����������뷴����ľ���
% height = 1;
ant_num = 12;  % ������Ŀ
ant_spacing = [0 1 2 3 7 7 7 7 7 4 4 1]; %���߼��
delta_u = 1; % ��С���
index = 1;
for k = 1:length(height)
    ant_pos = GetAntPos(height(k), ant_spacing, delta_u); %��ȡ�����ߵ�������ľ���
    pair_sample = GetPairSample(ant_pos); %����Ƶ�ʣ���ȡÿһ��������صõ��Ĳ���Ƶ��
    cell_pair_sample(index,1) = {pair_sample};
    index = index + 1;
end
pair_sample_all = cell2mat(cell_pair_sample); %�ۺ�����heightֵ���Ļ�ȡ��pair_sample
unrpt_sample = GetUnrptSample(pair_sample_all); %pair_sample_all�еķ��ظ�����Ƶ��
absent_sample = IsMissingSample(unrpt_sample); % ȱʧ�Ĳ���Ƶ��
all_sample = [unrpt_sample; absent_sample]; %���в���Ƶ��
all_sample = sort(all_sample);%���в���Ƶ��
A = GetA(unrpt_sample, pair_sample_all);
%*************************************************************************

%*************************************************************************
%ϵͳ����
band = 1e7; % ����Hz
tao = 1; % ����ʱ�䣬s
T_rec = 300; % ͨ��������K


%%�ռ����·ֲ�����ɢ����Ϣ
% N_l=500;
N_l = 3*round(max(all_sample)/delta_u); %�ռ���ɢ����,Ϊ����G������������㹻��ɢ�ȣ�P>3M,�ο�ESTAR,�����ο�
% d_theta = 0.00000000001;
% l_max = sqrt(1-sin(d_theta/2)); %l���ֵ��l=1ʱ�����
l_max = 1/2/delta_u;
d_l = l_max/N_l; %l���ֵ
l =  0:d_l:l_max-d_l/2; %lֵ
l=l';

% load paper_Tb.mat
% Tb = zeros(1,N_l); %�ռ����·ֲ�
% Tb(1,122:486)= 200;% Tb(1,243:365)= 200;
Tb = zeros(N_l,1); % �ռ����·ֲ�ȫ������Ϊ0
Tb(100:550,1)= 100; 
Tb(250:400,1)= 200; 
% Tb(100:280,1)= 100; % �Ե��������λ�ã��±겻�ܳ���N_l
% Tb(150:200,1)= 200; % �Ե��������λ�ã��±겻�ܳ���N_l
Tb(50,1) = 200; % һ����Դ
Tb(60,1) = 200; % ��һ����Դ

%�����߷���ͼ
Fn = ones(N_l,1);
omega_ap = pi/3; %�����������

figure;
plot(l, Tb, 'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on;xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)');
%*************************************************************************

%*************************************************************************
%ͬ�������µ�ASR��������MIAS���бȽ�
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
l_ASR = linspace(-1/2/delta_u,1/2/delta_u,2*P+1)';%�ӳ������ص�
T_ASR = T_ASR.*sqrt(1-l_ASR.^2);%������б����obliquity factor
figure;
plot(l_ASR(P+1:2*P+1), T_ASR(P+1:2*P+1), 'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on;xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)');title('ASR');
%*************************************************************************

%*************************************************************************
%������Ƶ�ʴ���CV(cosine visibility)ֵ
P_MIAS = max(all_sample); %cv��Ӧ��Pֵ
CV_ideal = zeros(P_MIAS+1,1);
for p =1:P_MIAS+1
    CV_ideal(p) = 2/omega_ap*real(sum(Tb.*exp(-j*2*pi*(p-1)*delta_u*l)./sqrt(1-l.^2))*d_l);
end

%����Heightֵ��ÿ��������������ֵ
R = zeros(size(pair_sample_all,1),1);
for k = 1:length(R)
    R(k) = CV_ideal(pair_sample_all(k,1)+1) - CV_ideal(pair_sample_all(k,2)+1);
end
%*************************************************************************

%*************************************************************************
%MIAS ����coisne visibility ����
l_MIAS = linspace(0,1/2/delta_u,P_MIAS+1);%�ӳ������ص�
l_MIAS = l_MIAS';
T_MIAS_ideal = idct_cv(CV_ideal)*omega_ap*delta_u*(2*length(CV_ideal)-1);
T_MIAS_ideal = T_MIAS_ideal.*sqrt(1-l_MIAS.^2); %������б����obliquity factor
figure;
plot(l_MIAS,T_MIAS_ideal,'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on; xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)'); title('MIAS with ideal CV');

%MIAS���ɼ��ȼ�����
cv_sol = pinv(A) * R; %���cosine visibility�� minimum norm least squre error
cv_all_sol = PadSample(unrpt_sample,cv_sol,'cubic'); %��ȱʧ�Ļ��߲�ֵ,������л��ߵ�cosine visibility
cv_all_sol = [CV_ideal(1); cv_all_sol]; %���������
T_MIAS_sol = idct_cv(cv_all_sol)*omega_ap*delta_u*(2*length(cv_all_sol)-1);
T_MIAS_sol = T_MIAS_sol.*sqrt(1-l_MIAS.^2); %������б����obliquity factor
figure;
plot(l_MIAS,T_MIAS_sol,'linewidth',3);
set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
axis([0 0.5 -50 250]); 
grid on; xlabel('\eta=sin\phi'); ylabel('brightenss temperature (K)'); title('MIAS with solved CV');

% [U,s,V] = csvd(A);
% [cv_sol2,rho,eta] = tikhonov(U,s,V,R,0.000000001);
% cv_all_sol2 = PadSample(unrpt_sample,cv_sol2,'cubic'); %��ȱʧ�Ļ��߲�ֵ,������л��ߵ�cosine visibility
% cv_all_sol2 = [CV_ideal(1); cv_all_sol2]; %���������
% T_MIAS_sol2 = idct_cv(cv_all_sol2)*omega_ap*delta_u*(2*length(cv_all_sol2)-1);
% T_MIAS_sol2 = T_MIAS_sol2.*sqrt(1-l_MIAS.^2); %������б����obliquity factor
% figure;
% plot(l_MIAS,T_MIAS_sol2,'linewidth',5);
% set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
% axis([0 0.5 -50 250]); 
% grid on; xlabel('sin\theta'); ylabel('brightenss temperature (K)'); title('MIAS with solved CV_ tikhonov');



%�����������,�������ұ任�����ɾ���˻���ʽ
B = zeros(length(cv_all_sol),length(cv_all_sol));
B(:,1)=delta_u;
sampling_num = 2*length(cv_all_sol)-1;
for k = 1:length(cv_all_sol)
    for n = 2:length(cv_all_sol)
            B(k,n) = delta_u*2*cos(2*pi*(n-1)*(k-1)/sampling_num);
    end
end
B = B*omega_ap;
% T_MIAS_sol = B*cv_all_sol; %ֱ�Ӿ�����˻������
% T_MIAS_sol=T_MIAS_sol.*sqrt(1-l_MIAS.^2); %������б����obliquity factor
% figure;
% plot(l_MIAS,T_MIAS_sol,'linewidth',5);
% % set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
% % axis([0 0.5 -50 250]); 
% grid on; xlabel('sin\theta'); ylabel('brightenss temperature (K)'); title('MIAS with solved CV And Matrix');

%У�����Ŀɼ���Ȼ�����
% diff_cv = cv_all_sol-CV_ideal;
% cv_all_cal = cv_all_sol-diff_cv;
% T_MIAS_cal = idct_cv(cv_all_cal)*omega_ap*delta_u*(2*length(cv_all_cal)-1);
% T_MIAS_cal = T_MIAS_cal.*sqrt(1-l_MIAS.^2); %������б����obliquity factor
% figure;
% plot(l_MIAS,T_MIAS_cal,'linewidth',5);
%  set(gca,'fontsize',24);set(gcf,'position',[0 0 400 300]);
%  axis([0 0.5 -50 250]); 
%  grid on;xlabel('sin\theta');ylabel('brightenss temperature (K)');%title('MIAS with calibrated CV');
%*************************************************************************

