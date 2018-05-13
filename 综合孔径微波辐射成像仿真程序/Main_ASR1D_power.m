clear all; clc; 
tic;

% �ۺϿ׾�΢���������������
% ���Ϊ*��HELP()�ĺ���Ϊ�����������Ҽ�open selection�򿪲鿴��
% ���пƼ���ѧ 2006-2013

                   %%%%%%%%%%%%%%%%%%������������%%%%%%%%%%%%%%%%% part1
                   % �ⲿ��Ϊ���붨��Ĳ���
  %%%%%%%%%%%%%%%%%ϵͳ���������sys_param
%����ʱ�䡣��λ����              
sys_param.integral_time = 10^(-0);    %*
%�����Ų����͡�  *AntennaPositionHELP()
sys_param.array_type = 'mrla';        %*
%��Ԫ��     *
sys_param.ant_num = 16;               %*
%������λ��Hz                    
sys_param.band = 100*10^6;
%�ռ�theta�Ƕ���ɢ����   *SpaceDivisionHELP()
sys_param.div = 'auto'; 
% sys_param.div = '3'; 
 %ϵͳ����Ƶ�ʣ���Ƶ�ź�����Ƶ�ʣ�����λ:Hz
sys_param.center_freq = 36.4e9;
 %���ݷ���    *InverseAlgorithmHELP()
sys_param.inverse_name = 'auto'; %�����㷨����

  %%%%%%%%%%%%%%%%%�������������ant_pos_info
%�������з�ʽ��λΪ������
SRM_param.norm_min_spacing = 0.5;    %*
%���ջ��¶ȣ���TB����λ��K
SRM_param.channel_info.T_rec = 300;

 %%%%%%%%%%%%%%%%%%�������壨һά��%%%%%%%%%%%%%%%%%%%%
% ��������˵��  *SceneDefineHELP()
% �����Դ��            
% �����ԴΪ�������С�ĵ�Դ
  STM_param.idealpoint_simu = 1;      %�Ƿ���棬0��ʾ�����棬1��ʾ����
  STM_param.idealpoint_place = [0 1 8 9]; %�������򣬶�
  STM_param.idealpoint_power = [200 200 200 200];  %Դ��������K��
% չԴ��
  STM_param.extentpoint_simu = 0;      %�Ƿ���棬0��ʾ�����棬1��ʾ����
  STM_param.extentpoint_place_start = [-10 20];       %����������ʼλ�ã���
  STM_param.extentpoint_power = [200 200];    %Դ��������K��
  STM_param.extentpoint_place_end = [12 41];       %����������ֹλ�ã���
% ͼƬ���룺�������ƽ���� 
  STM_param.picinsert_simu = 0;            %�Ƿ���棬0��ʾ�����棬1��ʾ����ͼƬ ,2��ʾ����.mat�ļ�
  



                    %%%%%%%%%%%%%%%%%%����������%%%%%%%%%%%%%%%%% part2
                    %�ⲿ��Ϊ����Ӳ���������Եķ��棬ģ������и�������Ϊ��0������������ķ����벻Ҫ�޸��ⲿ������
%%%%%%%%%%%%%%%%ͨ��������������channel_info%%%%%%%%%%%%%%%%%%%%
%���壺
%ͨ�������������     *ChannelErrorHELP() 
SRM_param.channel_info.error_amp_type = 'uniform';
%ͨ����������С
SRM_param.channel_info.error_amp_quantity = [1 1];
%ͨ��ͬ����λ�������
SRM_param.channel_info.error_Iphase_type = 'uniform';
%ͨ��ͬ����λ����С
SRM_param.channel_info.error_Iphase_quantity  = [0 0];
%ͨ��������λ�������
SRM_param.channel_info.error_Qphase_type = 'uniform';
%ͨ��������λ����С
SRM_param.channel_info.error_Qphase_quantity  = [0 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%����λ������������ant_pos_info%%%%%%%%%%%%%%
SRM_param.ant_pos_info = struct;  %*AntennaErrorHELP() 
% ����λ���������
SRM_param.ant_pos_info.ant_pos_error_type = 'uniform';
% ����λ������С
SRM_param.ant_pos_info.ant_pos_error_quantity = [0 0];
%%%%%%%%%%%%%%%%��������������ant_pos_info%%%%%%%%%%%%%%%%%
SRM_param.mutual_info = struct;  %MutualErrorHELP()
% ��ź���ֲ���
SRM_param.mutual_info.mutual_error_type = 'uniform';
% ��ź����С��
SRM_param.mutual_info.mutual_error_quantity = [0 0];
%%%%%%%%%%%%%��Ԫ���߷���ͼ����antenna_pattern_info%%%%%%%%%%%%
%��������   *AntennaPatternHELP()   
SRM_param.antenna_pattern_info.antenna_type = 'isotropic';             %*����
%���߳�����Ϣ
SRM_param.antenna_pattern_info.antenna_size = 0.004;                   %*����
%��Ԫ���߷���ͼ�������
SRM_param.antenna_pattern_info.pattern_error_type = 'uniform';
%��Ԫ���߷���ͼ����С
SRM_param.antenna_pattern_info.pattern_error_quantity = [0 0];

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%�Զ�����չ��������Ϊ�˳����ͳһ����ķ��㣬�뽫�Զ��幦�ܵĲ�������д�ڴ˴�����ע�͡������Ӧ�İ���������������ı�ĺ�����������˵����
%���磺��Ҫ���油0�ķ����㷨�����ڴ˴����Ӳ�������0�ĸ��������Ժ����������Ӧ�޸�
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


                   %%%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%% part3
%%%%A����%%%����
% �����Ų���ʽ��ȡ(��������λ�����ɺ���)��
[SRM_param.norm_ant_pos,sys_param.ant_num] = SRMAntPosGenerate(sys_param.array_type,sys_param.ant_num);

%%%%B����%%%����
% �����������еķֱ���,����ӳ���Χ��ֱ��ʵ�Ԫ���
[Fov,delta] = STMResolution(SRM_param.norm_min_spacing,SRM_param.norm_ant_pos);
% ���㳡�����·ֲ�
T_dist = STMSimulate(Fov,delta,STM_param,sys_param.div);

%%%%C����%%%���
% ����ؾ����ȡ(����ͨ�����з��溯��):
self_correlation_matrix = SRMSimulate(T_dist,sys_param,SRM_param);

%%%%D����%%%����
% ��ʼ�������㷨����
IAM_param.inverse_name = InverseAlgorithmSelect(sys_param.inverse_name,sys_param.array_type); 
% ͨ���ɼ��Ƚ��з���
inv_T = IAMSimulate(self_correlation_matrix,SRM_param,IAM_param);

%%%%E����%%%����
% �Է���ͼ������½��о��Զ���
inv_T = TAbsCalibration(inv_T,IAM_param.inverse_name);

%%%%F����%%%��ͼ
DrawInvPic(inv_T,SRM_param.norm_min_spacing,IAM_param.inverse_name);

toc;