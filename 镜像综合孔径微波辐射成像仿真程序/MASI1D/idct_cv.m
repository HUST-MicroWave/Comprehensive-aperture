function T = idct_cv(cv_all)
% 华中科技大学
% cv_all: 于弦采样值
% T: 反演亮温

sample_num = 2*length(cv_all)-1;
T = zeros(length(cv_all),1);
k = 2:length(cv_all);
k=k';
for p = 1:length(cv_all)
    T(p) = 1/sample_num*(cv_all(1)+2*sum(cv_all(2:length(cv_all)).*cos(2*pi*(p-1)*(k-1)/sample_num)));
end