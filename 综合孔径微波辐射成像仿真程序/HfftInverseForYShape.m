function [Tfig Fov extent_UV UVexplane] = HfftInverseForYShape(self_correlation_matrix,min_spacing,ant_pos,max_arm)

%函数说明
% 函数作用：从自相关矩阵到亮温分布
% self_correlation_matrix 自相关矩阵，
% min_spacing 最小间距，以波长为单位
% ant_pos 天线位置，如果为旋转Y型阵，则是3维矩阵，第3维 ant_pos(:,:,k) 表示第k次旋转得到的天线位置。如不旋转为普通Y型阵
% max_arm 最长的那个臂的长度,为了划分网格的时候把所有点都包含需取最大的臂作为参考，该参数可以取的很大，等效于补0的反演算法
% 华中科技大学

% 获取Y形阵的UV平面采样点与视场
[extent_UV,Hextend_UV,Fov,Hextend_Fov]= UVHeCellofYShape(min_spacing,max_arm);
% 初始化UV平面点的可见度
UVplane = zeros(size(extent_UV));
UVexplane=zeros(3*max_arm+1,3*max_arm+1);
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
        %         position = find(extent_UV == delta_x + j*delta_y );
        counter(position) = counter(position)+1;
        UVplane(position) = UVplane(position)+self_correlation_matrix(p,q);
    end
end

for k = 1:length(counter)
    if 0 ~= counter(k)
        visibility(k) = UVplane(k)/counter(k);
    end
end
for k=1:length(counter);
    n1=2*real(extent_UV(k))/min_spacing/sqrt(3);
    n2=(imag(extent_UV(k))/min_spacing)+(n1/2);
    n1=round(n1);
    n2=round(n2);
    n2=mod(n2,3*max_arm+1);
    n1=mod(n1,3*max_arm+1);
    UVexplane(n1+1,n2+1)=visibility(k)+UVexplane(n1+1,n2+1);
end

% 得到亮温分布
ex_period=3*max_arm+1;
d=min_spacing;
image = ifft2(UVexplane);

T = abs(image);

flag=0;
for k=1:(3*max_arm+1)
    for p=1:(3*max_arm+1)
        flag=flag+1;
        Tfig(flag)=T(k,p);
    end
end


% 画图


r = abs(Fov(2)-Fov(3))/3;
angle = pi/6:pi/3:11*pi/6;
x = r*cos(angle);
y = r*sin(angle);
X = real(Fov);
Y = imag(Fov);


figure();
for k = 1:(3*max_arm+1)^2
    p2=2*Y(k)*min_spacing*(3*max_arm+1)/sqrt(3);
    p1=X(k)*min_spacing*(3*max_arm+1)-p2/2;
    p2=round(p2);
    p1=round(p1);

    p2=mod(p2,3*max_arm+1);
    p1=mod(p1,3*max_arm+1);
    p1=p1+1;
    p2=p2+1;
    xaxis = -X(k)+x;
    yaxis = -Y(k)+y;
    hold on
    fill(xaxis,yaxis,T(p1,p2),'linestyle', 'none');
end
title('Y型阵反演图像');
xlabel('l');
ylabel('m');
% axis square