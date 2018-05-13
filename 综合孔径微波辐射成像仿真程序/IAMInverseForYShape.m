function [T Fov] = IAMInverseForYShape(rot_self_correlation_matrix,rotnum,min_spacing,rot_ant_pos,max_arm)

%函数说明
% 函数作用：从自相关矩阵到亮温分布
% rot_self_correlation_matrix 自相关矩阵，如果为旋转Y型阵，则是3维矩阵，第3维 rot_self_correlation_matrix(:,:,k) 表示第k次旋转得到的自相关矩阵。如不旋转为普通Y型阵
% rotnum 旋转次数，如不旋转为0
% min_spacing 最小间距，以波长为单位
% rot_ant_pos 天线位置，如果为旋转Y型阵，则是3维矩阵，第3维 rot_ant_pos(:,:,k) 表示第k次旋转得到的天线位置。如不旋转为普通Y型阵
% max_arm 最长的那个臂的长度,为了划分网格的时候把所有点都包含需取最大的臂作为参考，该参数可以取的很大，等效于补0的反演算法
% 华中科技大学

% 获取Y形阵的UV平面采样点与视场
[extent_UV Fov] = GenerateUVCellofYShape(min_spacing,max_arm);
% 初始化UV平面点的可见度
UVplane = zeros(size(extent_UV));
% 初始化UV平面的可见度计数
counter = UVplane; 
% 初始化可见度
visibility = UVplane;

% 用于比较的小数
small_num = 10^(-2);
% 得到uv平面点的可见度分布
for k = 0:rotnum
    self_correlation_matrix = rot_self_correlation_matrix(:,:,k+1);
    ant_pos = rot_ant_pos(:,:,k+1);

    for p = 1:size(ant_pos,2)
        for q = 1:size(ant_pos,2)
            delta_x = min_spacing*(ant_pos(1,p)-ant_pos(1,q));
            delta_y = min_spacing*(ant_pos(2,p)-ant_pos(2,q));
            position = find( real(extent_UV)>(delta_x-small_num) & real(extent_UV)<(delta_x+small_num) & imag(extent_UV)>(delta_y-small_num) & imag(extent_UV)<(delta_y+small_num) );
            %         position = find(extent_UV == delta_x + j*delta_y );
            counter(position) = counter(position)+1;
            UVplane(position) = UVplane(position)+self_correlation_matrix(p,q);
        end
    end
end


% 得到uv平面点的可见度冗余平均
for k = 1:length(counter)
    if 0 ~= counter(k)
        visibility(k) = UVplane(k)/counter(k);
    end
end

% 得到亮温分布
for k = 1:length(counter)
    l = real(Fov(k));
    m = imag(Fov(k));
    T(k) = 0;
    for pos = 1:length(counter)
        u = real(extent_UV(pos));
        v = imag(extent_UV(pos));
        a  = exp(2*pi*j*(u*l+v*m));
        T(k) = T(k)+visibility(pos)*a;
    end
    T(k) = T(k)/length(counter);
end

% 画图
r = abs(Fov(1)-Fov(2))/3;
angle = pi/6:pi/3:11*pi/6;
x = r*cos(angle);
y = r*sin(angle);
X = real(Fov);
Y = imag(Fov);

figure()
for k = 1:length(T)
    xaxis = X(k)+x;
    yaxis = Y(k)+y;
    hold on
    fill(xaxis,yaxis,abs(T(k)),'linestyle', 'none');
end
title('Y型阵反演图像');
xlabel('l');
ylabel('m');
% axis square

    