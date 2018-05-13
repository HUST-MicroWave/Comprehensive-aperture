function temperature = FFTInverseZero(mean_visibility,zeros_num)
%   语法：
%   temperature = FFTInverse(mean_visibility)
% 
%   函数功能：
%   对每个位置的可见度输出作FFT反演得到亮温
%  
%   输入参数:
%   mean_visibility     :保存了所有位置、所有基线的平均可见度输出
% 
%   输出参数：
%   temperature         :包含了各个位置反演后的亮温结果
% 
%   范例:
%   %求特定位置所有轮次所有基线的可见度输出
%   position_inf.start_position = 1;
%   position_inf.start_position = 1;
%   sampling_inf.sampling_num = 8000 * 1000;
%   sampling_inf.start_cycle = 1;
%   sampling_inf.end_cycle = 12;
%   baseline_inf.start_baseline = 1;
%   baseline_inf.end_baseline = 23;
%   baseline_inf.baseline_set =[1,2;5,6;2,3;1,3;5,7;3,4;5,8;4,6;2,4;1,4;4,7;3,5;4,8;3,6;2,5;1,5;3,7;1,6;3,8;2,7;1,7;2,8;1,8];
%   AD_inf.bits = 8;
%   AD_inf.range = 5000;
%   channel_num = 8;
%   [mean_value1, mean_value2, variance1, variance2, visibility] = CalcVisibility(position_inf, sampling_inf, baseline_inf, AD_inf, channel_num);
%   mean_visibility = MeanVisibilityBaseCycle(visibility); 
%   temperature = FFTInverse(mean_visibility);
%   save result.mat mean_value1 mean_value2 variance1 variance2 visibility mean_visibility temperature    

%   陈良兵，华中科技大学.
%   $版本号: 1.0 $  $Date: 2007/7/01 $

position_num = size(mean_visibility, 1); %获取位置数目
baseline_num = size(mean_visibility, 2); %获取基线数目

v = zeros(position_num, baseline_num*2+zeros_num-1); %包含零基线的可见度
% v = zeros(1,baseline_num*2+zeros_num-1); %复共轭后的可见度
% temperature = zeros(baseline_num*2+zeros_num-1); %亮温

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          采用Matlab提供的IFFT算法的反演程序                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% T = zeros(2*N+1,1);   %%亮温 
% 
% T = ifft(V,2*N+1);                                                       
% buf = zeros(2*N+1,1);                                                   
% for k=1:N+1                                                            
%      buf(k+N) = T(k);                                                
% end                                                                    
% for k = 1:N                                                           
%      buf(k) = T(k+N+1);                                                
% end                                                                    
% T = buf;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          采用Matlab提供的IFFT算法的反演程序                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for baseline_index = 1:1:baseline_num
    v(baseline_index) = mean_visibility(baseline_index);
    end

    if(zeros_num>0)
    for baseline_index = baseline_num+1:1:baseline_num+zeros_num
    v(baseline_index)  = 0;
    end
    end
    %复共轭后的可见度
    for baseline_index = baseline_num+zeros_num+1:1:2*baseline_num+zeros_num-1
    v(baseline_index) = conj(v(2*baseline_num+1+zeros_num-baseline_index));
    end
    
   
    
    %对每一位置处的可见度输出作傅立叶变换求其温度
    temperature = fftshift(ifft(v(1,:),baseline_num*2+zeros_num-1));
