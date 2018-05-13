clear all; clc; tic;

% 综合孔径微波辐射成像仿真程序
% 标记为*？HELP()的函数为帮助函数，右键open selection打开查看。
% 华中科技大学 2006-2013

                   %%%%%%%%%%%%%%%%%%基本参数定义%%%%%%%%%%%%%%%%% part1
                   % 这部分为必须定义的参数
  %%%%%%%%%%%%%%%%%系统类参数定义sys_param
%积分时间。单位：秒              
sys_param.integral_time = 10^(-1);    %*
%阵列排布类型。  *AntennaPositionHELP()
sys_param.array_type = 'Y_shape';        %*
%阵元数     *
sys_param.ant_num = 24;               %*
%带宽。单位：Hz                    
sys_param.band = 100*10^6;
%空间theta角度离散划分   *SpaceDivisionHELP()
sys_param.div = 'auto'; 
% sys_param.div = ['3 3']; 
 %射频信号中心频率，单位:Hz
sys_param.center_freq = 36.4e9;
 %反演方法    *InverseAlgorithmHELP()
sys_param.inverse_name = 'auto'; %反演算法名称

  %%%%%%%%%%%%%%%%%基线类参数定义ant_pos_info
%基线排列方式单位为波长：
% 横向与纵向的最小间距
SRM_param.norm_min_spacing = 1;    %*
%接收机温度，即TB。单位：K
SRM_param.channel_info.T_rec = 300;

 %%%%%%%%%%%%%%%%%%场景定义（平面阵列）%%%%%%%%%%%%%%%%%%%%
% 场景定义说明  *SceneDefineHELP()
% 理想点源：            
% 理想点源为体积无限小的点源
  STM_param.idealpoint_simu = 0;      %是否仿真，0表示不仿真，1表示仿真
  STM_param.idealpoint_place = [0;0]; %[0 30;0 90]; %来波方向，度
  STM_param.idealpoint_power = [300]; %[400 400];  %源的能量（K）
% 展源：
  STM_param.extentpoint_simu = 0;      %是否仿真，0表示不仿真，1表示仿真
  STM_param.extentpoint_model = 'rectangular';      %展源的形状
  %方形展源参数
  STM_param.extentpoint_rec_power = [400 300 500];    %源的能量（K）
  STM_param.extentpoint_rec_place_center = [0 0;30 0;30 90];  %来波方向中心位置，度
  STM_param.extentpoint_rec_place_hs = [3 3;10 10;10 10];       %半边长，度
% 图片导入：（仅针对平面阵）
  STM_param.picinsert_simu = 2;            %是否仿真，0表示不仿真，1表示仿真图片 ,2表示读入.mat文件
  STM_param.filename = '太阳.bmp';      %导入的图片位置
  STM_param.matfile = 'pictest.mat';       %导入图形矩阵
  STM_param.pic_scope = [-30 30;-30 30];   %导入图片的上下和左右范围

  



                    %%%%%%%%%%%%%%%%%%误差参数定义%%%%%%%%%%%%%%%%% part2
                    %这部分为各种硬件非理想性的仿真，模板程序中各个误差都设为了0，对理想情况的仿真请不要修改这部分内容
%%%%%%%%%%%%%%%%通道类误差参数定义channel_info%%%%%%%%%%%%%%%%%%%%
%误差定义：
%通道幅度误差类型     *ChannelErrorHELP() 
SRM_param.channel_info.error_amp_type = 'uniform';
%通道幅度误差大小
SRM_param.channel_info.error_amp_quantity = [1 1];
%通道同相相位误差类型
SRM_param.channel_info.error_Iphase_type = 'uniform';
%通道同相相位误差大小
SRM_param.channel_info.error_Iphase_quantity  = [0 0];
%通道正交相位误差类型
SRM_param.channel_info.error_Qphase_type = 'uniform';
%通道正交相位误差大小
SRM_param.channel_info.error_Qphase_quantity  = [0 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%天线位置误差参数定义ant_pos_info%%%%%%%%%%%%%%
SRM_param.ant_pos_info = struct;  %*AntennaErrorHELP() 
% 天线位置误差类型
SRM_param.ant_pos_info.ant_pos_error_type = 'uniform';
% 天线位置误差大小
SRM_param.ant_pos_info.ant_pos_error_quantity = [0 0];
%%%%%%%%%%%%%%%%互耦误差参数定义ant_pos_info%%%%%%%%%%%%%%%%%
SRM_param.mutual_info = struct;  %MutualErrorHELP()
% 互藕误差分布：
SRM_param.mutual_info.mutual_error_type = 'uniform';
% 互藕误差大小：
SRM_param.mutual_info.mutual_error_quantity = [0 0];
%%%%%%%%%%%%%单元天线方向图定义antenna_pattern_info%%%%%%%%%%%%
%天线类型   *AntennaPatternHELP()   
SRM_param.antenna_pattern_info.antenna_type = 'isotropic';             %*参数
%天线长宽信息
SRM_param.antenna_pattern_info.antenna_size = 0.004;                   %*参数
%单元天线方向图误差类型
SRM_param.antenna_pattern_info.pattern_error_type = 'uniform';
%单元天线方向图误差大小
SRM_param.antenna_pattern_info.pattern_error_quantity = [0 0];

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%自定义扩展功能区域（为了程序的统一与查阅方便，请将自定义功能的参数部分写于此处，并注释、添加相应的帮助函数，将后面改变的函数，语句进行说明）
%例如：需要仿真补0的反演算法，可在此处增加参数：补0的个数，并对后面程序做相应修改
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


                   %%%%%%%%%%%%%%%%%%仿真运算%%%%%%%%%%%%%%%%% part3
%%%%A部分%%%阵列
% 阵列排步方式获取(调用天线位置生成函数)：
[SRM_param.norm_ant_pos,sys_param.ant_num] = SRMAntPosGenerate(sys_param.array_type,sys_param.ant_num);

%%%%B部分%%%场景
STM_param.array_type = sys_param.array_type; 
% 计算天线阵列的分辨率,获得视场范围与分辨率单元间隔
[Fov,delta] = STMResolution(SRM_param.norm_min_spacing,SRM_param.norm_ant_pos);
% 计算场景量温分布
T_dist = STMSimulate(Fov,delta,STM_param,sys_param.div);

%%%%C部分%%%相关
% 自相关矩阵获取(调用通道阵列仿真函数):
self_correlation_matrix = SRMSimulate(T_dist,sys_param,SRM_param);

%%%%D部分%%%反演
% 初始化反演算法名称
IAM_param.inverse_name = InverseAlgorithmSelect(sys_param.inverse_name,sys_param.array_type); 
% 通过可见度进行反演
inv_T = IAMSimulate(self_correlation_matrix,SRM_param,IAM_param);

%%%%E部分%%%定标
% 对反演图像的量温进行绝对定标
inv_T = TAbsCalibration(inv_T,IAM_param.inverse_name);

%%%%F部分%%%画图
DrawInvPic(inv_T,SRM_param.norm_min_spacing,IAM_param.inverse_name);

toc;