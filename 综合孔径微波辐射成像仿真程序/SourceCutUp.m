function T_dist = SourceCutUp(place_start,place_end,scope,power)

% 展源切分函数，按照预先设计的网格，将其划分为多个点源
% place_start 展源开始位置
% place_end   展源终止位置
% scope       预设网格
% power       展源的能量(K)

% 获得预设网格的单元间隔
delta = scope(2)-scope(1);
% 初始化亮温分布
T_dist = [;];

for k = 1:length(scope)
    % 判断网格内是否有源存在
    if (scope(k)>=place_start)&&(scope(k)<=place_end)
        %如果存在源，则
        % 获取该点的起始位置
        delta_start = max(scope(k)-delta/2,place_start);
        delta_end = min(scope(k)+delta/2,place_end);
        % 获得该点的面积，以便计算其能量
        area = delta_end - delta_start;
        T_dist_k = [power*area/delta;asind(scope(k))];
        T_dist = [T_dist T_dist_k];
    end
end
        