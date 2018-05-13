function T_dist = STMSimulate(Fov,delta,STM_param,div)

% 获取亮温分布
% Fov 视场范围    [-1 1]:一维阵； [-1 1 ：平面阵
%                                 -1 1]
% delta 一个分辨率下的视场最小间隔 [0.01]:一维阵 [0.01 0.02]：平面阵
% div   仿真视场划分规则 *SpaceDivisionHELP()
% 华中科技大学


%%%%%%理想点源处理部分%%%%%%%
if STM_param.idealpoint_simu==1
    % 对于理想点源，位置不变
    place = STM_param.idealpoint_place;
    if size(place,1)==1 %一维阵列
        % 将理想点源能量输入值等效到一个分辨率单元内
        power = STM_param.idealpoint_power*delta/(Fov(2)-Fov(1));
        T_dist_point = [power;place];
    end
    if size(place,1)==2 %平面阵列
        % 将理想点源能量输入值等效到一个分辨率单元内
        power = STM_param.idealpoint_power*delta(1)*delta(2)/(Fov(1,2)-Fov(1,1))/(Fov(2,2)-Fov(2,1));
        T_dist_point = [power;place];
        % 对于Y型阵，按照矩形网格划分的分辨率小于其实际按照六边形划分的网格。因此，在计算能量的时候要把它补偿回来。
        if lower(STM_param.array_type) == 'y_shape'
            T_dist_point(1,:) = T_dist_point(1,:)*8/3;
        end
    end
else
    %无理想点源存在时
    T_dist_point = [];
end

%%%%%%展源处理部分%%%%%%%
if STM_param.extentpoint_simu == 1
    
    %%%%%%一维阵列%%%%%%%%%%%    
    if(size(Fov,1)==1)   %判断阵列是否为一维阵列
        % 初始化展源
        T_dist_extent = [;];
        % 对空间按照预设的划分的份数进行划分，获得空间划分的份数
        division = SpaceDivisionSelect(div,delta);
        % 按照划分获取视场中的仿真点
        scope = linspace(-1,1,division);
        lengthscope = length(scope);
        % 对于展源仿真，需要知道其起始角度
        place_start = sind(STM_param.extentpoint_place_start);
        place_end = sind(STM_param.extentpoint_place_end);
        power = STM_param.extentpoint_power*(scope(2)-scope(1))/(Fov(2)-Fov(1));
        for source_num = 1:length(place_start)
            % 调用展源切分函数，将其划分为多个点源
            T_dist_source = SourceCutUp(place_start(source_num),place_end(source_num),scope,power(source_num));
            T_dist_extent = [T_dist_extent T_dist_source];
        end
    end
    
    %%%%%%平面阵列%%%%%%%%%%%
    if(size(Fov,1)==2)   %判断阵列是否为二维阵列
        % 初始化展源
        T_dist_extent = [;;];
        % 对空间按照预设的划分的份数进行划分，获得空间划分的份数
        division = SpaceDivisionSelect(div,delta);
        % 按照划分获取视场中的仿真点
        scope_m = linspace(-1,1,division(2));
        scope_l = linspace(-1,1,division(1));
        for k = 1:size(STM_param.extentpoint_model,1)
            switch STM_param.extentpoint_model(k,:)
                case 'rectangular'
                    for rec_k = 1:length(STM_param.extentpoint_rec_power)
                        power = STM_param.extentpoint_rec_power(rec_k)*(scope_l(2)-scope_l(1))*(scope_m(2)-scope_m(1))/(Fov(1,2)-Fov(1,1))/(Fov(2,2)-Fov(2,1));
                        center = STM_param.extentpoint_rec_place_center(rec_k,:);
                        hs = STM_param.extentpoint_rec_place_hs(rec_k,:);
                        T_dist_source = SourceCutUp2D(scope_l,scope_m,power,center,hs);
                        T_dist_extent = [T_dist_extent T_dist_source];
                    end
            end
        end
        % 对于Y型阵，按照矩形网格划分的分辨率小于其实际按照六边形划分的网格。因此，在计算能量的时候要把它补偿回来。
        if lower(STM_param.array_type) == 'y_shape'
            T_dist_extent(1,:) = T_dist_extent(1,:)*8/3;
        end
    end
else
    %无展源存在时
    T_dist_extent = [];
end

%%%%%%图片导入处理部分%%%%%%%
if STM_param.picinsert_simu == 0
    T_dist_pic = [;;];
else
    if (STM_param.picinsert_simu == 1) %图片导入
        pic = imread(STM_param.filename);
        pic = double(pic(:,:,1));
    end
    if (STM_param.picinsert_simu == 2) %矩阵导入
        load(STM_param.matfile);
        pic = abs(pic);
    end
    T_dist_pic = [;;];
    row_pix = size(pic,1);
    col_pix = size(pic,2);
    row = linspace(STM_param.pic_scope(1,1),STM_param.pic_scope(1,2),row_pix);
    col = linspace(STM_param.pic_scope(2,1),STM_param.pic_scope(2,2),col_pix);
    for pic_row = 1:length(row)
        for pic_col = 1:length(col)
            %点的位置
            pic_point = col(pic_col)+j*row(pic_row);
            if (abs(pic_point/90)<=1)
                power = pic(row_pix-pic_row+1,pic_col)/row_pix/col_pix;
                theta = abs(pic_point);
                phy = angle(pic_point)*180/pi;
                T_dist_source = [power;theta;phy];
                T_dist_pic = [T_dist_pic T_dist_source];
            end
        end
    end
end

T_dist = [T_dist_point T_dist_extent T_dist_pic];

          
            
            

    
    

