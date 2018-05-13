function [redun_count,redun_baseline_set] = GetRedunBaselineSet(norm_arrya_space)
%   语法：
%   baseline_set = GetRedunBaselineSet(norm_arrya_space)
% 
%   函数功能：
%   获取没有重复基线的基线集合，对于有重复的基线取第一个天线编号最小所对应的基线
%  
%   输入参数:
%   norm_arrya_space    : 天线归一化位置间隔,均相对于第一个天线
%
%   输出参数：
%   redun_baseline_set            : 所有冗余基线的基线集合
%   redun_count                   : 各基线的冗余数目,第一行为冗余基线编号，第二行为该基线对应的冗余数目
%   范例:
%   %求特定位置所有轮次所有基线的可见度输出
%  baseline_inf.norm_arrya_space =[0 1 2 5 10 15 26 37 48 59 70 76 82 88 89 90];%16天线单元阵
%  baseline_inf.redun_baseline_set = GetRedun_BaselineSet(baseline_inf.norm_arrya_space);
%   陈良兵，华中科技大学.
%   $版本号: 1.0 $  $Date: 2007/7/25 $

ant_pair_baseline = GetAntPairBaseline(norm_arrya_space);%计算每对基线对应的天线编号，包含有某一个基线对应的多个天线编号对
%从多个基线编号中取一组没有重复基线的基线组
%redun_baseline_set = zeros(max(norm_arrya_space)+1,2);

%对有冗余的基线

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

%找出有冗余的基线总数
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
