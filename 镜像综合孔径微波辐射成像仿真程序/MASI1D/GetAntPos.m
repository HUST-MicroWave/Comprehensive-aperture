function ant_pos = GetAntPos(height, ant_spacing,delta_u)
% ���пƼ���ѧ
% height: ���е�������ľ��룬������һ��ֵ
% ant_spacing: ���߼�࣬������һ��
% delta_u: ��С�����������һ��
% ant_pos: �����ߵ�������ľ���

%�������м���λ��
ant_pos_absolute = zeros(length(ant_spacing),1); %���߾���λ�ã�������һ��
for k = 1:length(ant_spacing)
    ant_pos_relative = sum(ant_spacing(1:k))* delta_u;
    ant_pos(k) = ant_pos_relative + height;
end