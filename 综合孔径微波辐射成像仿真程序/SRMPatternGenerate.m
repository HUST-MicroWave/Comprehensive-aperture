function coef_matrix = SRMPatternGenerate(antenna_pattern_info,angle_info,array_type);
%   语法：
%   coef_matrix = SRMPatternGenerate(antenna_pattern_info,angle_info,array_type);
% 
%   函数功能：
%   根据天线的形状和尺寸，公式产生其在某些方向上的方向图
%  
%   输入参数: 
% antenna_pattern_info结构体：
%     antenna_type   ：天线形状，有以下几种情况可选
%         'isotropic'  理想，各个方向均为1
%         'rectangle'   矩形口面
%         'circle'     圆形口面
%     wavelength     ：天线工作波长
%     antenna_size   ：天线尺寸，分以下几种情况，与上面对应
%         无需填写
%         2个元素的向量，第一个元素为长，第二个元素为宽
%         1个元素，为天线半径
% array_type      ：平面阵还是一维直线阵，有以下2种情况
%         1       ：一维直线阵列
%         0       ：平面阵
% angle_info      ：角度信息，即产生哪些角度的方向图，分以下3种情况
%     输入矩阵的行数为1      ：一维直线阵列的方向角
%     输入矩阵的行数为2      ：平面阵列，少量点源的方向角theta和phy
%     2个元素的向量      ：平面阵列，复杂场景，theta被分成的份数和phy被分成的份数
%         
%   输出参数：
%   coef_matrix       :指定角度的方向图
% 
%   范例:
% antenna_pattern_info.antenna_type = 'rectangle';
% antenna_pattern_info.wavelength = 0.008;
% antenna_pattern_info.antenna_size = [0.008 0.008];
% angle_info = [-90:90];
% array_type = 1;
% coef_matrix = SRMPatternGenerate(antenna_pattern_info,angle_info,array_type);
% plot(coef_matrix);
%
%   靳榕，华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $

% 参数读入：
antenna_type = antenna_pattern_info.antenna_type; %天线类型从结构体中获取
antenna_size = antenna_pattern_info.antenna_size; %天线尺寸从结构体中获取
wavelength = antenna_pattern_info.wavelength;     %天线工作波长从结构体中获取

%%%%%%%%%%%%%%%%%方向图为手动输入%%%%%%%
if(ischar(antenna_type)==0) 
    coef_matrix = antenna_type;  %直接读取
    array_type = 2;              %避免下面程序的运行
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%一维阵情况%%%%%%%%%%%%%%%%%%%%%


if(array_type==1) %一维阵情况
    %天线形式：
    switch lower(antenna_type)
        case 'rectangle'% 矩形口面
            lx = pi*antenna_size(1)/wavelength;
            for k = 1:length(angle_info)
                coef_matrix(k) = abs(cosd(angle_info(k))*sinc(lx*sind(angle_info(k))));
            end
            %矩形天线结束

        case'isotropic'%理想，各个方向均为1
            coef_matrix = ones(size(angle_info));
            %理想天线结束

        case'circle'%圆形口面
            Ba = 2*pi*antenna_size/wavelength;
            for k = 1:length(angle_info)
                if (abs(sind(angle_info(k)))<=0.0001) %避免分母为0时出错
                    coef_matrix(k) = 1;
                else
                    coef_matrix(k) = abs(2*real(besselj(1,Ba*sind(angle_info(k))))/(Ba*sind(angle_info(k))));
                end
            end
            %圆形天线结束
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%平面阵情况%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(array_type==0)  %平面阵情况
    %天线形式：
    switch lower(antenna_type)
        case 'rectangle'% 矩形口面
            lx = pi*antenna_size(1)/wavelength;
            ly = pi*antenna_size(2)/wavelength;
            source_num = length(angle_info(1,:));
            for k = 1:source_num
                u = sind(angle_info(1,k))*cosd(angle_info(2,k));
                v = sind(angle_info(1,k))*sind(angle_info(2,k));
                coef_matrix(k) = abs(sinc(lx*u)*sinc(ly*v));
            end
            %矩形天线结束

        case'isotropic'%理想，各个方向均为1
            coef_matrix = ones(1,length(angle_info(1,:)));
            %理想天线结束

        case'circle'%圆形口面
            Ba = 2*pi*antenna_size/wavelength;
            source_num = length(angle_info(1,:));
            for k = 1:source_num
                if(sind(angle_info(1,k))<=0.0001)  %避免分母为0时出错
                    coef_matrix(k) = 1;
                else
                    coef_matrix(k) = abs(2*real(besselj(1,Ba*sind(angle_info(1,k))))/(Ba*sind(angle_info(1,k))));
                end
            end
            %圆形天线结束
    end
end


