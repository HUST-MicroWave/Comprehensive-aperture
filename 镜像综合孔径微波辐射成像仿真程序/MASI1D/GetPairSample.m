function cv_sample = GetPairSample(ant_pos)
% ���пƼ���ѧ
% ant_pos: �����ߵ�������ľ���
% cv_sample: ÿ�������γɵĲ���Ƶ�ʣ���СΪant_num*(ant_num-1)/2*2


%����Ƶ�ʣ�����ÿһ��������صõ��Ĳ���Ƶ��
ant_num = length(ant_pos); %���߸���
cv_sample = zeros(ant_num*(ant_num-1)/2, 2); %ÿһ���������������Ƶ�ʣ������������
index = 1;
for k = 1:ant_num
    for p = k+1:ant_num
       cv_sample(index,1) = ant_pos(p) - ant_pos(k);  %ÿһ���������������Ƶ�ʣ� Hj-Hi
       cv_sample(index,2) = ant_pos(p) + ant_pos(k);  % Hj+Hi
       index = index + 1;
    end
end