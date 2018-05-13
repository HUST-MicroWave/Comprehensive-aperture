function visibility = GetVFromCorrMat(corr_mat, norm_array_space, redundance_flag, baseline_flag)
%   语法：
%   visibility = GetVFromCorrMat(corr_mat, norm_array_space, redundance_flag)
% 
%   函数功能：
%   将仿真软件计算出来的可见度相关矩阵文件转换到matlab中的矩阵
%  
%   输入参数:
%   corr_mat            : 可见度相关矩阵
%   norm_array_space    : 天线归一化位置间隔,均相对于第一个天线
%   redundance_flag     : 是否作冗余平均，值为1时，作冗余平均，值为0时，不作冗余平均
%  
%
%   输出参数：
%   visibility            : 按基线集合对应的可见度
%   范例:
%   %求特定位置所有轮次所有基线的可见度输出
%   corr_mat = ConvertCorrMat('synthetic_aperture_visibility_0.dat');
%   baseline_inf.baseline_set =[1,2;5,6;2,3;1,3;5,7;3,4;5,8;4,6;2,4;1,4;4,7;3,5;4,8;3,6;2,5;1,5;3,7;1,6;3,8;2,7;1,7;2,8;1,8];
%   visibility = GetVFromCorrMat(corr_mat, baseline_inf.baseline_set);
%   temperature = FFTInverse(visibility);
%   save result.mat corr_mat visibility temperature
%   陈良兵，华中科技大学.
%   $版本号: 1.0 $  $Date: 2007/7/25 $

%判断自相关矩阵的大小是否与构成基线的通道数目相等
if(size(corr_mat,1) ~= size(norm_array_space,2))
    error('error occured in GetVFromCorrMat function: the size of correlation matrix is not equal to the number of channels consisting of baselines');
    return;
end

switch redundance_flag
    case 0 
        %从多个基线编号中取一组没有重复基线的基线组
        visibility = zeros(1,max(norm_array_space)+1);
        baseline_set = GetBaselineSet(norm_array_space,baseline_flag);   
        for i = 1:size(visibility,2)
            visibility(i) = corr_mat(baseline_set(i,1), baseline_set(i,2));
        end
        
    case 1
        %求各基线的可见度和以及各基线的冗余度
        visibility = zeros(1,max(norm_array_space)+1);
        redundance = zeros(1,max(norm_array_space)+1);
        for i = 1:size(corr_mat,1)
            for k = i:size(corr_mat,1)
                baseline_index = norm_array_space(k)-norm_array_space(i)+1;
                visibility(baseline_index) = visibility(baseline_index) + corr_mat(i,k);
                redundance(baseline_index) = redundance(baseline_index) + 1;
            end
        end
        
        %作冗余度平均
        visibility = visibility ./ redundance;
    case 2
        %求所有基线的可见度，但不作冗余平均
        ant_pair_baseline = GetAntPairBaseline(norm_array_space);%计算每对基线对应的天线编号，包含有某一个基线对应的多个天线编号对
        visibility = zeros(1,size(ant_pair_baseline,1));
        for i = 1:size(visibility,2)
            visibility(i)=corr_mat(ant_pair_baseline(i,2),ant_pair_baseline(i,3));
        end
    otherwise
        error('error occured in GetVFromCorrMat function: no selection corresponding to the redundance_flag');        
end