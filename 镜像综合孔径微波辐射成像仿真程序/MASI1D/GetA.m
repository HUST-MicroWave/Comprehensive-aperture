function A = GetA(unrpt_sample, cv_sample)
% ���пƼ���ѧ
% cv_sample: ÿ�������γɵĲ���Ƶ�ʣ���СΪant_num*(ant_num-1)/2*2
% unrpt_sample: cv_sample�еķ��ظ�����Ƶ��
% A: Ax=b����ϵ����Ƶ�����������ľ���

num_equation = size(cv_sample,1); %���Է����鷽����Ŀ
num_sample = length(unrpt_sample); %���ظ��Ĳ���Ƶ����Ŀ
A = zeros(num_equation,num_sample);
for k = 1:num_equation  
    index_sample = find(unrpt_sample == cv_sample(k,1));
    A(k,index_sample) = 1;
    index_sample = find(unrpt_sample == cv_sample(k,2));
    A(k,index_sample) = -1;
end