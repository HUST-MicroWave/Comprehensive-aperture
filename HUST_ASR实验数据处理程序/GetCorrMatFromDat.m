%%%%%%%%%%%% ��ȡ�ɼ��������ļ��������ִ�ƽ���󣬰���λ��������ؾ���
%%%%%%%%%%%% pos, cycle ���Ǵ� 0 ��ʼ���
%%%%%%%%%%%% % ���пƼ���ѧ ����룬2008-10-10

function y = GetCorrMatFromDat(path, relativity_flag, channel_num, pos, cycle)

y = zeros(channel_num, channel_num, length(pos));
% ��ȡ��ؾ���
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
