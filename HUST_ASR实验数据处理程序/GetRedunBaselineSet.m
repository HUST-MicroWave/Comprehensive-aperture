function [redun_count,redun_baseline_set] = GetRedunBaselineSet(norm_arrya_space)
%   �﷨��
%   baseline_set = GetRedunBaselineSet(norm_arrya_space)
% 
%   �������ܣ�
%   ��ȡû���ظ����ߵĻ��߼��ϣ��������ظ��Ļ���ȡ��һ�����߱����С����Ӧ�Ļ���
%  
%   �������:
%   norm_arrya_space    : ���߹�һ��λ�ü��,������ڵ�һ������
%
%   ���������
%   redun_baseline_set            : ����������ߵĻ��߼���
%   redun_count                   : �����ߵ�������Ŀ,��һ��Ϊ������߱�ţ��ڶ���Ϊ�û��߶�Ӧ��������Ŀ
%   ����:
%   %���ض�λ�������ִ����л��ߵĿɼ������
%  baseline_inf.norm_arrya_space =[0 1 2 5 10 15 26 37 48 59 70 76 82 88 89 90];%16���ߵ�Ԫ��
%  baseline_inf.redun_baseline_set = GetRedun_BaselineSet(baseline_inf.norm_arrya_space);
%   �����������пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2007/7/25 $

ant_pair_baseline = GetAntPairBaseline(norm_arrya_space);%����ÿ�Ի��߶�Ӧ�����߱�ţ�������ĳһ�����߶�Ӧ�Ķ�����߱�Ŷ�
%�Ӷ�����߱����ȡһ��û���ظ����ߵĻ�����
%redun_baseline_set = zeros(max(norm_arrya_space)+1,2);

%��������Ļ���

index = 1;
set_cell{index} = ant_pair_baseline(1,:);
for base_index = 2:size(ant_pair_baseline,1)-1
    temp = ant_pair_baseline(base_index,1);
    if temp == ant_pair_baseline(base_index-1,1) || temp == ant_pair_baseline(base_index+1,1)
        index = index +1;
        set_cell{index} = ant_pair_baseline(base_index,:);
    end
end
if ant_pair_baseline(size(ant_pair_baseline,1),1) == ant_pair_baseline(size(ant_pair_baseline,1)-1,1)
    set_cell{index+1} = ant_pair_baseline(size(ant_pair_baseline,1),:) ;
end

redun_baseline_set = zeros(length(set_cell),3);
for i = 1: length(set_cell)
   redun_baseline_set(i,:) = set_cell{i};
end

%�ҳ�������Ļ�������
count = 1;
temp  = redun_baseline_set(1,1);
for i = 1: size(redun_baseline_set,1)
    if temp ~= redun_baseline_set(i,1)
        count = count + 1;
        temp = redun_baseline_set(i,1);
    end
end
redun_count = zeros(2,count);
redun_count(1,1) = 1;
redun_count(2,1) = length(find(redun_baseline_set(:,1)==1));
for i = 2: count
    redun_count(1,i) = redun_baseline_set(sum(redun_count(2,1:(i-1)))+1,1);
    redun_count(2,i) = length(find(redun_baseline_set(:,1)==redun_count(1,i)));
end
