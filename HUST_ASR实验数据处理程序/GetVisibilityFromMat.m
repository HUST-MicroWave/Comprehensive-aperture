function y = GetVisibilityFromMat(corr_mats, baseline, norm_array_space)
%%%%%%%%%%%% 从相关矩阵中按照给定的基线方式生成可见度矩阵
%%%%%%%%%%%% % 华中科技大学 熊祖彪，2008-10-11
pos_num = size(corr_mats, 3);
channel_num = length(norm_array_space);
switch lower(baseline)
    case 'all'
        y = zeros(channel_num*(channel_num-1)/2, pos_num);
        for pos = 1 : pos_num
            y(:, pos) = GetVFromCorrMat(corr_mats(:,:,pos), norm_array_space, 2, 0);
        end
    case 'small'
        y = zeros(norm_array_space(channel_num)+1, pos_num);
        for pos = 1 : pos_num
            y(:, pos) = GetVFromCorrMat(corr_mats(:,:,pos), norm_array_space, 0, 0);
        end
    case 'great'
        y = zeros(norm_array_space(channel_num)+1, pos_num);
        for pos = 1 : pos_num
            y(:, pos) = GetVFromCorrMat(corr_mats(:,:,pos), norm_array_space, 0, 1);
        end
    case 'redun'
        y = zeros(norm_array_space(channel_num)+1, pos_num);
        for pos = 1 : pos_num
            y(:, pos) = GetVFromCorrMat(corr_mats(:,:,pos), norm_array_space, 1, 0);
        end
end
