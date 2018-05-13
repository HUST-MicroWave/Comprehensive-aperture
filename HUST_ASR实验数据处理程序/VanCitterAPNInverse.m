function y = VanCitterAPNInverse(Vcomplex, Gcomplex, iter_step)
% 华中科技大学
azimuth_num = size(Gcomplex, 2);
elevation_num = size(Vcomplex, 2);
baseline_num = size(Gcomplex, 1);

% 将可见度的实部和虚部分开，组成一个实矩阵
V = zeros(2*baseline_num, elevation_num);
G = zeros(2*baseline_num, azimuth_num);

for k=1:baseline_num
    V(2*k-1,:) = imag( Vcomplex(k,:) );
    V(2*k,:) = real( Vcomplex(k,:) );
    G(2*k-1,:) = imag( Gcomplex(k,:) );  %偶数行对应虚部
    G(2*k,:) = real( Gcomplex(k,:) );%奇数行对应实部
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% The Van Citter Filter 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[G_Row,G_Col] = size(G);
I = eye(G_Col);
S = svd(G'*G);
S_Max = max(S);
S_Min = min(S);
C_Opt = 2/(S_Max + S_Min);
E = zeros(G_Col,G_Row);
for k=0:1:iter_step
    E = E + C_Opt*(( I-C_Opt*G'*G )^k)*G';
end

% 综合孔径方向图归一化
A = E*G;
for k=1:azimuth_num
    E(k,:) = E(k,:) / sum(A(k,:));
end

TA = E*V;

y = TA.';
