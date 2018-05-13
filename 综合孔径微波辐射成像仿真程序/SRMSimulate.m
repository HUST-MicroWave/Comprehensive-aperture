function self_correlation_matrix = SRMSimulate(T_dist,sys_param,SRM_param,save_error)

%   �﷨��
%   self_correlation_matrix = SRMSimulate(T_dist,sys_param, SRM_param);
% 
%   �������ܣ�
%   �˺���Ϊ����ģ��������������Ϊ��
%   ��ȡ����ģ���ṩ�����߿����������·ֲ���Ϣ������������ߵĵ�Ч�����������źš�
%  
%   �������:
% T_dist     �����߿����������·ֲ����󣬷�2�����
%     ������������Ϊ2      ��һάֱ������
%     ������������Ϊ3      ��ƽ�����У�������Դ
%
% �ṹ��SRM_param��
%     norm_min_spacing     ����С�������м������λΪ����
%     norm_ant_pos     ������������ʽ����2�����
%         ������������Ϊ1      ��һάֱ������
%         ������������Ϊ2      ��ƽ������
% ant_pos_info   ������������Ϣ
%     ant_pos_info.ant_pos_error_quantity  �������������Ĵ�С�����������˲�������ʾû�и����
% antenna_pattern_info    :����ͼ��Ϣ
%     antenna_pattern_info.antenna_type   ��������״�������¼��������ѡ
%         'isotropic'  ���룬���������Ϊ1
%         'rectangle'   ���ο���
%         'circle'     Բ�ο���
%     antenna_pattern_info.wavelength     �����߹�������
%     antenna_pattern_info.antenna_size   �����߳ߴ磬�����¼���������������Ӧ
%         ������д
%         2��Ԫ�ص���������һ��Ԫ��Ϊ�����ڶ���Ԫ��Ϊ��
%         1��Ԫ�أ�Ϊ���߰뾶
%     antenna_pattern_info.pattern_error_quantity    �����߷���ͼ���Ĵ�С�����������˲�������ʾû�и����
% mutual_info            ��������Ϣ
%     mutual_info.mutual_error_quantity    ������Ĵ�С
% sys_param            ��ϵͳ��Ϣ
%     sys_param.band        ������
%     sys_param.integral_time   ������ʱ��
%     sys_param.array_type      ����������
%         MLRA       ��һά��С������
%         Y_SHAPE    ��Y��ƽ����
%         T_SHAPE    : T��ƽ����
% save_error           :�Ƿ񱣴汾�����
%       0  �����棨Ĭ�ϣ�
%       1  ����
%       2  ɾ��֮ǰ�����
%   ���������
%   self_correlation_matrix       :������������ź�
% 
%   ����:
% SRM_param.norm_min_spacing = 1/2;
% SRM_param.norm_ant_pos = [0 2 5 6]; 
% SRM_param.mutual_info.mutual_error_quantity = 0.01;
% SRM_param.antenna_pattern_info.antenna_type = 'circle';
% SRM_param.antenna_pattern_info.wavelength = 0.008;
% SRM_param.antenna_pattern_info.antenna_size = 0.008;
% sys_param.band = 100*10^6;
% sys_param.integral_time = 10^(-5);
% sys_param.array_type = 'MLRA'; 
% source_place = [-20 0 20 30]; %��������
% source_power = [1 1 1.5 2];  %Դ�Ĺ���
% T_dist = [source_power;source_place];
% self_correlation_matrix = SRMSimulate(T_dist,sys_param, SRM_param);
%
%   ���пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $


if nargin<=3
    save_error = 0;
end


%%%%%%%%%%%%%%%%%������ȡ%%%%%%%%%%%%%%%%%%%%
norm_min_spacing = SRM_param.norm_min_spacing;           %����������С���
norm_ant_pos = SRM_param.norm_ant_pos;                   %����λ��
antenna_pattern_info = SRM_param.antenna_pattern_info;   %���߷���ͼ��
T_rec = SRM_param.channel_info.T_rec;                    %ͨ���¶�
channel_info = SRM_param.channel_info;                   %ͨ����Ϣ��
%�����������ڴ���˻���ʱ��
sampling_num = floor(sys_param.band*sys_param.integral_time); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%ϵͳ�����%%%%%%%%%%%%%%%%%%%%
% ����ƽ�����л���һά���У�һά����1��ƽ������0
if(size(norm_ant_pos,1)==1)       %�������λ������������Ȼ��һά����ֻ����x�Ϳɱ�ʾ����λ��
    array_type = 1;
elseif(size(norm_ant_pos,1)==2)   %�������λ��������Ϊ2�ľ�����Ȼ��ƽ������Ϊ��Ҫ��x,y��������ʾ����λ��
    array_type = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%�������λ�����%%%%%
ant_pos_error_type = SRM_param.ant_pos_info.ant_pos_error_type;          %����λ��������ʹӽṹ���л�ȡ
ant_pos_error_quantity = SRM_param.ant_pos_info.ant_pos_error_quantity;  %����λ������С�ӽṹ���л�ȡ
antenna_num = sys_param.ant_num ;                                        %���߸����ӽṹ���л�ȡ
% �������ڵ��������ʵ����������(��������λ������������)��
norm_ant_pos = SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity,ant_pos_error_type);

%%%%�������߷���ͼ%%%%%%%
c = 3*10^8;                                                 %����
antenna_pattern_info.wavelength = c/sys_param.center_freq;  %��ȡ���߹�������
% ���߷���ͼ����(�������߷���ͼ��������)��
switch size(T_dist,1)
    case 2      %������������Ϊ2����һ��Ϊ�Ƕ�λ����Ϣ���ڶ���Ϊ��������һάֱ������ 
        coef_matrix = SRMPatternGenerate(antenna_pattern_info,T_dist(2,:),array_type);
    case 3      %������������Ϊ3����һ������Ϊ�Ƕ�λ����Ϣ��������Ϊ�������Ƕ�άƽ������
        coef_matrix = SRMPatternGenerate(antenna_pattern_info,T_dist([2:3],:),array_type);
end

%%%%�������߷���ͼ���%%%%%%%
pattern_error_quantity = SRM_param.antenna_pattern_info.pattern_error_quantity;   %���߷���ͼ����С�ӽṹ���л�ȡ
pattern_error_type = SRM_param.antenna_pattern_info.pattern_error_type;           %���߷���ͼ������ʹӽṹ���л�ȡ
% ���߷���ͼ�������(�������߷���ͼ����������):
real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);

%%%%�����������%%%%%%%%%
mutual_error_quantity = SRM_param.mutual_info.mutual_error_quantity;   %��������С�ӽṹ���л�ȡ
mutual_error_type = SRM_param.mutual_info.mutual_error_type;           %����������ʹӽṹ���л�ȡ
% ��ź����(���û�������������)��
mutual = SRMMutualErrorGenerate(norm_min_spacing,norm_ant_pos,mutual_error_quantity,mutual_error_type);

%%%%����ͨ�����%%%%%%%%%
% ͨ��������(����ͨ������������):
if exist('error_module.mat','file')
load error_module.mat
else 
[error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);
end

if save_error == 1;
    % ����������
    save error_module error_amp error_Iphase error_Qphase
end

if save_error ==2;
    delete error_module.mat
end
%%%%%%%%���������������ؾ���
%���������ؾ��������Ԫ�ض����������������ͨ����������ؾ���������Ԫ�صľ�ֵ�ͷ��������̬�ֲ�ģ��
%���Ȳ���������������������������ؾ��󣨵����ź������������
%������ؾ�������Ԫ�صľ�ֵ��һ���������ȷ������������ؾ���Ҳ�Ǹ�ȷ���ľ���
self_correlation_matrix = SRMSignalOutput(T_dist,norm_ant_pos,norm_min_spacing,real_coef_matrix,mutual,T_rec,error_amp,error_Iphase,error_Qphase);
%�ٲ�������ؾ���������ģ���䷽��Ĳ���
self_correlation_matrix = SRMCorrelationSim(self_correlation_matrix,sampling_num,error_Qphase);

