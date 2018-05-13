
function adjustvar = JROneSourceCalibrationNF(R,ant_pos,calibration_source_place)

% ������Դ������λ���У���㷨
% ���пƼ���ѧ
ant_num = length(ant_pos);
if length(calibration_source_place)==1
    % һά����(δ���)
    
end

if length(calibration_source_place)==2
    % ƽ������   
    theta = calibration_source_place(1);
    phy = calibration_source_place(2);
    % ��������
    A_theta = exp(2*pi*j*sind(theta)*(ant_pos(1,:)*cosd(phy)+ant_pos(2,:)*sind(phy))).';  
end

R_source = A_theta*A_theta';
R = R.*R_source.';

%��������
diag_R = diag(R);
error_amp = (diag_R/diag_R(1)).^(0.5);
error_amp = error_amp(2:ant_num);

%����λ���
angle_R = NomMatrix(angle(R));
vec_R = UpTriangle(angle_R);
%������С���˾���
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
%������С���˾������
error_phase = -pinv(M)*vec_R;
adjustvar = [1;error_amp.*exp(j*error_phase)];