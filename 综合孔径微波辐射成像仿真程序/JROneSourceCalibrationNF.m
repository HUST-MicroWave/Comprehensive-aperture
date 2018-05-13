
function adjustvar = JROneSourceCalibrationNF(R,ant_pos,calibration_source_place)

% 单辅助源幅度相位误差校正算法
% 华中科技大学
ant_num = length(ant_pos);
if length(calibration_source_place)==1
    % 一维阵列(未完成)
    
end

if length(calibration_source_place)==2
    % 平面阵列   
    theta = calibration_source_place(1);
    phy = calibration_source_place(2);
    % 引导向量
    A_theta = exp(2*pi*j*sind(theta)*(ant_pos(1,:)*cosd(phy)+ant_pos(2,:)*sind(phy))).';  
end

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
adjustvar = [1;error_amp.*exp(j*error_phase)];