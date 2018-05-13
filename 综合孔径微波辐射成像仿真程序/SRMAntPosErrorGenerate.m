function real_ant_pos = SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity,ant_pos_error_type);

%   语法：
%   real_ant_pos =  SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity,ant_pos_error_type);
% 
%   函数功能：
%   基线位置添加误差
%  
%   输入参数:
%   norm_ant_pos     ：基线排列形式，分2种情况
%         输入矩阵的行数为1      ：一维直线阵列
%         输入矩阵的行数为2      ：平面阵列
%   norm_min_spacing     ：最小基线排列间隔，单位为波长         
%   ant_pos_error_quantity  ：基线排列误差的大小
%   ant_pos_error_type  ：基线排列误差类型
%   输出参数：
%   real_ant_pos  :添加误差后的基线排列
% 
%   范例:
%   norm_min_spacing = 1/2;
%   norm_ant_pos = [0 2 5 6]; 
%   ant_pos_error_quantity =0.1;
%   real_ant_pos =SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity);
% 
%   靳榕,华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $

%判断是一维阵列还是平面阵列
if(isvector(norm_ant_pos) == 1)
    flag = 1; %一维阵列
else
    flag = 0; %平面阵列
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%一维阵列的情况%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag ==1)
    % 得到新的基线排列：
    switch lower(ant_pos_error_type)
        case 'normal'    %误差呈正太分布
            real_ant_pos = norm_ant_pos + norm_min_spacing*ant_pos_error_quantity*randn(size(norm_ant_pos));%误差产生
        case 'constant'  %误差呈常数分布
            real_ant_pos = norm_ant_pos + ant_pos_error_quantity;
        case 'uniform'   %误差呈均匀分布
            real_ant_pos = norm_ant_pos + ((ant_pos_error_quantity(2)-ant_pos_error_quantity(1))*rand(size(norm_ant_pos))+ant_pos_error_quantity(1));
        otherwise        %误差为手动输入
            real_ant_pos = norm_ant_pos + ant_pos_error_type;    
    end
    real_ant_pos = sort(real_ant_pos); %防止误差过大时产生如[0 2 1 3 4]等不合理排列
    real_ant_pos = real_ant_pos - real_ant_pos(1);%使第一个基线始终为0，作为参考点
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%平面阵列的情况%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag ==0)
    % 得到新的基线排列：
    switch lower(ant_pos_error_type)
        case 'normal'    %误差呈正太分布
            real_ant_pos = norm_ant_pos + norm_min_spacing*ant_pos_error_quantity*randn(size(norm_ant_pos));%误差产生
        case 'constant'  %误差呈常数分布
            real_ant_pos = norm_ant_pos + ant_pos_error_quantity;
        case 'uniform'   %误差呈均匀分布
            real_ant_pos = norm_ant_pos + ((ant_pos_error_quantity(2)-ant_pos_error_quantity(1))*rand(size(norm_ant_pos))+ant_pos_error_quantity(1));
        otherwise        %误差为手动输入
            real_ant_pos = norm_ant_pos + ant_pos_error_type;
    end
    real_ant_pos(1,:) = real_ant_pos(1,:) - real_ant_pos(1,1);%使第一个基线始终为0，作为参考点
    real_ant_pos(2,:) = real_ant_pos(2,:) - real_ant_pos(2,1);%使第一个基线始终为0，作为参考点
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%