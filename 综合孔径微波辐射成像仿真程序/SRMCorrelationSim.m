function re_self_correlation_matrix = SRMCorrelationSim(self_correlation_matrix,sampling_num,error_Qphase)

% 根据自相关矩阵的均值与采样点数模拟生成仿真自相关矩阵
% 该函数生成的自相关矩阵的均值不变，方差通过高斯随机数添加
% 华中科技大学

%天线个数
antenna_num = length(self_correlation_matrix(1,:));
% 计算自相关矩阵的方差:
for p = 1:antenna_num
    for q = 1:antenna_num
        correlation_matrix_var(p,q) = self_correlation_matrix(p,p)*self_correlation_matrix(q,q)/sampling_num;
    end
end

% 产生标准随机误差矩阵：
% 随机矩阵初始化
error_matrix = zeros(antenna_num,antenna_num);
% 随机矩阵生成
for p = 2:antenna_num
    for q = 1:p-1
        error_matrix(p,q) = (randn(1,1)+j*randn(1,1))/sqrt(2);
    end
end
% 保证随机矩阵的hermite特性
error_matrix = error_matrix+error_matrix';
% 保证随机矩阵的对角线为实数
for k = 1:antenna_num  
    error_matrix(k,k) = randn(1,1); %对角线上为实随机过程
end

% 产生随机误差矩阵：
error_matrix = error_matrix.*sqrt(correlation_matrix_var);
self_correlation_matrix = self_correlation_matrix + error_matrix;

%%%% 最后添加正交误差：
error_Qphase_matrix = error_Qphase;
% 获取可见度相位
angle_matrix = angle(self_correlation_matrix);
% 获取可见度幅度
amp_matrix = abs(self_correlation_matrix);
% 添加正交误差，可见度实部不变，改变可见度虚部从而改变移相角度
re_self_correlation_matrix = amp_matrix.*cos(angle_matrix) + j*amp_matrix.*sin(angle_matrix-error_Qphase_matrix);

