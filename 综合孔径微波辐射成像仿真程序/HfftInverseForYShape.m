function [Tfig Fov extent_UV UVexplane] = HfftInverseForYShape(self_correlation_matrix,min_spacing,ant_pos,max_arm)

%����˵��
% �������ã�������ؾ������·ֲ�
% self_correlation_matrix ����ؾ���
% min_spacing ��С��࣬�Բ���Ϊ��λ
% ant_pos ����λ�ã����Ϊ��תY��������3ά���󣬵�3ά ant_pos(:,:,k) ��ʾ��k����ת�õ�������λ�á��粻��תΪ��ͨY����
% max_arm ����Ǹ��۵ĳ���,Ϊ�˻��������ʱ������е㶼������ȡ���ı���Ϊ�ο����ò�������ȡ�ĺܴ󣬵�Ч�ڲ�0�ķ����㷨
% ���пƼ���ѧ

% ��ȡY�����UVƽ����������ӳ�
[extent_UV,Hextend_UV,Fov,Hextend_Fov]= UVHeCellofYShape(min_spacing,max_arm);
% ��ʼ��UVƽ���Ŀɼ���
UVplane = zeros(size(extent_UV));
UVexplane=zeros(3*max_arm+1,3*max_arm+1);
% ��ʼ��UVƽ��Ŀɼ��ȼ���
counter = UVplane; 
% ��ʼ���ɼ���
visibility = UVplane;

% ���ڱȽϵ�С��
small_num = 10^(-2);
% �õ�uvƽ���Ŀɼ��ȷֲ�
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

% �õ����·ֲ�
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


% ��ͼ


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
title('Y������ͼ��');
xlabel('l');
ylabel('m');
% axis square