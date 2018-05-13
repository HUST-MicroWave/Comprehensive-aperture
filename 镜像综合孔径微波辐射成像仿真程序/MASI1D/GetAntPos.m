function ant_pos = GetAntPos(height, ant_spacing,delta_u)
% 华中科技大学
% height: 阵列到反射面的距离，波长归一化值
% ant_spacing: 天线间距，波长归一化
% delta_u: 最小间隔，波长归一化
% ant_pos: 各天线到反射面的距离

%天线排列及其位置
ant_pos_absolute = zeros(length(ant_spacing),1); %天线绝对位置，波长归一化
for k = 1:length(ant_spacing)
    ant_pos_relative = sum(ant_spacing(1:k))* delta_u;
    ant_pos(k) = ant_pos_relative + height;
end