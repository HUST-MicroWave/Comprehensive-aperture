function AntennaErrorHELP()

% 天线位置误差:
% SRM_param.ant_pos_info.ant_pos_error_type
  % (1) 'uniform'  均匀分布    此时误差大小表示为 SRM_param.ant_pos_info.ant_pos_error_quantity=[a b]; 误差在a到b之间均匀分布，单位波长 
  % (2) 'normal'   正态分布    此时误差大小表示为 SRM_param.ant_pos_info.ant_pos_error_quantity=a; 误差的标准差为a，单位波长 
  % (3) 'constant' 常量分布    此时误差大小表示为 SRM_param.ant_pos_info.ant_pos_error_quantity=a; 误差为a，单位波长 
  % (4) [0 0.1 0 -0.1]  天线位置误差误差手动输入，输入量与天线数目一致
  %  其中，对于2维阵列，x，y方向上的误差类型与大小作分别考虑，例如类型为'constant'，大小为a，则表示单元天线位置误差x方向为a,y方向也为a
  
  %   如下代码表示没有误差的情况：
  % 天线位置误差类型
  % SRM_param.ant_pos_info.ant_pos_error_type = 'uniform'
  % 天线位置误差大小
  % SRM_param.ant_pos_info.ant_pos_error_quantity = [0 0];
  
  % 若需要仿真某固定误差，可先生成一个.mat文件将误差存储，再将该部分注释掉，每次直接load误差
  
  % 华中科技大学