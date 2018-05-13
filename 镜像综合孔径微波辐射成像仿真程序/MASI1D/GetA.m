function A = GetA(unrpt_sample, cv_sample)
% 华中科技大学
% cv_sample: 每对天线形成的采样频率，大小为ant_num*(ant_num-1)/2*2
% unrpt_sample: cv_sample中的非重复采样频率
% A: Ax=b；联系采样频率与相关输出的矩阵

num_equation = size(cv_sample,1); %线性方程组方程数目
num_sample = length(unrpt_sample); %非重复的采样频率数目
A = zeros(num_equation,num_sample);
for k = 1:num_equation  
    index_sample = find(unrpt_sample == cv_sample(k,1));
    A(k,index_sample) = 1;
    index_sample = find(unrpt_sample == cv_sample(k,2));
    A(k,index_sample) = -1;
end