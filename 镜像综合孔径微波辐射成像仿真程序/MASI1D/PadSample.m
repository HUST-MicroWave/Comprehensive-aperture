function cv_all = PadSample(unrpt_sample,cv,interpolation)
% 华中科技大学
% unrpt_sample: 采样频率，存在频率缺失
% cv: unrpt_sample中各频率对应的cosine visibility值

absent_sample = IsMissingSample(unrpt_sample); %缺失的采样频率
all_sample_temp = [unrpt_sample; absent_sample];
all_sample = sort(all_sample_temp);
cv_all = zeros(length(all_sample),1);

switch lower(interpolation)
    case 'zero'
        for k = 1:length(unrpt_sample)
            index = find(all_sample == unrpt_sample(k));
            cv_all(index) = cv(k);
        end
    otherwise
        cv_absent = interp1(unrpt_sample,cv,absent_sample,interpolation);
        cv_all_temp = [cv;cv_absent];
        for k = 1:length(cv_all)
            index = find(all_sample_temp == all_sample(k));
            cv_all(k) = cv_all_temp(index);
        end        
end
        

