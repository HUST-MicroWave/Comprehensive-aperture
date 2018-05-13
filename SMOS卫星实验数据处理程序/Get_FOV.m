% 华中科技大学
arm_ant_num=21;
d=0.875;
NT=3*arm_ant_num;
n1=-NT:NT-1;
n2=-NT:NT-1;
Fov=zeros(length(n1)*length(n2),2);
start1=1;
end1=length(n2);
for k1=1:length(n1)
    nn=n1(k1)*ones(length(n2),1);
        Fov(start1:end1,:)=[(nn+2*n2')./(sqrt(3)*NT*d),nn./(NT*d)];
        start1=end1+1;
        end1=end1+length(n2);
end
theta=pi/2;
Fov=Fov*[cos(theta) -sin(theta);sin(theta) cos(theta)];
deltakesi=Fov(2,2)-Fov(1,2);
R=sqrt(3)*(arm_ant_num+11)*deltakesi/2;
phi=0:pi/3:12*pi/6;
Fov_hex_line=[R*cos(phi);R*sin(phi)];
in = inpolygon(Fov(:,1),Fov(:,2),Fov_hex_line(1,:)',Fov_hex_line(2,:)');
index=find(in==1);
Fov_hex=Fov(index,:);
figure(1)
plot(Fov(:,1),Fov(:,2),'*'),hold on
plot(Fov_hex_line(1,:),Fov_hex_line(2,:),'g-','LineWidth',3);

figure(2)
plot(Fov_hex(:,1),Fov_hex(:,2),'*'),hold on
axis([-0.6 0.6 -0.6 0.6]);