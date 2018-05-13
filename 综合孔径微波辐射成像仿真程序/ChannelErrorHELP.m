function ChannelErrorHELP()

% 通道误差分为以下三类：

% 通道幅度误差:
% SRM_param.channel_info.error_amp_type
  % (1) 'uniform' 均匀分布   此时误差大小表示为 SRM_param.channel_info.error_amp_quantity=[a b]; 误差在a到b之间均匀分布，单位归一化增益 
  % (2) 'normal' 正态分布   此时误差大小表示为 SRM_param.channel_info.error_amp_quantity=a; 误差的标准差为a，单位归一化增益
  % (3) 'constant' 常量分布   此时误差大小表示为 SRM_param.channel_info.error_amp_quantity=a; 误差为a，单位归一化增益
  % (4) [1 0.9 1 1.1]  通道幅度误差手动输入，输入量与天线数目一致
  
% 通道同相相位误差：
% SRM_param.channel_info.error_Iphase_type 
  % (1) 'uniform' 均匀分布   此时误差大小表示为 SRM_param.channel_info.error_Iphase_quantity=[a b]; 误差在a到b之间均匀分布，单位弧度
  % (2) 'normal' 正态分布   此时误差大小表示为 SRM_param.channel_info.error_Iphase_quantity=a; 误差的标准差为a，单位弧度
  % (3) 'constant' 常量分布   此时误差大小表示为 SRM_param.channel_info.error_Iphase_quantity=a; 误差为a，单位弧度
  % (4) [0 0.1 0 -0.1]  通道同相相位误差手动输入，输入量与天线数目一致

% 通道正交相位误差：
% SRM_param.channel_info.error_Qphase_type 
  % (1) 'uniform' 均匀分布   此时误差大小表示为 SRM_param.channel_info.error_Qphase_quantity=[a b]; 误差在a到b之间均匀分布，单位弧度
  % (2) 'normal' 正态分布   此时误差大小表示为 SRM_param.channel_info.error_Qphase_quantity=a; 误差的标准差为a，单位弧度
  % (3) 'constant' 常量分布   此时误差大小表示为 SRM_param.channel_info.error_Qphase_quantity=a; 误差为a，单位弧度
  % (4) [0 0.1 0 -0.1]  通道正交相位误差手动输入，输入量与天线数目一致

%   如下代码表示没有误差的情况：
% SRM_param.channel_info.error_amp_type = 'uniform';
% %通道幅度误差大小
% SRM_param.channel_info.error_amp_quantity = [1 1];
% %通道同相相位误差类型
% SRM_param.channel_info.error_Iphase_type = 'uniform';
% %通道同相相位误差大小
% SRM_param.channel_info.error_Iphase_quantity  = [0 0];
% %通道正交相位误差类型
% SRM_param.channel_info.error_Qphase_type = 'uniform';
% %通道正交相位误差大小
% SRM_param.channel_info.error_Qphase_quantity  = [0 0];

% 若需要仿真某固定误差，可先生成一个.mat文件将误差存储，再将该部分注释掉，每次直接load误差

% 华中科技大学