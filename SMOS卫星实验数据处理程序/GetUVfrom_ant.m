function un_red_UV = GetUVfrom_ant(ant_pos)
%由天线位置获取所有非重复的采样频率；
%% 华中科技大学 $hukongyong$
channel_num=max(size(ant_pos));
UV_all=zeros(channel_num,channel_num,2);


% UV_complex=(UV(:,1,:)+1i*UV(:,2,:))*exp(-1i*pi/6);
% UV=[real(UV_complex) imag(UV_complex)];
for n1=1:size(ant_pos,2)
    for n2=1:size(ant_pos,2)
        UV_all(n1,n2,:)=(ant_pos(:,n1)-ant_pos(:,n2));
    end
end
UV_complex=UV_all(:,:,1)+1i*UV_all(:,:,2);
UV_complex1=reshape(UV_complex,[],1);
for k1=1:length(UV_complex1)
   for k2=k1+1:length(UV_complex1)
    if abs(real(UV_complex1(k2))-real(UV_complex1(k1)))<1.0e-10 &&  abs(imag(UV_complex1(k2))-imag(UV_complex1(k1)))<1.0e-10
       UV_complex1(k2)=0;
    end
   end
end
index1=find(UV_complex1~=0);
un_red_UV=[0;UV_complex1(index1)];%非冗余的采样频率；

un_red_UV=[real(un_red_UV),imag(un_red_UV)];
end