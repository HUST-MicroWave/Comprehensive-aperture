function AntennaErrorHELP()

% ����λ�����:
% SRM_param.ant_pos_info.ant_pos_error_type
  % (1) 'uniform'  ���ȷֲ�    ��ʱ����С��ʾΪ SRM_param.ant_pos_info.ant_pos_error_quantity=[a b]; �����a��b֮����ȷֲ�����λ���� 
  % (2) 'normal'   ��̬�ֲ�    ��ʱ����С��ʾΪ SRM_param.ant_pos_info.ant_pos_error_quantity=a; ���ı�׼��Ϊa����λ���� 
  % (3) 'constant' �����ֲ�    ��ʱ����С��ʾΪ SRM_param.ant_pos_info.ant_pos_error_quantity=a; ���Ϊa����λ���� 
  % (4) [0 0.1 0 -0.1]  ����λ���������ֶ����룬��������������Ŀһ��
  %  ���У�����2ά���У�x��y�����ϵ�����������С���ֱ��ǣ���������Ϊ'constant'����СΪa�����ʾ��Ԫ����λ�����x����Ϊa,y����ҲΪa
  
  %   ���´����ʾû�����������
  % ����λ���������
  % SRM_param.ant_pos_info.ant_pos_error_type = 'uniform'
  % ����λ������С
  % SRM_param.ant_pos_info.ant_pos_error_quantity = [0 0];
  
  % ����Ҫ����ĳ�̶�����������һ��.mat�ļ������洢���ٽ��ò���ע�͵���ÿ��ֱ��load���
  
  % ���пƼ���ѧ