function [visibility,extent_UV,Fov] = R2VY(self_correlation_matrix,ant_pos,min_spacing,max_arm)

% Y��������ؾ��󵽿ɼ���ת��
% ���пƼ���ѧ

% ��ȡY�����UVƽ����������ӳ�
[extent_UV Fov] = GenerateUVCellofYShape(min_spacing,max_arm);
% [extent_UV,Hextend_UV,Fov,Hextend_Fov]= UVHeCellofYShape(min_spacing,max_arm);
% ��ʼ��UVƽ���Ŀɼ���
UVplane = zeros(size(extent_UV));
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
        counter(position) = counter(position)+1;
        UVplane(position) = UVplane(position)+self_correlation_matrix(q,p);
    end
end

% �õ�uvƽ���Ŀɼ�������ƽ��
for k = 1:length(counter)
    if 0 ~= counter(k)
        visibility(k) = UVplane(k)/counter(k);
    end
end
