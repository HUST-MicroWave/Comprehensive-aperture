function y = OneStepInverse(Vcomplex, Gcomplex, iter_step)
%%%%% 一步迭代法反演
% 华中科技大学

azimuth_num = size(Gcomplex, 2);
elevation_num = size(Vcomplex, 2);
baseline_num = size(Gcomplex, 1);

% 将可见度的实部和虚部分开，组成一个实矩阵
V = zeros(2*baseline_num-1, elevation_num);
G = zeros(2*baseline_num-1, azimuth_num);

for k=1:baseline_num-1
    V(2*k,:) = imag( Vcomplex(k+1,:) );
    V(2*k+1,:) = real( Vcomplex(k+1,:) );
    G(2*k,:) = imag( Gcomplex(k+1,:) );  %偶数行对应虚部
    G(2*k+1,:) = real( Gcomplex(k+1,:) );%奇数行对应实部
end
% V(1,:) = real( Vcomplex(1,:) );
% G(1,:) = real( Gcomplex(1,:) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%One_step Gradient Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TA = zeros(azimuth_num, elevation_num);
for k=1:elevation_num
    for loop_n=1:iter_step
        g=-G'* (V(:,k)-G*TA(:,k));
        t =g'*g/(g'*G'*G*g);
        TA(:,k)=TA(:,k)-t*g;
    end
end

y = TA.';
