function T_dist = CASsimulate(Fov,delta,CAS_param,div)

% 获取量温分布
% Fov 视场方位[-1 1]:一维阵 [-1 1 ：平面阵
%                           -1 1]
% delta 一个分辨率下的视场最小间隔 [0.01]:一维阵 [0.01 0.02]：平面阵
% div   仿真视场划分规则 *SpaceDivisionHELP()
% 华中科技大学

%%%%%%理想点源处理部分%%%%%%%
if CAS_param.idealpoint_simu==1
    % 对于理想点源，位置不变
    place = CAS_param.idealpoint_place;
    if size(place,1)==1 %一维阵列
        % 将理想点源能量输入值等效到一个分辨率单元内
        power = CAS_param.idealpoint_power*delta/(Fov(2)-Fov(1));
        T_dist_point = [power;place];
    end
    if size(place,1)==2 %平面阵列
        % 将理想点源能量输入值等效到一个分辨率单元内
        power = CAS_param.idealpoint_power*delta(1)*delta(2)/(Fov(1,2)-Fov(1,1))/(Fov(2,2)-Fov(2,1));
        T_dist_point = [power;place];
    end
else
    %无理想点源存在时
    T_dist_point = [];
end


T_dist = T_dist_point;

          
            
            

    
    

