function [visibility,extent_UV,Fov] = R2VY(self_correlation_matrix,ant_pos,min_spacing,max_arm)

% Y形阵自相关矩阵到可见度转化
% 华中科技大学

% 获取Y形阵的UV平面采样点与视场
[extent_UV Fov] = GenerateUVCellofYShape(min_spacing,max_arm);
% [extent_UV,Hextend_UV,Fov,Hextend_Fov]= UVHeCellofYShape(min_spacing,max_arm);
% 初始化UV平面点的可见度
UVplane = zeros(size(extent_UV));
% 初始化UV平面的可见度计数
counter = UVplane; 
% 初始化可见度
visibility = UVplane;

% 用于比较的小数
small_num = 10^(-2);
% 得到uv平面点的可见度分布
for p = 1:size(ant_pos,2)
    for q = 1:size(ant_pos,2)
        delta_x = min_spacing*(ant_pos(1,p)-ant_pos(1,q));
        delta_y = min_spacing*(ant_pos(2,p)-ant_pos(2,q));
        position = find( real(extent_UV)>(delta_x-small_num) & real(extent_UV)<(delta_x+small_num) & imag(extent_UV)>(delta_y-small_num) & imag(extent_UV)<(delta_y+small_num) );
        counter(position) = counter(position)+1;
        UVplane(position) = UVplane(position)+self_correlation_matrix(q,p);
    end
end

% 得到uv平面点的可见度冗余平均
for k = 1:length(counter)
    if 0 ~= counter(k)
        visibility(k) = UVplane(k)/counter(k);
    end
end
