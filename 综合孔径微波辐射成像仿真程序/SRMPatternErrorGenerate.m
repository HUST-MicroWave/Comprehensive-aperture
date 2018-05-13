function real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);

%   语法：
%   real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);
% 
%   函数功能：
%   产生方向图误差
%  
%   输入参数:
%   coef_matrix  ：方向图矩阵
%   pattern_error_quantity     ：方向图误差大小
%   antenna_num    ：天线个数
%   pattern_error_type :方向图误差类型
%   输出参数：
%   real_coef_matrix  :所有天线的方向图矩阵，封装在cell中
% 
%   范例:
% 
%   coef_matrix = ones(4,5);
%   pattern_error_quantity = 0.1;
%   antenna_num = 24;
%   pattern_error_type = 'normal';
%   real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);
% 
%   靳榕，华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $

for antenna_seria = 1:antenna_num%对每个天线都做如下操作
    switch lower(pattern_error_type)
        case 'normal'
            error_coef_matrix = coef_matrix + pattern_error_quantity*randn(size(coef_matrix));%随机噪声注入
        case 'constant'
            error_coef_matrix = coef_matrix + pattern_error_quantity;%随机噪声注入
        case 'uniform'
            error_coef_matrix = coef_matrix + (pattern_error_quantity(2)-pattern_error_quantity(1))*rand(size(coef_matrix))+pattern_error_quantity(1);%随机噪声注入
    end
    % 注入随机噪声之后需要对方向图重新归一化
    %使得方向图总是在[0 1]范围内：
    for p = 1:size(error_coef_matrix,1)
        for q = 1:size(error_coef_matrix,2)
            if(error_coef_matrix(p,q)>1)
                error_coef_matrix(p,q) = 1;
            elseif(error_coef_matrix(p,q)<0)
                error_coef_matrix(p,q) = 0;
            end
        end
    end
    real_coef_matrix(antenna_seria) = {error_coef_matrix};%封装在cell中
end
