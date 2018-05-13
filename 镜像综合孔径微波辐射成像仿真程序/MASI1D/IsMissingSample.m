function absent_sample = IsMissingSample(unrpt_sample)
% 华中科技大学
% unrpt_sample: cv_sample中的非重复采样频率
% absent_sample: unrpt_sample中缺失的采样频率

min_sapmle = min(unrpt_sample); %最小采样频率
max_sample = max(unrpt_sample); %最大采样频率
delta_sample = unrpt_sample(2)-unrpt_sample(1); %采样频率间隔
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