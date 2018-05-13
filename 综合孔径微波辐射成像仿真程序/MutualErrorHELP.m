function MutualErrorHELP()

% 互耦误差:
% SRM_param.mutual_info.mutual_error_type
  % (1) 'uniform' 均匀分布   此时误差大小表示为 SRM_param.mutual_info.mutual_error_quantity=[a b]; 误差在a到b之间均匀分布，单位该通道能量的倍数（必须小于1） 
  % (2) 'normal' 正态分布   此时误差大小表示为 SRM_param.ant_pos_info.ant_pos_error_quantity=a; 误差的标准差为a，单位该通道能量的倍数（必须小于1） 
  % (3) 'constant' 常量分布   此时误差大小表示为 SRM_param.ant_pos_info.ant_pos_error_quantity=a; 误差为a，单位该通道能量的倍数（必须小于1）
  % (4) [0.9792, 0.012,  0.0048,  0.004;
  %      0.012,  0.974,  0.008,   0.006;
  %      0.0048, 0.008,  0.9632,  0.024;
  %      0.004,  0.006,  0.024,   0.966;]    互耦矩阵手动输入，矩阵大小与自相关矩阵相同
  
%！！
%需要特别注意的是，天线距离越远互耦越小的因素被考虑到了。所有误差大小均是以最小间隔为参考，实际仿真中，2个通道间的互耦大小还要除以天线最小间隔的倍数
%互耦矩阵大体上会表现为“对称”的“次”对角矩阵
  
  %   如下代码表示没有误差的情况：
% % 互藕误差分布：
% SRM_param.mutual_info.mutual_error_type = 'uniform';
% % 互藕误差大小：
% SRM_param.mutual_info.mutual_error_quantity = [0 0];
  
  % 若需要仿真某固定误差，可先生成一个.mat文件将误差存储，再将该部分注释掉，每次直接load误差
  
  % 华中科技大学