function T = IAMSimulate(self_correlation_matrix,SRM_param,IAM_param)

% 根据自相关矩阵，获得反演亮温
% 华中科技大学

% 赋值
norm_ant_pos = SRM_param.norm_ant_pos;
inverse_name = IAM_param.inverse_name;
min_spacing = SRM_param.norm_min_spacing;

% 该函数获取反演后的未定标亮温
switch inverse_name
    case 'ppolar'    
        % 可见度函数通过对自相关函数冗余平均获得
        [visibility,uvpoint,uvarea] =  R2VCircle(self_correlation_matrix,min_spacing*norm_ant_pos);
        % 将可见度的点转化到伪极网格上
        Circle2Ppolar(visibility,uvpoint,min_spacing*norm_ant_pos,IAM_param.Ppolar_rou,IAM_param.Ppolar_theta);
        % 获得视场范围
        Fov = FovCircleArray(min_spacing,norm_ant_pos);    
        % 二维傅里叶反演
        T = DFTextend(visibility,uvpoint,uvarea,Fov); 
    case 'fft1D'
        % 可见度函数通过对自相关函数冗余平均获得
        visibility = R2V1D(self_correlation_matrix,norm_ant_pos);
        % 一维傅里叶反演
        T = FFT1D(visibility);
    case 'fft2D'
        % 可见度函数通过对自相关函数冗余平均获得
        visibility = R2V2D(self_correlation_matrix,norm_ant_pos);
        % 二维傅里叶反演
        T = FFT2D(visibility);
    case 'hfft'
        % 边的长度
        max_arm = length(norm_ant_pos(1,:))/3;
        % 可见度函数通过对自相关函数冗余平均获得,并且获得Y形阵的视场范围
        [visibility,extent_UV,Fov] = R2VY(self_correlation_matrix,norm_ant_pos,min_spacing,max_arm);
        % 公式计算六边形傅里叶反演
        T = HFFT(visibility,norm_ant_pos,Fov,extent_UV);
    case 'dftcircle'
        % 可见度函数通过对自相关函数冗余平均获得
        [visibility,uvpoint,uvarea] =  R2VCircle(self_correlation_matrix,min_spacing*norm_ant_pos);
        % 获得视场范围
        Fov = FovCircleArray(min_spacing,norm_ant_pos);    
        % 二维傅里叶反演
        T = DFTextend(visibility,uvpoint,uvarea,Fov);   
  
    
end