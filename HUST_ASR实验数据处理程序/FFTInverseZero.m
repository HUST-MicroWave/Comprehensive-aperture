function temperature = FFTInverseZero(mean_visibility,zeros_num)
%   �﷨��
%   temperature = FFTInverse(mean_visibility)
% 
%   �������ܣ�
%   ��ÿ��λ�õĿɼ��������FFT���ݵõ�����
%  
%   �������:
%   mean_visibility     :����������λ�á����л��ߵ�ƽ���ɼ������
% 
%   ���������
%   temperature         :�����˸���λ�÷��ݺ�����½��
% 
%   ����:
%   %���ض�λ�������ִ����л��ߵĿɼ������
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

%   �����������пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2007/7/01 $

position_num = size(mean_visibility, 1); %��ȡλ����Ŀ
baseline_num = size(mean_visibility, 2); %��ȡ������Ŀ

v = zeros(position_num, baseline_num*2+zeros_num-1); %��������ߵĿɼ���
% v = zeros(1,baseline_num*2+zeros_num-1); %�������Ŀɼ���
% temperature = zeros(baseline_num*2+zeros_num-1); %����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          ����Matlab�ṩ��IFFT�㷨�ķ��ݳ���                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% T = zeros(2*N+1,1);   %%���� 
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
%          ����Matlab�ṩ��IFFT�㷨�ķ��ݳ���                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for baseline_index = 1:1:baseline_num
    v(baseline_index) = mean_visibility(baseline_index);
    end

    if(zeros_num>0)
    for baseline_index = baseline_num+1:1:baseline_num+zeros_num
    v(baseline_index)  = 0;
    end
    end
    %�������Ŀɼ���
    for baseline_index = baseline_num+zeros_num+1:1:2*baseline_num+zeros_num-1
    v(baseline_index) = conj(v(2*baseline_num+1+zeros_num-baseline_index));
    end
    
   
    
    %��ÿһλ�ô��Ŀɼ������������Ҷ�任�����¶�
    temperature = fftshift(ifft(v(1,:),baseline_num*2+zeros_num-1));
