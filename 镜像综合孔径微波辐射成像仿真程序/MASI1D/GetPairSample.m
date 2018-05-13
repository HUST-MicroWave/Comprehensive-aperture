function cv_sample = GetPairSample(ant_pos)
% 华中科技大学
% ant_pos: 各天线到反射面的距离
% cv_sample: 每对天线形成的采样频率，大小为ant_num*(ant_num-1)/2*2


%采样频率，计算每一对天线相关得到的采样频率
ant_num = length(ant_pos); %天线个数
cv_sample = zeros(ant_num*(ant_num-1)/2, 2); %每一对相关有两个采样频率，不考虑自相关
index = 1;
for k = 1:ant_num
    for p = k+1:ant_num
       cv_sample(index,1) = ant_pos(p) - ant_pos(k);  %每一对相关有两个采样频率， Hj-Hi
       cv_sample(index,2) = ant_pos(p) + ant_pos(k);  % Hj+Hi
       index = index + 1;
    end
end