function visibility = GetVFromCorrMat(corr_mat, norm_array_space, redundance_flag, baseline_flag)
%   �﷨��
%   visibility = GetVFromCorrMat(corr_mat, norm_array_space, redundance_flag)
% 
%   �������ܣ�
%   �����������������Ŀɼ�����ؾ����ļ�ת����matlab�еľ���
%  
%   �������:
%   corr_mat            : �ɼ�����ؾ���
%   norm_array_space    : ���߹�һ��λ�ü��,������ڵ�һ������
%   redundance_flag     : �Ƿ�������ƽ����ֵΪ1ʱ��������ƽ����ֵΪ0ʱ����������ƽ��
%  
%
%   ���������
%   visibility            : �����߼��϶�Ӧ�Ŀɼ���
%   ����:
%   %���ض�λ�������ִ����л��ߵĿɼ������
%   corr_mat = ConvertCorrMat('synthetic_aperture_visibility_0.dat');
%   baseline_inf.baseline_set =[1,2;5,6;2,3;1,3;5,7;3,4;5,8;4,6;2,4;1,4;4,7;3,5;4,8;3,6;2,5;1,5;3,7;1,6;3,8;2,7;1,7;2,8;1,8];
%   visibility = GetVFromCorrMat(corr_mat, baseline_inf.baseline_set);
%   temperature = FFTInverse(visibility);
%   save result.mat corr_mat visibility temperature
%   �����������пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2007/7/25 $

%�ж�����ؾ���Ĵ�С�Ƿ��빹�ɻ��ߵ�ͨ����Ŀ���
if(size(corr_mat,1) ~= size(norm_array_space,2))
    error('error occured in GetVFromCorrMat function: the size of correlation matrix is not equal to the number of channels consisting of baselines');
    return;
end

switch redundance_flag
    case 0 
        %�Ӷ�����߱����ȡһ��û���ظ����ߵĻ�����
        visibility = zeros(1,max(norm_array_space)+1);
        baseline_set = GetBaselineSet(norm_array_space,baseline_flag);   
        for i = 1:size(visibility,2)
            visibility(i) = corr_mat(baseline_set(i,1), baseline_set(i,2));
        end
        
    case 1
        %������ߵĿɼ��Ⱥ��Լ������ߵ������
        visibility = zeros(1,max(norm_array_space)+1);
        redundance = zeros(1,max(norm_array_space)+1);
        for i = 1:size(corr_mat,1)
            for k = i:size(corr_mat,1)
                baseline_index = norm_array_space(k)-norm_array_space(i)+1;
                visibility(baseline_index) = visibility(baseline_index) + corr_mat(i,k);
                redundance(baseline_index) = redundance(baseline_index) + 1;
            end
        end
        
        %�������ƽ��
        visibility = visibility ./ redundance;
    case 2
        %�����л��ߵĿɼ��ȣ�����������ƽ��
        ant_pair_baseline = GetAntPairBaseline(norm_array_space);%����ÿ�Ի��߶�Ӧ�����߱�ţ�������ĳһ�����߶�Ӧ�Ķ�����߱�Ŷ�
        visibility = zeros(1,size(ant_pair_baseline,1));
        for i = 1:size(visibility,2)
            visibility(i)=corr_mat(ant_pair_baseline(i,2),ant_pair_baseline(i,3));
        end
    otherwise
        error('error occured in GetVFromCorrMat function: no selection corresponding to the redundance_flag');        
end