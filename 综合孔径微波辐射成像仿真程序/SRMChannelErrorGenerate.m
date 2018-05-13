function [error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);

%   �﷨��
%   [error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);
% 
%   �������ܣ�
%   ͨ��������
%  
%   �������:
% channel_info.error_amp_type ͨ�������������
% channel_info.error_amp_quantity ͨ����������С
% channel_info.error_Iphase_type ͨ��ͬ����λ�������
% channel_info.error_Iphase_quantity ͨ��ͬ����λ����С
% channel_info.error_Qphase_type ͨ��������λ�������
% channel_info.error_Qphase_quantity ͨ��������λ����С
% antenna_num ���߸���
% 
%   ����:
% channel_info.error_amp_type = 'normal';
% channel_info.error_amp_quantity = 0;
% channel_info.error_Iphase_type = 'normal';
% channel_info.error_Iphase_quantity = 0;
% channel_info.error_Qphase_type = 'normal';
% channel_info.error_Qphase_quantity = 0;
% antenna_num = 12;
% [error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);
% 
%   ����,���пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $


%%%%%%%%%%%%%%%%%%ͨ���������%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(channel_info.error_amp_type)
    case 'normal'
       error_amp  = ones(1,antenna_num) + channel_info.error_amp_quantity*randn(1,antenna_num);
    case 'constant'
       error_amp  = ones(1,antenna_num) + channel_info.error_amp_quantity;
    case 'uniform'
       error_amp  = (channel_info.error_amp_quantity(2)-channel_info.error_amp_quantity(1))*rand(1,antenna_num) + channel_info.error_amp_quantity(1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%ͨ��ͬ����λ���%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(channel_info.error_Iphase_type)
    case 'normal'
       error_Iphase  = zeros(1,antenna_num) + channel_info.error_Iphase_quantity*randn(1,antenna_num);
    case 'constant'
       error_Iphase  = zeros(1,antenna_num) + channel_info.error_Iphase_quantity;
    case 'uniform'
       error_Iphase  = (channel_info.error_Iphase_quantity(2)-channel_info.error_Iphase_quantity(1))*rand(1,antenna_num) + channel_info.error_Iphase_quantity(1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%ͨ��������λ���%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(channel_info.error_Qphase_type)
    case 'normal'
       error_Qphase  = zeros(antenna_num,antenna_num) + channel_info.error_Qphase_quantity*randn(antenna_num,antenna_num);
    case 'constant'
       error_Qphase  = zeros(antenna_num,antenna_num) + channel_info.error_Qphase_quantity;
    case 'uniform'
       error_Qphase  = (channel_info.error_Qphase_quantity(2)-channel_info.error_Qphase_quantity(1))*rand(antenna_num,antenna_num) + channel_info.error_Qphase_quantity(1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error_Qphase = triu(error_Qphase,1)-triu(error_Qphase,1)';