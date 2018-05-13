function [error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);

%   语法：
%   [error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);
% 
%   函数功能：
%   通道误差产生
%  
%   输入参数:
% channel_info.error_amp_type 通道幅度误差类型
% channel_info.error_amp_quantity 通道幅度误差大小
% channel_info.error_Iphase_type 通道同相相位误差类型
% channel_info.error_Iphase_quantity 通道同相相位误差大小
% channel_info.error_Qphase_type 通道正交相位误差类型
% channel_info.error_Qphase_quantity 通道正交相位误差大小
% antenna_num 天线个数
% 
%   范例:
% channel_info.error_amp_type = 'normal';
% channel_info.error_amp_quantity = 0;
% channel_info.error_Iphase_type = 'normal';
% channel_info.error_Iphase_quantity = 0;
% channel_info.error_Qphase_type = 'normal';
% channel_info.error_Qphase_quantity = 0;
% antenna_num = 12;
% [error_amp,error_Iphase,error_Qphase] = SRMChannelErrorGenerate(antenna_num,channel_info);
% 
%   靳榕,华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $


%%%%%%%%%%%%%%%%%%通道幅度误差%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(channel_info.error_amp_type)
    case 'normal'
       error_amp  = ones(1,antenna_num) + channel_info.error_amp_quantity*randn(1,antenna_num);
    case 'constant'
       error_amp  = ones(1,antenna_num) + channel_info.error_amp_quantity;
    case 'uniform'
       error_amp  = (channel_info.error_amp_quantity(2)-channel_info.error_amp_quantity(1))*rand(1,antenna_num) + channel_info.error_amp_quantity(1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%通道同相相位误差%%%%%%%%%%%%%%%%%%%%%%%%%
switch lower(channel_info.error_Iphase_type)
    case 'normal'
       error_Iphase  = zeros(1,antenna_num) + channel_info.error_Iphase_quantity*randn(1,antenna_num);
    case 'constant'
       error_Iphase  = zeros(1,antenna_num) + channel_info.error_Iphase_quantity;
    case 'uniform'
       error_Iphase  = (channel_info.error_Iphase_quantity(2)-channel_info.error_Iphase_quantity(1))*rand(1,antenna_num) + channel_info.error_Iphase_quantity(1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%通道正交相位误差%%%%%%%%%%%%%%%%%%%%%%%%%
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