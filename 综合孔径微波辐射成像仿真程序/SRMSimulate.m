function self_correlation_matrix = SRMSimulate(T_dist,sys_param,SRM_param,save_error)

%   语法：
%   self_correlation_matrix = SRMSimulate(T_dist,sys_param, SRM_param);
% 
%   函数功能：
%   此函数为天线模块主函数，功能为：
%   读取场景模块提供的天线口面视在亮温分布信息，输出各个天线的等效复基带采样信号。
%  
%   输入参数:
% T_dist     ：天线口面视在亮温分布矩阵，分2种情况
%     输入矩阵的行数为2      ：一维直线阵列
%     输入矩阵的行数为3      ：平面阵列，少量点源
%
% 结构体SRM_param：
%     norm_min_spacing     ：最小基线排列间隔，单位为波长
%     norm_ant_pos     ：基线排列形式，分2种情况
%         输入矩阵的行数为1      ：一维直线阵列
%         输入矩阵的行数为2      ：平面阵列
% ant_pos_info   ：基线排列信息
%     ant_pos_info.ant_pos_error_quantity  ：基线排列误差的大小，如果不输入此参数，表示没有该误差
% antenna_pattern_info    :方向图信息
%     antenna_pattern_info.antenna_type   ：天线形状，有以下几种情况可选
%         'isotropic'  理想，各个方向均为1
%         'rectangle'   矩形口面
%         'circle'     圆形口面
%     antenna_pattern_info.wavelength     ：天线工作波长
%     antenna_pattern_info.antenna_size   ：天线尺寸，分以下几种情况，与上面对应
%         无需填写
%         2个元素的向量，第一个元素为长，第二个元素为宽
%         1个元素，为天线半径
%     antenna_pattern_info.pattern_error_quantity    ：天线方向图误差的大小，如果不输入此参数，表示没有该误差
% mutual_info            ：互耦信息
%     mutual_info.mutual_error_quantity    ：互耦的大小
% sys_param            ：系统信息
%     sys_param.band        ：带宽
%     sys_param.integral_time   ：积分时间
%     sys_param.array_type      ：阵列类型
%         MLRA       ：一维最小冗余阵
%         Y_SHAPE    ：Y型平面阵
%         T_SHAPE    : T型平面阵
% save_error           :是否保存本次误差
%       0  不保存（默认）
%       1  保存
%       2  删除之前保存的
%   输出参数：
%   self_correlation_matrix       :各个天线输出信号
% 
%   范例:
% SRM_param.norm_min_spacing = 1/2;
% SRM_param.norm_ant_pos = [0 2 5 6]; 
% SRM_param.mutual_info.mutual_error_quantity = 0.01;
% SRM_param.antenna_pattern_info.antenna_type = 'circle';
% SRM_param.antenna_pattern_info.wavelength = 0.008;
% SRM_param.antenna_pattern_info.antenna_size = 0.008;
% sys_param.band = 100*10^6;
% sys_param.integral_time = 10^(-5);
% sys_param.array_type = 'MLRA'; 
% source_place = [-20 0 20 30]; %来波方向
% source_power = [1 1 1.5 2];  %源的功率
% T_dist = [source_power;source_place];
% self_correlation_matrix = SRMSimulate(T_dist,sys_param, SRM_param);
%
%   华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $


if nargin<=3
    save_error = 0;
end


%%%%%%%%%%%%%%%%%参数提取%%%%%%%%%%%%%%%%%%%%
norm_min_spacing = SRM_param.norm_min_spacing;           %天线阵列最小间距
norm_ant_pos = SRM_param.norm_ant_pos;                   %天线位置
antenna_pattern_info = SRM_param.antenna_pattern_info;   %天线方向图类
T_rec = SRM_param.channel_info.T_rec;                    %通道温度
channel_info = SRM_param.channel_info;                   %通道信息类
%采样点数等于带宽乘积分时间
sampling_num = floor(sys_param.band*sys_param.integral_time); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%系统类参数%%%%%%%%%%%%%%%%%%%%
% 区别平面阵列还是一维阵列，一维阵列1，平面阵列0
if(size(norm_ant_pos,1)==1)       %如果天线位置是向量，显然是一维线阵，只需用x就可表示天线位置
    array_type = 1;
elseif(size(norm_ant_pos,1)==2)   %如果天线位置是行数为2的矩阵，显然是平面阵，因为需要用x,y坐标来表示阵列位置
    array_type = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%添加天线位置误差%%%%%
ant_pos_error_type = SRM_param.ant_pos_info.ant_pos_error_type;          %天线位置误差类型从结构体中获取
ant_pos_error_quantity = SRM_param.ant_pos_info.ant_pos_error_quantity;  %天线位置误差大小从结构体中获取
antenna_num = sys_param.ant_num ;                                        %天线个数从结构体中获取
% 有误差存在的情况下真实的天线排列(调用天线位置误差产生函数)：
norm_ant_pos = SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity,ant_pos_error_type);

%%%%产生天线方向图%%%%%%%
c = 3*10^8;                                                 %光速
antenna_pattern_info.wavelength = c/sys_param.center_freq;  %获取天线工作波长
% 天线方向图向量(调用天线方向图产生函数)：
switch size(T_dist,1)
    case 2      %输入矩阵的行数为2：第一行为角度位置信息，第二行为能量，是一维直线阵列 
        coef_matrix = SRMPatternGenerate(antenna_pattern_info,T_dist(2,:),array_type);
    case 3      %输入矩阵的行数为3：第一，二行为角度位置信息，第三行为能量，是二维平面阵列
        coef_matrix = SRMPatternGenerate(antenna_pattern_info,T_dist([2:3],:),array_type);
end

%%%%产生天线方向图误差%%%%%%%
pattern_error_quantity = SRM_param.antenna_pattern_info.pattern_error_quantity;   %天线方向图误差大小从结构体中获取
pattern_error_type = SRM_param.antenna_pattern_info.pattern_error_type;           %天线方向图误差类型从结构体中获取
% 天线方向图误差向量(调用天线方向图误差产生函数):
real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);

%%%%产生互耦误差%%%%%%%%%
mutual_error_quantity = SRM_param.mutual_info.mutual_error_quantity;   %互耦误差大小从结构体中获取
mutual_error_type = SRM_param.mutual_info.mutual_error_type;           %互耦误差类型从结构体中获取
% 互藕矩阵(调用互耦误差产生函数)：
mutual = SRMMutualErrorGenerate(norm_min_spacing,norm_ant_pos,mutual_error_quantity,mutual_error_type);

%%%%产生通道误差%%%%%%%%%
% 通道误差矩阵(调用通道误差产生函数):
if exist('error_module.mat','file')
load error_module.mat
else 
[error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);
end

if save_error == 1;
    % 保存误差参数
    save error_module error_amp error_Iphase error_Qphase
end

if save_error ==2;
    delete error_module.mat
end
%%%%%%%%产生天线输出自相关矩阵
%这里把自相关矩阵的所有元素都看成是随机变量，通过计算自相关矩阵中所有元素的均值和方差，进行正态分布模拟
%首先产生不考虑噪声波动的理论自相关矩阵（调用信号输出函数）：
%即自相关矩阵所有元素的均值，一旦仿真参数确定，理论自相关矩阵也是个确定的矩阵
self_correlation_matrix = SRMSignalOutput(T_dist,norm_ant_pos,norm_min_spacing,real_coef_matrix,mutual,T_rec,error_amp,error_Iphase,error_Qphase);
%再产生自相关矩阵的随机误差，模拟其方差的波动
self_correlation_matrix = SRMCorrelationSim(self_correlation_matrix,sampling_num,error_Qphase);

