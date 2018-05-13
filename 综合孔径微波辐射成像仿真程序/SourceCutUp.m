function T_dist = SourceCutUp(place_start,place_end,scope,power)

% չԴ�зֺ���������Ԥ����Ƶ����񣬽��仮��Ϊ�����Դ
% place_start չԴ��ʼλ��
% place_end   չԴ��ֹλ��
% scope       Ԥ������
% power       չԴ������(K)

% ���Ԥ������ĵ�Ԫ���
delta = scope(2)-scope(1);
% ��ʼ�����·ֲ�
T_dist = [;];

for k = 1:length(scope)
    % �ж��������Ƿ���Դ����
    if (scope(k)>=place_start)&&(scope(k)<=place_end)
        %�������Դ����
        % ��ȡ�õ����ʼλ��
        delta_start = max(scope(k)-delta/2,place_start);
        delta_end = min(scope(k)+delta/2,place_end);
        % ��øõ��������Ա����������
        area = delta_end - delta_start;
        T_dist_k = [power*area/delta;asind(scope(k))];
        T_dist = [T_dist T_dist_k];
    end
end
        