function [extent_UV,Hextend_UV,Fov,Hextend_Fov]= UVHeCellofYShape(min_spacing,max_arm)
%周期拓展后的UV平面图
% 华中科技大学


% x方向上的最小间距
dx = min_spacing*sind(60);
% y方向上的最小间距
dy = min_spacing*sind(30);

flag = 0;
pmmatrix = [-1 1 1];
% max_arm=max_arm+1;
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

extent_UVflag=extent_UV(flag);
extent_UV0=extent_UV(1);
extent_UV(1)=extent_UVflag;
extent_UV(flag)=extent_UV0;

% index=find(imag(extent_UV)>eps);
% extent_UV_up=extent_UV(index);
% extent_UV_low=extent_UV_up.*exp(-1i*pi);
%  extent_UV=[extent_UV,extent_UV_low];
 

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

%{
for p=1:max_arm
    flag=flag+1;
    yaxis=3*max_arm+1;
    yaxis=yaxis*dy;
    xaxis=2*p-max_arm-1;
    xaxis=xaxis*dx;
    extent_UV(flag)=xaxis+j*yaxis;
end

for p=1:max_arm
    flag=flag+1;
    yaxis=3*max_arm+1;
    yaxis=yaxis*dy;
    xaxis=2*p-max_arm-1;
    xaxis=xaxis*dx;
    zaxis=xaxis+j*yaxis;
    r_z=abs(zaxis);
    a_z=angle(zaxis);
    az=pi/3-a_z;
    extent_UV(flag)=r_z*exp(j*az);
end
for p=1:max_arm
    flag=flag+1;
    yaxis=3*max_arm+1;
    yaxis=yaxis*dy;
    xaxis=2*p-max_arm-1;
    xaxis=xaxis*dx;
    zaxis=xaxis+j*yaxis;
    r_z=abs(zaxis);
    a_z=angle(zaxis);
    az=5*pi/3-a_z;
    extent_UV(flag)=r_z*exp(j*az);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%把另外三个边补成对称的
for p=1:max_arm
    flag=flag+1;
    yaxis=3*max_arm+1;
    yaxis=yaxis*dy;
    xaxis=2*p-max_arm-1;
    xaxis=xaxis*dx;
    zaxis=xaxis+j*yaxis;
    r_z=abs(zaxis);
    a_z=angle(zaxis);
    az=-a_z;
    extent_UV(flag)=r_z*exp(j*az);
end

for p=1:max_arm
    flag=flag+1;
    yaxis=3*max_arm+1;
    yaxis=yaxis*dy;
    xaxis=2*p-max_arm-1;
    xaxis=xaxis*dx;
    zaxis=xaxis+j*yaxis;
    r_z=abs(zaxis);
    a_z=angle(zaxis);
    az=pi/3+a_z;
    extent_UV(flag)=r_z*exp(j*az);
end

for p=1:max_arm
    flag=flag+1;
    yaxis=3*max_arm+1;
    yaxis=yaxis*dy;
    xaxis=2*p-max_arm-1;
    xaxis=xaxis*dx;
    zaxis=xaxis+j*yaxis;
    r_z=abs(zaxis);
    a_z=angle(zaxis);
    az=5*pi/3+a_z;
    extent_UV(flag)=r_z*exp(j*az);
end
%}

n1=2*real(extent_UV)/min_spacing/sqrt(3);
n2=(imag(extent_UV)/min_spacing)+(n1/2);
n1=round(n1);
n2=round(n2);

n2=mod(n2,3*max_arm+1);
n1=mod(n1,3*max_arm+1);

Hextend_UV=n1*min_spacing*sqrt(3)/2+j*(n2*min_spacing-(n1*min_spacing/2));
Fov = 2*extent_UV*exp(1i*pi/6)/sqrt(3)/(3*max_arm+1)/min_spacing/min_spacing;
Fov=-1.*real(Fov)+j.*imag(Fov);

p2=2*imag(Fov)*min_spacing*(3*max_arm+1)/sqrt(3);
p1=real(Fov)*min_spacing*(3*max_arm+1)-p2/2;
p2=round(p2);
p1=round(p1);

p2=mod(p2,3*max_arm+1);
p1=mod(p1,3*max_arm+1);
Hextend_Fov=p1/min_spacing/(3*max_arm+1)+p2/(3*max_arm+1)/min_spacing/2+j*(p2*sqrt(3)/2/(3*max_arm+1)/min_spacing);
% figure
% plot(real(extent_UV),imag(extent_UV),'k+')
% figure
% plot(real(Hextend_Fov),imag(Hextend_Fov),'+');
% 
% figure
% plot(real(Fov),imag(Fov),'g+');