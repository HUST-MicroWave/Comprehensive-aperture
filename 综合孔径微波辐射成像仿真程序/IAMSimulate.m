function T = IAMSimulate(self_correlation_matrix,SRM_param,IAM_param)

% ��������ؾ��󣬻�÷�������
% ���пƼ���ѧ

% ��ֵ
norm_ant_pos = SRM_param.norm_ant_pos;
inverse_name = IAM_param.inverse_name;
min_spacing = SRM_param.norm_min_spacing;

% �ú�����ȡ���ݺ��δ��������
switch inverse_name
    case 'ppolar'    
        % �ɼ��Ⱥ���ͨ��������غ�������ƽ�����
        [visibility,uvpoint,uvarea] =  R2VCircle(self_correlation_matrix,min_spacing*norm_ant_pos);
        % ���ɼ��ȵĵ�ת����α��������
        Circle2Ppolar(visibility,uvpoint,min_spacing*norm_ant_pos,IAM_param.Ppolar_rou,IAM_param.Ppolar_theta);
        % ����ӳ���Χ
        Fov = FovCircleArray(min_spacing,norm_ant_pos);    
        % ��ά����Ҷ����
        T = DFTextend(visibility,uvpoint,uvarea,Fov); 
    case 'fft1D'
        % �ɼ��Ⱥ���ͨ��������غ�������ƽ�����
        visibility = R2V1D(self_correlation_matrix,norm_ant_pos);
        % һά����Ҷ����
        T = FFT1D(visibility);
    case 'fft2D'
        % �ɼ��Ⱥ���ͨ��������غ�������ƽ�����
        visibility = R2V2D(self_correlation_matrix,norm_ant_pos);
        % ��ά����Ҷ����
        T = FFT2D(visibility);
    case 'hfft'
        % �ߵĳ���
        max_arm = length(norm_ant_pos(1,:))/3;
        % �ɼ��Ⱥ���ͨ��������غ�������ƽ�����,���һ��Y������ӳ���Χ
        [visibility,extent_UV,Fov] = R2VY(self_correlation_matrix,norm_ant_pos,min_spacing,max_arm);
        % ��ʽ���������θ���Ҷ����
        T = HFFT(visibility,norm_ant_pos,Fov,extent_UV);
    case 'dftcircle'
        % �ɼ��Ⱥ���ͨ��������غ�������ƽ�����
        [visibility,uvpoint,uvarea] =  R2VCircle(self_correlation_matrix,min_spacing*norm_ant_pos);
        % ����ӳ���Χ
        Fov = FovCircleArray(min_spacing,norm_ant_pos);    
        % ��ά����Ҷ����
        T = DFTextend(visibility,uvpoint,uvarea,Fov);   
  
    
end