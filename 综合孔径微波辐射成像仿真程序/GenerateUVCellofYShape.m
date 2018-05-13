function [extent_UV,Fov]= GenerateUVCellofYShape(min_spacing,max_arm)
% 华中科技大学

% max_arm
% 最长的那个臂的长度,为了划分网格的时候把所有点都包含需取最大的臂作为参考

% x方向上的最小间距
dx = min_spacing*sind(60);
% y方向上的最小间距
dy = min_spacing*sind(30);

flag = 0;
pmmatrix = [-1 1 1];
q_num = max_arm;


for p = 1:3*max_arm+1
    q_num = q_num + pmmatrix(mod(p+1,3)+1);
    for q = 1:q_num
        flag = flag + 1;
        xaxis = -1-q_num+q*2;
        xaxis = xaxis*dx;
        yaxis = 3*max_arm+1-p;
        yaxis = yaxis*dy;
        extent_UV(flag) = xaxis+j*yaxis;
    end
end

pmmatrix = [1 -1 -1];
for p = 1:3*max_arm
    q_num = q_num + pmmatrix(mod(p,3)+1);
    for q = 1:q_num
        flag = flag + 1;
        xaxis = -1-q_num+q*2;
        xaxis = xaxis*dx;
        yaxis = -p;
        yaxis = yaxis*dy;
        extent_UV(flag) = xaxis+j*yaxis;
    end
end


% Fov = extent_UV*exp(j*pi/6)/max_arm/3/min_spacing/min_spacing;
Fov = 2*extent_UV*exp(1i*pi/6)/sqrt(3)/(3*max_arm+1)/min_spacing/min_spacing;
% 画图
% figure()
% plot(real(extent_UV),imag(extent_UV),'o');
% figure()
% plot(real(Fov),imag(Fov),'o');
% axis square