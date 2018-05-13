function AntennaPatternHELP()

% 天线方向图类型:
% SRM_param.antenna_pattern_info.antenna_type
  % (1) 'rectangle' 矩形口面   此时口面大小表示为 SRM_param.antenna_pattern_info.antenna_size=[a b]; x方向a,y方向b，单位米 
  % (2) 'isotropic' 理想      各个方向增益均为1 
  % (3) 'circle'    圆形口面   此时口面大小表示为 SRM_param.antenna_pattern_info.antenna_size=a;     半径为a, 单位米
  % (4) [1 0.9 1 0.8]         天线方向图手动输入，输入量与场景点数一致
  
% 天线方向图误差类型:
% SRM_param.antenna_pattern_info.pattern_error_type
  % (1) 'uniform'  均匀分布   此时误差大小表示为 SRM_param.antenna_pattern_info.pattern_error_quantity=[a b]; 误差在a到b之间均匀分布，单位归一化方向图增益 
  % (2) 'normal'   正态分布   此时误差大小表示为 SRM_param.antenna_pattern_info.pattern_error_quantity=a;     误差的标准差为a，单位归一化方向图增益 
  % (3) 'constant' 常量分布   此时误差大小表示为 SRM_param.antenna_pattern_info.pattern_error_quantity=a;     误差为a，单位归一化方向图增益 
  % (4) [0 0.1 0 -0.1]       天线方向图误差手动输入，输入量与场景点数一致
  
  % 华中科技大学