function [Fov,delta] = STMResolution(min_spacing,ant_pos)

% 计算阵列的分辨率单元
% 程序返回分辨率单元间隔与视场范围
% 华中科技大学
if (size(ant_pos,1)==1)
    % 一维线阵
    lastant = ant_pos(length(ant_pos));  %最后一个天线的位置
    firstant = ant_pos(1);               %第一个天线的位置
    Tnum = 2*(lastant-firstant)+1;       %反演图像的点数
    
    Fov = [-1 1]/2/min_spacing;          %视场范围
    delta = (Fov(2)-Fov(1))/Tnum;        %分辨率单元间隔
    
else
    % 二维线阵
      if trace([mod(ant_pos,1)*mod(ant_pos,1)'])<=0.0001
        % 普通二维阵
        lastantx = max(ant_pos(1,:));                                     %最后一个天线的位置(x方向)
        lastanty = max(ant_pos(2,:));                                     %最后一个天线的位置(y方向)
        firstantx = min(ant_pos(1,:));                                    %第一个天线的位置(x方向)
        firstanty = min(ant_pos(2,:));                                    %第一个天线的位置(y方向)
        Tnum = [2*(lastantx-firstantx)+1 2*(lastanty-firstanty)+1];       %反演图像的点数

        Fov = [[-1 1]/2/min_spacing;[-1 1]/2/min_spacing];                %视场范围
        delta = [(Fov(1,2)-Fov(1,1))/Tnum(1);(Fov(2,2)-Fov(2,1))/Tnum(2)];%分辨率单元间隔
    else
        % Y型阵
        min_spacing = [sqrt(3)/2 1/2]*min_spacing;
        lastantx = max(ant_pos(1,:));                                     %最后一个天线的位置(x方向)
        lastanty = max(ant_pos(2,:));                                     %最后一个天线的位置(y方向)
        firstantx = min(ant_pos(1,:));                                    %第一个天线的位置(x方向)
        firstanty = min(ant_pos(2,:));                                    %第一个天线的位置(y方向)
        Tnum = [2*(lastantx-firstantx)+1 2*(lastanty-firstanty)+1]./[sqrt(3)/2 1/2];       %反演图像的点数
        Tnum = floor(Tnum);
        Fov = [[-1 1]/2/min_spacing(1);[-1 1]/2/min_spacing(2)];                %视场范围
        delta = [(Fov(1,2)-Fov(1,1))/Tnum(1);(Fov(2,2)-Fov(2,1))/Tnum(2)];%分辨率单元间隔
    end
    
end