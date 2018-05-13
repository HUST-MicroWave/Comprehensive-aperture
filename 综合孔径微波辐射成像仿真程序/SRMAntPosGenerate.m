function [ant_pos,antenna_num] = SRMAntPosGenerate(array_type,array_num);

%   语法：
%   ant_pos = SRMAntPosGenerate(array_type,array_num);
% 
%   函数功能：
%   基线位置产生函数
%  
%   输入参数:
% array_type     ：阵列形式，分以下几种情况
%         'mrla'         ：最小冗余阵
%         'Y_shape'      :Y型阵
%         'T_shape'      :T型阵
% array_num      ：天线个数 
%   输出参数：
% ant_pos  :基线排列
% 
%   范例:
% array_type = 'Y_type' 
% array_num =24;
% ant_pos = SRMAntPosGenerate(array_type,array_num);
% 
%   靳榕，华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $



if (ischar(array_type)==0)
    %手动输入的怪阵
    ant_pos = array_type;
    antenna_num = size(ant_pos,2);
else
    %阵列的形式：AntennaPositionHELP()
    switch array_type
        case 'mrla'
            %最小冗余阵
            ant_pos = SRMGenerateMRLAAntennaPos(array_num);
            antenna_num = array_num;
        case 'ula'
            %均匀直线阵
            ant_pos = [0:array_num-1];
            antenna_num = array_num;
        case 'Y_shape'
            %交错Y型阵
            cell = array_num/3-1:-1:0;
            cell1 = (-j)*cell;
            cell2 = (cell+1)*exp(j*pi/6);
            cell3 = cell*exp(j*pi*5/6)+j;
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;
        case 'y_shape'
            %普通Y型阵
            cell = (array_num-1)/3:-1:1;
            cell1 = (-j)*cell;
            cell2 = cell*exp(j*pi/6);
            cell3 = cell*exp(j*pi*5/6);
            ant_pos_x = [0 real([cell1 cell2 cell3])];
            ant_pos_y = [0 imag([cell1 cell2 cell3])];
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;
        case 'T_shape'
            %T型阵
            cell = array_num/3:-1:1;
            cell1 = (-j)*cell;
            cell2 = cell;
            cell3 = (-1)*cell;
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;
        case 'O_shape'
            %圆形阵
            cell_angle = 0:array_num-1;
            cell = exp(j*cell_angle*2*pi/array_num);
            ant_pos_x = real(cell);
            ant_pos_y = imag(cell);
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;            
    end
end