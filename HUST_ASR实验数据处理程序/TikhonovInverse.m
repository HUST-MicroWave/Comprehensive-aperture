function [y,GMat,GrMat] = TikhonovInverse(Vcomplex, Gcomplex, regularization_para,zerobaseline_flag,ideal_gmatrix_flag)
% ���пƼ���ѧ
azimuth_num = size(Gcomplex, 2);
elevation_num = size(Vcomplex, 2);
baseline_num = size(Gcomplex, 1);

if zerobaseline_flag==1
% ���ɼ��ȵ�ʵ�����鲿�ֿ������һ��ʵ���󣬰��������
VMat = zeros(2*baseline_num-1, elevation_num);
GMat = zeros(2*baseline_num-1, azimuth_num);

for k=1:baseline_num-1
    VMat(2*k,:) = imag( Vcomplex(k+1,:) );
    VMat(2*k+1,:) = real( Vcomplex(k+1,:) );
    GMat(2*k,:) = imag( Gcomplex(k+1,:) );  %ż���ж�Ӧ�鲿
    GMat(2*k+1,:) = real( Gcomplex(k+1,:) );%�����ж�Ӧʵ��
end
VMat(1,:) = real( Vcomplex(1,:) );
GMat(1,:) = real( Gcomplex(1,:) );
else
% ���ɼ��ȵ�ʵ�����鲿�ֿ������һ��ʵ����,�����������
VMat = zeros(2*baseline_num-2, elevation_num);
GMat = zeros(2*baseline_num-2, azimuth_num);

for k=1:baseline_num-1
    VMat(2*k,:) = imag( Vcomplex(k+1,:) );
    VMat(2*k-1,:) = real( Vcomplex(k+1,:) );
    GMat(2*k,:) = imag( Gcomplex(k+1,:) );  %ż���ж�Ӧ�鲿
    GMat(2*k-1,:) = real( Gcomplex(k+1,:) );%�����ж�Ӧʵ��
end
end

if ideal_gmatrix_flag == 1
%----------��������G���󣭣���������������������������
deltaU=1;
azimuth_start = -30;            % ��
azimuth_end = 30;               % ��
ang = linspace(azimuth_start,azimuth_end,azimuth_num);


for n=1:1:baseline_num-1
    for b=1:1:azimuth_num
        GMat(2*n,b)=sin(2*n*deltaU*pi*sind(ang(b)));
        GMat(2*n+1,b)=cos(2*n*deltaU*pi*sind(ang(b)));   
    end
end
for b=1:1:azimuth_num
GMat(1,b)=1;
end
%--------------------------------------------------
end

GMat=GMat/size(GMat,1)/size(GMat,2);
param=size(VMat,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% tikhonov 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=regularization_para;
[U,s,V] = csvd(GMat);
% ����L��curve���ҳ��յ�
% Vline=VMat(:,30);
% params = 0:0.01:1;
% [X,rho,eta] = tikhonov(U,s,V,Vline,params);
% figure;b = params(corner(rho,eta,gcf));
% xlabel('||V-GT_{r}||_{F}');ylabel('||T_{r}||_{E}');
% title(sprintf('��ɢL����, �յ�λ�� %d', b));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% params = 1:length(VMat);
% [X,rho,eta] = tikhonov(U,s,V,VMat,params);
% figure;k = params(corner(rho,eta,gcf));
% xlabel('||V-GT_{r}||_{F}');ylabel('||T_{r}||_{E}');
% title(sprintf('��ɢL����, �յ�λ�� %d', k));
% AREMF = sum(s(1:param).^2)*sum(s(1:param).^-2)/param
% conditon_num = s(1)/s(param)

GrMat = V(:,1:param)*diag(s(1:param)./(s(1:param).^2+k.^2))*U(:,1:param)';
% for k=1:param
% GrMat(:,k)=GrMat(:,k)/max(GrMat(:,k));
% end
% %%%%%%%%�ۺϿ׾�����ͼAPN��һ��
A = GrMat*GMat;
figure;plot(A(301,:));
% AMat=GrMat*(GrMat');
for k=1:azimuth_num
    GrMat(k,:) = GrMat(k,:) / sum(A(k,:));
end
A = GrMat*GMat;
figure;plot(A(301,:));
APN=sum(A(301,:))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % %%%%%%%%����spread
% A_norm=A;
% for k=1:azimuth_num
%     A_norm(k,:) = A(k,:) / max(A(k,:));
% end
% spread = 0;
% for k=1:azimuth_num
%     spread = spread+(A_norm(301,k))^2 *((k-301)*0.1)^2;
% end
% spread=spread
% figure;plot(A_norm(301,:));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GrMat=inv(GMat'*GMat+k*eye(azimuth_num))*(GMat');
TA = GrMat*VMat;

y = TA.';
