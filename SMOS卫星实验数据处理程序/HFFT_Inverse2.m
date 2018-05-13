function inv_T=HFFT_Inverse2(Visibility_sample_contain0,ext_UV,min_space,arm_ant_num)
%此函数为使用平移法进行HFFT计算；
% 华中科技大学
t0=clock;%计时开始；
d=min_space;
NT=3*arm_ant_num+1;

if size(ext_UV,2)==2
    ext_UV=ext_UV(:,1)+1i*ext_UV(:,2);
end
%% 将六边形平移后变成平行四边形；
n1=1+0*1i;
n2=n1*exp(1i*pi/3);
k1=2*(arm_ant_num+round(arm_ant_num/2))*d;
eps=0.00000001;
Hex_UV=zeros(length(ext_UV),2);
for k=1:length(ext_UV)
    angle_k=angle(ext_UV(k));
    if angle_k>=0-eps && angle_k<=pi/3+eps
        Hex_UV(k,1)=k;
        Hex_UV(k,2)=ext_UV(k);
    end
    if angle_k>pi/3+eps && angle_k<=pi || angle_k>=-pi && angle_k<=-pi+eps
        Hex_UV(k,1)=k;
        Hex_UV(k,2)=ext_UV(k)+k1*n1;
    end
    if angle_k>-pi+eps && angle_k<-2*pi/3-eps
        Hex_UV(k,1)=k;
        Hex_UV(k,2)=ext_UV(k)+k1*(n1+n2);
    end
    if angle_k>=-2*pi/3-eps && angle_k<0-eps
        Hex_UV(k,1)=k;
        Hex_UV(k,2)=ext_UV(k)+k1*n2;
    end 
end

Trans_matix=[1,-1/sqrt(3);0,2/sqrt(3)];
Hex_UV_t=Trans_matix*[real(Hex_UV(:,2))';imag(Hex_UV(:,2))'];
Hex_UV1=Hex_UV(:,2);

Hex_UV(:,2)=Hex_UV_t(1,:)+1i*Hex_UV_t(2,:);

visibility=zeros(NT,NT);
indexk=0;
Nk=zeros(NT^2,1);
for n1=1:NT
    for n2=1:NT
        indexk=indexk+1;
        Uv_real=(n2-1)*d;
        Uv_imag=(n1-1)*d;
        Uv_n1_n2=Uv_real+1i*Uv_imag;
        index=find(abs(Hex_UV(:,2)-Uv_n1_n2)<=eps);
        Nk(indexk)=Hex_UV(index,1);
        visibility(n1,n2)=Visibility_sample_contain0(Nk(indexk),3);
    end
end
 inv_Hex_T=(sqrt(3)*d^2*NT^2/2)*ifft2(visibility);


%% 获得矩形Fov
Fov1 = 2*ext_UV*exp(1i*pi/6)/sqrt(3)/(3*arm_ant_num+1)/min_space/min_space;
Fov_min_space=2/sqrt(3)/(3*arm_ant_num+1)/min_space;%获得视场最小间距；

%%对视场做平移并将矩形亮温值与像素坐标对应
m=size(inv_Hex_T,1);
Rec_Fov=zeros(m,m);
for k1=1:m
    for k2=1:m
        Rec_Fov(k1,k2)=(k1-1)*Fov_min_space*cos(pi/6)+1i*(-(k1-1)*Fov_min_space*sin(pi/6)+(k2-1)*Fov_min_space);
    end
end

n1=sqrt(3)/2-1i/2;
n2=0+1i;
kn=2*(arm_ant_num+round(arm_ant_num/2))*Fov_min_space;
eps=0.00000001;
Hex_Fov1=zeros(length(Fov1),2);
for k=1:length(Fov1)
    angle_k=angle(Fov1(k));
    Amp_k=abs(Fov1(k));
    if angle_k>=-pi/6-eps && angle_k<=pi/2+eps || Amp_k==0
        Hex_Fov1(k,1)=Fov1(k);
        [row,col]=find(abs(Rec_Fov-Hex_Fov1(k,1))<=eps);
        Hex_Fov1(k,2)=inv_Hex_T(row,col);
    end
    if angle_k>pi/2+eps && angle_k<=5*pi/6
        Hex_Fov1(k,1)=Fov1(k)+kn*n1;
        [row,col]=find(abs(Rec_Fov-Hex_Fov1(k,1))<=eps);
        Hex_Fov1(k,2)=inv_Hex_T(row,col);
    end
    if angle_k>5*pi/6+eps && angle_k<=pi ||(angle_k>=-pi+eps && angle_k<-pi/2-eps)
        Hex_Fov1(k,1)=Fov1(k)+kn*(n1+n2);
        [row,col]=find(abs(Rec_Fov-Hex_Fov1(k,1))<=eps);
        Hex_Fov1(k,2)=inv_Hex_T(row,col);
    end
    if angle_k>=-pi/2-eps && angle_k<-pi/6-eps
        Hex_Fov1(k,1)=Fov1(k)+kn*n2;
        [row,col]=find(abs(Rec_Fov-Hex_Fov1(k,1))<=eps);
        Hex_Fov1(k,2)=inv_Hex_T(row,col);
    end 
end
inv_T=Hex_Fov1(:,2);

continue_time=etime(clock,t0);%计时结束；
str=sprintf('HFFT2算法所用时间为：%f秒',continue_time);
disp(str)
%%
end




