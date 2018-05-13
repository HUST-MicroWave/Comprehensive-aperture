function adjustvar = JROneSourceCalibration(R,norm_min_spacing,norm_ant_pos,calibration_source_place)
% 华中科技大学
ant_pos = norm_min_spacing*norm_ant_pos;
ant_num = length(ant_pos);
A_theta = exp(2*pi*j*ant_pos*sind(calibration_source_place))';
R_source = A_theta*A_theta';
R = R.*R_source.';

%求幅度误差
diag_R = diag(R);
error_amp = (diag_R/diag_R(1)).^(0.5);
error_amp = error_amp(2:ant_num);

%求相位误差
angle_R = NomMatrix(angle(R));
vec_R = UpTriangle(angle_R);
%构造最小二乘矩阵
col_num = ant_num-1;
row_num = col_num*(col_num-1)/2;
M = zeros(row_num,col_num);
k = 0;
for q = 0:ant_num-2
    for p = 0:q
        k = k + 1;
        M(k,q+1) = 1;
        if(((p==0)||(q==0))==0)
            M(k,p) = -1;
        end
    end
end
%构造最小二乘矩阵结束
error_phase = -pinv(M)*vec_R;
% error_phase=angle_R(1,2:16).';
adjustvar = [1;error_amp.*exp(j*error_phase)];

% adjustvar = [1;exp(j*error_phase)];
            
    
