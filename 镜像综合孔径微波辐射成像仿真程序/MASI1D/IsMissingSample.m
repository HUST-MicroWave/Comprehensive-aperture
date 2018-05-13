function absent_sample = IsMissingSample(unrpt_sample)
% ���пƼ���ѧ
% unrpt_sample: cv_sample�еķ��ظ�����Ƶ��
% absent_sample: unrpt_sample��ȱʧ�Ĳ���Ƶ��

min_sapmle = min(unrpt_sample); %��С����Ƶ��
max_sample = max(unrpt_sample); %������Ƶ��
delta_sample = unrpt_sample(2)-unrpt_sample(1); %����Ƶ�ʼ��
index = 1;
ref_sample = unrpt_sample(1);

flag = 0;
for k = 2:length(unrpt_sample)
    while unrpt_sample(k) ~= (ref_sample + delta_sample)
        absent_sample(index) = ref_sample + delta_sample;
        index = index + 1;
        ref_sample = ref_sample + delta_sample;
        flag = 1;
    end
    ref_sample = unrpt_sample(k);
end
if flag == 0
    absent_sample = [];
    disp('no sampling frequency missed');
end
 
absent_sample = absent_sample';