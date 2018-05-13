function [Fov,delta] = STMResolution(min_spacing,ant_pos)

% �������еķֱ��ʵ�Ԫ
% ���򷵻طֱ��ʵ�Ԫ������ӳ���Χ
% ���пƼ���ѧ
if (size(ant_pos,1)==1)
    % һά����
    lastant = ant_pos(length(ant_pos));  %���һ�����ߵ�λ��
    firstant = ant_pos(1);               %��һ�����ߵ�λ��
    Tnum = 2*(lastant-firstant)+1;       %����ͼ��ĵ���
    
    Fov = [-1 1]/2/min_spacing;          %�ӳ���Χ
    delta = (Fov(2)-Fov(1))/Tnum;        %�ֱ��ʵ�Ԫ���
    
else
    % ��ά����
      if trace([mod(ant_pos,1)*mod(ant_pos,1)'])<=0.0001
        % ��ͨ��ά��
        lastantx = max(ant_pos(1,:));                                     %���һ�����ߵ�λ��(x����)
        lastanty = max(ant_pos(2,:));                                     %���һ�����ߵ�λ��(y����)
        firstantx = min(ant_pos(1,:));                                    %��һ�����ߵ�λ��(x����)
        firstanty = min(ant_pos(2,:));                                    %��һ�����ߵ�λ��(y����)
        Tnum = [2*(lastantx-firstantx)+1 2*(lastanty-firstanty)+1];       %����ͼ��ĵ���

        Fov = [[-1 1]/2/min_spacing;[-1 1]/2/min_spacing];                %�ӳ���Χ
        delta = [(Fov(1,2)-Fov(1,1))/Tnum(1);(Fov(2,2)-Fov(2,1))/Tnum(2)];%�ֱ��ʵ�Ԫ���
    else
        % Y����
        min_spacing = [sqrt(3)/2 1/2]*min_spacing;
        lastantx = max(ant_pos(1,:));                                     %���һ�����ߵ�λ��(x����)
        lastanty = max(ant_pos(2,:));                                     %���һ�����ߵ�λ��(y����)
        firstantx = min(ant_pos(1,:));                                    %��һ�����ߵ�λ��(x����)
        firstanty = min(ant_pos(2,:));                                    %��һ�����ߵ�λ��(y����)
        Tnum = [2*(lastantx-firstantx)+1 2*(lastanty-firstanty)+1]./[sqrt(3)/2 1/2];       %����ͼ��ĵ���
        Tnum = floor(Tnum);
        Fov = [[-1 1]/2/min_spacing(1);[-1 1]/2/min_spacing(2)];                %�ӳ���Χ
        delta = [(Fov(1,2)-Fov(1,1))/Tnum(1);(Fov(2,2)-Fov(2,1))/Tnum(2)];%�ֱ��ʵ�Ԫ���
    end
    
end