function mutual_matrix = SRMMutualErrorGenerate(min_spacing,ant_pos,mutual_error_quantity,mutual_error_type);

%   语法：
%   mutual_matrix = SRMMutualErrorGenerate(min_spacing,ant_pos,mutual_error_quantity,mutual_error_type);
% 
%   函数功能：
%   产生互耦矩阵
%  
%   输入参数:
%   ant_pos     ：基线排列形式，分2种情况
%         输入矩阵的行数为1      ：一维直线阵列
%         输入矩阵的行数为2      ：平面阵列
%   min_spacing     ：最小基线排列间隔，单位为波长
%   mutual_error_quantity    ：互耦大小 
%   mutual_error_type  ：互耦类型
%   输出参数：
%   mutual_matrix  :互耦矩阵
% 
%   范例:
% 
%   min_spacing = 1/2;
%   ant_pos = [0 2 5 6]; 
%   mutual_error_quantity = 0.01;
%   mutual_error_type = 'normal';
%   mutual_matrix = SRMMutualErrorGenerate(min_spacing,ant_pos,mutual_error_quantity,mutual_error_type);
% 
%  靳榕，华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $


if(ischar(mutual_error_type)==0)       %互耦误差为手动输入
    mutual_matrix = mutual_error_type;
else
    %天线个数:
    ata_num = length(ant_pos(1,:));
    %互耦误差模型与其它误差不同，应遵守天线距离越远，互耦越小的原则
    if(isvector(ant_pos) == 1)%如果是一维阵列
        ant_pos(2,:) = zeros(1,ata_num);%将其转换为纵向位置均为0的平面阵列，以便统一处理
    end

    % 得到距离矩阵distance_matrix,其第i行第j列的元素表示第i个天线与第j个天线的距离差
    distance_matrix = zeros(ata_num,ata_num);%初始化
    for p = 1:ata_num
        for q = 1:ata_num
            if(q>p)
                distance_matrix(p,q) = abs((ant_pos(1,q)-ant_pos(1,p))+j*(ant_pos(2,q)-ant_pos(2,p)));
            end
        end
    end
    % 产生上三角互耦矩阵，互耦大小与距离成反比
    mutual_matrix = zeros(ata_num,ata_num);%初始化
    for p = 1:ata_num
        for q = 1:ata_num
            if(q>p)
                switch lower(mutual_error_type)
                    case 'normal'
                        %随机产生互耦系数，其大小与mutual_error_quantity成正比，与距离成反比
                        mutual_matrix(p,q) = randn(1,1)*mutual_error_quantity/(min_spacing*distance_matrix(p,q));
                        mutual_matrix(p,q) = abs(mutual_matrix(p,q));
                    case 'constant'
                        mutual_matrix(p,q) = mutual_error_quantity/(min_spacing*distance_matrix(p,q));
                    case 'uniform'
                        %随机产生互耦系数，其大小与mutual_error_quantity成正比，与距离成反比
                        mutual_matrix(p,q) = (rand(1,1)*(mutual_error_quantity(2)-mutual_error_quantity(1))+mutual_error_quantity(1))/(min_spacing*distance_matrix(p,q));
                end
            end
        end
    end
    % 产生互耦矩阵
    mutual_matrix = mutual_matrix+mutual_matrix.';             %非对角线部分应为对称的
    mutual_matrix_diag = ones(1,ata_num)-sum(mutual_matrix);   %对角线部分应减去互耦损失掉的能量
    mutual_matrix = mutual_matrix+diag(mutual_matrix_diag);    %上面两部分结合获得互耦矩阵
end



