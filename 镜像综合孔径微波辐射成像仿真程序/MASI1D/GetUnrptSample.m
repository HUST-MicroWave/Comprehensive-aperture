function unrpt_sample = GetUnrptSample(cv_sample)
% 华中科技大学
% cv_sample: 每对天线形成的采样频率，大小为ant_num*(ant_num-1)/2*2
% unrpt_sample: cv_sample中的非重复采样频率

sorted_sample = sort([cv_sample(:,1);cv_sample(:,2)]); %对采样频率按从小到大排序
%去掉sorted_sample中的重复采样频率
index = 1;
unrpt_sample(1) = sorted_sample(1);%没有重复的采样频率
for k = 2:length(sorted_sample)
    if sorted_sample(k) ~= sorted_sample(k-1)
        index = index+1;
        unrpt_sample(index) = sorted_sample(k);
    end
end

unrpt_sample = unrpt_sample';