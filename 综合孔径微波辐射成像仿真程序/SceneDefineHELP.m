function SceneDefineHELP() 

% 场景分布分为以下几种情况
    %1理想点源
% 说明：理想点源为无限小，能量强的点源。 理想点源的仿真优点是参数设置方便，适合于不考虑灵敏度，分辨率时成像效果的粗略估计。
% source_place 表示来波方向，如果有多个点源可用空格隔开
% 例：source_place = [-20 0 20 30]; 表示一维阵列有四个理想点源，方向分别为-20，0，20，30度
% 例：source_place = [0 30 30;0 0 90]; 表示平面阵列有三个理想点源，方向分别为(0 0),(30 0),(30 90)度
% source_power 表示没有路径衰减时，点源到达天线口面的能量，如果有多个点源可用空格隔开，且与source_place是一一对应的。
% 例：source_power = [100 100 100 100];  表示有四个理想点源，源的功率分别为100，100，100，100

    %2展源
% 说明：展源为占多个象素均匀分布的源   
% STM_param.extentpoint_model: 展源的形状
 %'rectangular' 矩形展源
% 例：STM_param.extentpoint_rec_power = [400 300 500];           矩形源的能量
% 例：STM_param.extentpoint_rec_place_center = [0 0;30 0;30 90]; 矩形源来波矩向中心位置，度(theta,phy)
% 例：STM_param.extentpoint_rec_place_hs = [3 3;10 10;10 10];    矩形源半边长，度(l,m)
    
    %3图片导入
% 说明：图片导入为根据图片像素点灰度值分布的源，也可由矩阵导入  
% 例：STM_param.picinsert_simu = 2;            %是否仿真，0表示不仿真，1表示仿真图片 ,2表示读入.mat文件
% 例：STM_param.filename = '示例图片.bmp';      %导入的图片位置
% 例：STM_param.matfile = 'pictest.mat';       %导入图形矩阵
% 例：STM_param.pic_scope = [-17 17;-17 17];   %导入图片的上下和左右范围（度）

% 华中科技大学
    
    
    
    
    
    
    
    