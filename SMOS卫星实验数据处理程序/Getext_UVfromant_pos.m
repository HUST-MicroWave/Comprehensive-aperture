function ext_UV = Getext_UVfromant_pos( arm_ant_num,ext_zero_num )
%得到补零后的UV平面；
%% 华中科技大学  $ hukongyong $
%  Detailed explanation goes here
% lambda=0.2121;
% NN=15;%对补零后的UV平面继续补零
NN=0;
ext_zero_num=0;
d=0.875;
NT=3*arm_ant_num;
n1=(-NT:NT-1);
n2=(-NT:NT-1);
UV_plane=zeros(length(n1)*length(n2),2);
start1=1;
end1=length(n2);
for k1=1:length(n1)
    nn=n1(k1)*ones(length(n2),1);
        UV_plane(start1:end1,:)=[sqrt(3)*d*nn/2,d*(-nn+2*n2')/2];
        start1=end1+1;
        end1=end1+length(n2);
end
 UV_plane=UV_plane*[cos(pi/2) -sin(pi/2);sin(pi/2) cos(pi/2)];
r=2*(arm_ant_num+round(arm_ant_num/2)+NN/2)*d/sqrt(3);
% % ext_UV1=zeros(2101,2);
% ext_UV2=zeros(2058,2);
index1=1;
index2=1;
tho=(arm_ant_num+round(arm_ant_num/2)+NN/2)*d;
eps=1e-10;
for k=1:size(UV_plane,1)
      if UV_plane(k,1)>=-tho && UV_plane(k,1)<=eps && UV_plane(k,2)<=UV_plane(k,1)/sqrt(3)+r && UV_plane(k,2)>=-UV_plane(k,1)/sqrt(3)-r
         ext_UV1(index1,:)=UV_plane(k,:);
         index1=index1+1;
      end
%采用对称的补零方式：     
%        if UV_plane(k,1)<=tho &&  UV_plane(k,1)>eps && UV_plane(k,2)<=-UV_plane(k,1)/sqrt(3)+r && UV_plane(k,2)>=UV_plane(k,1)/sqrt(3)-r
%             ext_UV2(index2,:)=UV_plane(k,:);
%             index2=index2+1;
%       end
%       
%如果采用不对称的补零方式（刚好构成二维平面的一个周期）：
      if UV_plane(k,1)<tho &&  UV_plane(k,1)>eps && UV_plane(k,2)<-UV_plane(k,1)/sqrt(3)+r-eps && UV_plane(k,2)>UV_plane(k,1)/sqrt(3)-r+eps
            ext_UV2(index2,:)=UV_plane(k,:);
            index2=index2+1;
      end
end
ext_UV=[ext_UV1;ext_UV2];
% plot(ext_UV(:,1),ext_UV(:,2),'*');
end


