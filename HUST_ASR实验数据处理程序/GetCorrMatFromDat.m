%%%%%%%%%%%% 读取可见度数据文件，进行轮次平均后，按照位置排列相关矩阵
%%%%%%%%%%%% pos, cycle 都是从 0 开始编号
%%%%%%%%%%%% % 华中科技大学 熊祖彪，2008-10-10

function y = GetCorrMatFromDat(path, relativity_flag, channel_num, pos, cycle)

y = zeros(channel_num, channel_num, length(pos));
% 读取相关矩阵
for pk = 1 : length(pos)
    for ck = 1 : length(cycle)
        file_name = sprintf('%s\\SAIR_visibility_%d_%d.dat', path, pos(pk), cycle(ck));
%         y(:,:,pk) = y(:,:,pk) + ReadCorrMat(file_name) / length(cycle);
        corr_mat = ReadCorrMatH(file_name);
        if relativity_flag == 1
            power_vec = diag(corr_mat);
            corr_mat = corr_mat ./ sqrt(power_vec * power_vec') * corr_mat(1,1);
        end
        y(:,:,pk) = y(:,:,pk) + corr_mat / length(cycle);
    end
end
