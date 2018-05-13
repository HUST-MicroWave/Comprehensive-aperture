function y = VanCitterInverse(Vcomplex, Gcomplex, iter_step)
% ���пƼ���ѧ
azimuth_num = size(Gcomplex, 2);
elevation_num = size(Vcomplex, 2);
baseline_num = size(Gcomplex, 1);

% ���ɼ��ȵ�ʵ�����鲿�ֿ������һ��ʵ����
V = zeros(2*baseline_num-1, elevation_num);
G = zeros(2*baseline_num-1, azimuth_num);

for k=1:baseline_num-1
    V(2*k,:) = imag( Vcomplex(k+1,:) );
    V(2*k+1,:) = real( Vcomplex(k+1,:) );
    G(2*k,:) = imag( Gcomplex(k+1,:) );  %ż���ж�Ӧ�鲿
    G(2*k+1,:) = real( Gcomplex(k+1,:) );%�����ж�Ӧʵ��
end
V(1,:) = real( Vcomplex(1,:) );
G(1,:) = real( Gcomplex(1,:) );

% ���ɼ��ȵ�ʵ�����鲿�ֿ������һ��ʵ����
% V = zeros(2*baseline_num, elevation_num);
% G = zeros(2*baseline_num, azimuth_num);
% 
% for k=1:baseline_num
%     V(2*k-1,:) = imag( Vcomplex(k,:) );
%     V(2*k,:) = real( Vcomplex(k,:) );
%     G(2*k-1,:) = imag( Gcomplex(k,:) );  %ż���ж�Ӧ�鲿
%     G(2*k,:) = real( Gcomplex(k,:) );%�����ж�Ӧʵ��
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% The Van Citter Filter 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[G_Row,G_Col] = size(G);
I = eye(G_Col);
S = svd(G'*G);
S_Max = max(S);
S_Min = min(S(1:2*baseline_num-1));
C_Opt = 2/(S_Max + S_Min);
E = zeros(G_Col,G_Row);
for k=0:1:iter_step
    E = E + C_Opt*(( I-C_Opt*G'*G )^k)*G';
end
E = C_Opt*E;
TA = E*V;

y = TA.';
