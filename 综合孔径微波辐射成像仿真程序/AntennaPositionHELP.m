function AntennaPositionHELP()

% �������ͷ�Ϊ���¼��ࣺ
% (1)
% 'mrla' ��С����ֱ����Ŀǰ֧������Ԫ���������
% (2)
% 'ula' ����ֱ����
% (3)
% 'Y_shape(y_shape)' ����(��ͨ)Y��ƽ����
% (4)
% 'T_shape' T��ƽ����
% (5)
% 'O_shape' Բ��ƽ����
% (6)
% 'cross_shape' Բ��ƽ����
% (7)
% '[0 1 4 7]' ֱ�߹�����λ��Ϊ�ֶ������ֵ
% (8)
% '[0 1 4 7;
% 0 1 2 3]' ƽ�������λ��Ϊ�ֶ������ֵ����һ�е�kԪ�ش����k����Ԫx��λ�ã��ڶ��е�kԪ�ش����k����Ԫy��λ��
% ���пƼ���ѧ

% �鿴�����Ų�����ִ����������֮���������д��룺
figure()
min_spacing = SRM_param.norm_min_spacing;
ant_pos = SRM_param.norm_ant_pos;
if size(ant_pos,1) == 1
    ant_pos(2,:) = 0;
end
plot(min_spacing*ant_pos(1,:),min_spacing*ant_pos(2,:),'o');
title('��������λ��')
xlabel('��λ������')
ylabel('��λ������')

  