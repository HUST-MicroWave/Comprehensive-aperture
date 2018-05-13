function inv_T=HFFT_Inverse(Visibility_sample_contain0,ext_UV,min_space,arm_ant_num)
%此函数用于SMOS数据的亮温反演；
%算法是基于六边形的快速傅里叶变换算法(采用取模方式)；
% 华中科技大学

t0=clock;%计时器；
d=min_space;
NT=3*arm_ant_num+1;
% load ant_pos;
Visibility_sample=Visibility_sample_contain0(:,3);

if size(ext_UV,2)==2
    ext_UV=ext_UV(:,1)+1i*ext_UV(:,2);
end
UV2Hex=[real(ext_UV),imag(ext_UV)]*[1,0;-1/sqrt(3),2/sqrt(3)];%将直角坐标系转换成六边形基矢下的坐标；
k1=round(UV2Hex(:,1)./d);
k1=mod(k1,NT);
k2=round(UV2Hex(:,2)./d);
k2=mod(k2,NT);
visibility=zeros(NT,NT);
for n1=1:length(ext_UV)
    visibility(k1(n1)+1,k2(n1)+1)=Visibility_sample(n1);
end
inv_Hex_T=(sqrt(3)*d^2*NT^2/2)*ifft2(visibility); 
Fov_min_space=2/sqrt(3)/(3*arm_ant_num+1)/min_space;
Fov = 2*ext_UV*exp(1i*pi/6)/sqrt(3)/(3*arm_ant_num+1)/min_space/min_space;
Fov2Hex=[real(Fov),imag(Fov)]*[2/sqrt(3),1/sqrt(3);0,1];
p1=round(Fov2Hex(:,1)./Fov_min_space);
p1=mod(p1,NT);
p2=round(Fov2Hex(:,2)./Fov_min_space);
p2=mod(p2,NT);
inv_T=zeros(length(Fov),1);
for i=1:length(p2)
    inv_T(i)=inv_Hex_T(p1(i)+1,p2(i)+1);
end
continue_time=etime(clock,t0);
str=sprintf('HFFT算法所用时间为：%f秒',continue_time);
disp(str)
end
