function cv_all = PadSample(unrpt_sample,cv,interpolation)
% ���пƼ���ѧ
% unrpt_sample: ����Ƶ�ʣ�����Ƶ��ȱʧ
% cv: unrpt_sample�и�Ƶ�ʶ�Ӧ��cosine visibilityֵ

absent_sample = IsMissingSample(unrpt_sample); %ȱʧ�Ĳ���Ƶ��
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
        

