function [T Fov] = IAMInverseForYShape(rot_self_correlation_matrix,rotnum,min_spacing,rot_ant_pos,max_arm)

%����˵��
% �������ã�������ؾ������·ֲ�
% rot_self_correlation_matrix ����ؾ������Ϊ��תY��������3ά���󣬵�3ά rot_self_correlation_matrix(:,:,k) ��ʾ��k����ת�õ�������ؾ����粻��תΪ��ͨY����
% rotnum ��ת�������粻��תΪ0
% min_spacing ��С��࣬�Բ���Ϊ��λ
% rot_ant_pos ����λ�ã����Ϊ��תY��������3ά���󣬵�3ά rot_ant_pos(:,:,k) ��ʾ��k����ת�õ�������λ�á��粻��תΪ��ͨY����
% max_arm ����Ǹ��۵ĳ���,Ϊ�˻��������ʱ������е㶼������ȡ���ı���Ϊ�ο����ò�������ȡ�ĺܴ󣬵�Ч�ڲ�0�ķ����㷨
% ���пƼ���ѧ

% ��ȡY�����UVƽ����������ӳ�
[extent_UV Fov] = GenerateUVCellofYShape(min_spacing,max_arm);
% ��ʼ��UVƽ���Ŀɼ���
UVplane = zeros(size(extent_UV));
% ��ʼ��UVƽ��Ŀɼ��ȼ���
counter = UVplane; 
% ��ʼ���ɼ���
visibility = UVplane;

% ���ڱȽϵ�С��
small_num = 10^(-2);
% �õ�uvƽ���Ŀɼ��ȷֲ�
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


% �õ�uvƽ���Ŀɼ�������ƽ��
for k = 1:length(counter)
    if 0 ~= counter(k)
        visibility(k) = UVplane(k)/counter(k);
    end
end

% �õ����·ֲ�
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

% ��ͼ
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
title('Y������ͼ��');
xlabel('l');
ylabel('m');
% axis square

    