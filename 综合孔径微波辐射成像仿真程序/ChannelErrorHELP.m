function ChannelErrorHELP()

% ͨ������Ϊ�������ࣺ

% ͨ���������:
% SRM_param.channel_info.error_amp_type
  % (1) 'uniform' ���ȷֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_amp_quantity=[a b]; �����a��b֮����ȷֲ�����λ��һ������ 
  % (2) 'normal' ��̬�ֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_amp_quantity=a; ���ı�׼��Ϊa����λ��һ������
  % (3) 'constant' �����ֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_amp_quantity=a; ���Ϊa����λ��һ������
  % (4) [1 0.9 1 1.1]  ͨ����������ֶ����룬��������������Ŀһ��
  
% ͨ��ͬ����λ��
% SRM_param.channel_info.error_Iphase_type 
  % (1) 'uniform' ���ȷֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_Iphase_quantity=[a b]; �����a��b֮����ȷֲ�����λ����
  % (2) 'normal' ��̬�ֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_Iphase_quantity=a; ���ı�׼��Ϊa����λ����
  % (3) 'constant' �����ֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_Iphase_quantity=a; ���Ϊa����λ����
  % (4) [0 0.1 0 -0.1]  ͨ��ͬ����λ����ֶ����룬��������������Ŀһ��

% ͨ��������λ��
% SRM_param.channel_info.error_Qphase_type 
  % (1) 'uniform' ���ȷֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_Qphase_quantity=[a b]; �����a��b֮����ȷֲ�����λ����
  % (2) 'normal' ��̬�ֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_Qphase_quantity=a; ���ı�׼��Ϊa����λ����
  % (3) 'constant' �����ֲ�   ��ʱ����С��ʾΪ SRM_param.channel_info.error_Qphase_quantity=a; ���Ϊa����λ����
  % (4) [0 0.1 0 -0.1]  ͨ��������λ����ֶ����룬��������������Ŀһ��

%   ���´����ʾû�����������
% SRM_param.channel_info.error_amp_type = 'uniform';
% %ͨ����������С
% SRM_param.channel_info.error_amp_quantity = [1 1];
% %ͨ��ͬ����λ�������
% SRM_param.channel_info.error_Iphase_type = 'uniform';
% %ͨ��ͬ����λ����С
% SRM_param.channel_info.error_Iphase_quantity  = [0 0];
% %ͨ��������λ�������
% SRM_param.channel_info.error_Qphase_type = 'uniform';
% %ͨ��������λ����С
% SRM_param.channel_info.error_Qphase_quantity  = [0 0];

% ����Ҫ����ĳ�̶�����������һ��.mat�ļ������洢���ٽ��ò���ע�͵���ÿ��ֱ��load���

% ���пƼ���ѧ