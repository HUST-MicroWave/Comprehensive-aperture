function AntennaPatternHELP()

% ���߷���ͼ����:
% SRM_param.antenna_pattern_info.antenna_type
  % (1) 'rectangle' ���ο���   ��ʱ�����С��ʾΪ SRM_param.antenna_pattern_info.antenna_size=[a b]; x����a,y����b����λ�� 
  % (2) 'isotropic' ����      �������������Ϊ1 
  % (3) 'circle'    Բ�ο���   ��ʱ�����С��ʾΪ SRM_param.antenna_pattern_info.antenna_size=a;     �뾶Ϊa, ��λ��
  % (4) [1 0.9 1 0.8]         ���߷���ͼ�ֶ����룬�������볡������һ��
  
% ���߷���ͼ�������:
% SRM_param.antenna_pattern_info.pattern_error_type
  % (1) 'uniform'  ���ȷֲ�   ��ʱ����С��ʾΪ SRM_param.antenna_pattern_info.pattern_error_quantity=[a b]; �����a��b֮����ȷֲ�����λ��һ������ͼ���� 
  % (2) 'normal'   ��̬�ֲ�   ��ʱ����С��ʾΪ SRM_param.antenna_pattern_info.pattern_error_quantity=a;     ���ı�׼��Ϊa����λ��һ������ͼ���� 
  % (3) 'constant' �����ֲ�   ��ʱ����С��ʾΪ SRM_param.antenna_pattern_info.pattern_error_quantity=a;     ���Ϊa����λ��һ������ͼ���� 
  % (4) [0 0.1 0 -0.1]       ���߷���ͼ����ֶ����룬�������볡������һ��
  
  % ���пƼ���ѧ