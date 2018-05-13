function y = DsvdInverse(Vcomplex, Gcomplex, regularization_para,zerobaseline_flag,ideal_gmatrix_flag)
% 华中科技大学
azimuth_num = size(Gcomplex, 2);
elevation_num = size(Vcomplex, 2);
baseline_num = size(Gcomplex, 1);

if zerobaseline_flag==1
% 将可见度的实部和虚部分开，组成一个实矩阵，包含零基线
VMat = zeros(2*baseline_num-1, elevation_num);
GMat = zeros(2*baseline_num-1, azimuth_num);

for k=1:baseline_num-1
    VMat(2*k,:) = imag( Vcomplex(k+1,:) );
    VMat(2*k+1,:) = real( Vcomplex(k+1,:) );
    GMat(2*k,:) = imag( Gcomplex(k+1,:) );  %偶数行对应虚部
    GMat(2*k+1,:) = real( Gcomplex(k+1,:) );%奇数行对应实部
end
VMat(1,:) = real( Vcomplex(1,:) );
GMat(1,:) = real( Gcomplex(1,:) );
else
% 将可见度的实部和虚部分开，组成一个实矩阵,不包含零基线
VMat = zeros(2*baseline_num-2, elevation_num);
GMat = zeros(2*baseline_num-2, azimuth_num);

for k=1:baseline_num-1
    VMat(2*k,:) = imag( Vcomplex(k+1,:) );
    VMat(2*k-1,:) = real( Vcomplex(k+1,:) );
    GMat(2*k,:) = imag( Gcomplex(k+1,:) );  %偶数行对应虚部
    GMat(2*k-1,:) = real( Gcomplex(k+1,:) );%奇数行对应实部
end
end

if ideal_gmatrix_flag == 1
%----------构造理想G矩阵－－－－－－－－－－－－－－－
deltaU=1;
azimuth_start = -30;            % 度
azimuth_end = 30;               % 度
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


param=size(VMat,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% dsvd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [U,s,V] = csvd(GMat);
        k=regularization_para;
% 		[X,rho,eta] = dsvd(U,s,V,VMat,1:length(VMat)-1);
% 		figure;k = corner(rho,eta,gcf);
% 		GrMat = V*inv(diag(s+param))*U';
		
        GrMat = V(:,1:param)*inv(diag(s(1:param)+k))*U(:,1:param)';        




TA = GrMat*VMat;

y = TA.';
