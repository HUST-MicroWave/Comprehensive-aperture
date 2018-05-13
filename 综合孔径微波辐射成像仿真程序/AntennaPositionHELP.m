function AntennaPositionHELP()

% 阵列类型分为以下几类：
% (1)
% 'mrla' 最小冗余直线阵，目前支持少阵元数的情况。
% (2)
% 'ula' 均匀直线阵
% (3)
% 'Y_shape(y_shape)' 交错(普通)Y形平面阵
% (4)
% 'T_shape' T形平面阵
% (5)
% 'O_shape' 圆形平面阵
% (6)
% 'cross_shape' 圆形平面阵
% (7)
% '[0 1 4 7]' 直线怪阵，其位置为手动输入的值
% (8)
% '[0 1 4 7;
% 0 1 2 3]' 平面怪阵，其位置为手动输入的值。第一行第k元素代表第k个阵元x轴位置；第二行第k元素代表第k个阵元y轴位置
% 华中科技大学

% 查看阵列排布请在执行完主程序之后，输入下列代码：
figure()
min_spacing = SRM_param.norm_min_spacing;
ant_pos = SRM_param.norm_ant_pos;
if size(ant_pos,1) == 1
    ant_pos(2,:) = 0;
end
plot(min_spacing*ant_pos(1,:),min_spacing*ant_pos(2,:),'o');
title('天线阵列位置')
xlabel('单位：波长')
ylabel('单位：波长')

  