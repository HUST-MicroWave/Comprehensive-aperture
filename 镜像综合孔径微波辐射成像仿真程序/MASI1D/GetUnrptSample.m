function unrpt_sample = GetUnrptSample(cv_sample)
% ���пƼ���ѧ
% cv_sample: ÿ�������γɵĲ���Ƶ�ʣ���СΪant_num*(ant_num-1)/2*2
% unrpt_sample: cv_sample�еķ��ظ�����Ƶ��

sorted_sample = sort([cv_sample(:,1);cv_sample(:,2)]); %�Բ���Ƶ�ʰ���С��������
%ȥ��sorted_sample�е��ظ�����Ƶ��
index = 1;
unrpt_sample(1) = sorted_sample(1);%û���ظ��Ĳ���Ƶ��
for k = 2:length(sorted_sample)
    if sorted_sample(k) ~= sorted_sample(k-1)
        index = index+1;
        unrpt_sample(index) = sorted_sample(k);
    end
end

unrpt_sample = unrpt_sample';