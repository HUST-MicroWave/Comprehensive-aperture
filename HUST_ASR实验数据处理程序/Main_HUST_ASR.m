%%%%%%%%%%%% HUST-ASR实验数据处理主程序
%%%%%%%%%%%% 华中科技大学，2007-11-30，Revised March 2014
clear all; clc; tic;
% close all;
% 参数设置

save_flag=0;                      % 存储数据的标志符
%%%%%%%%在修改这个参数时，对应不同的反演场景处理的参数发生变化，包括处理的轮次，俯仰扫描位置范围等。
scene_path ='数据\11.19晚上高层100m双目标';
% scene_path ='数据\11.06辐射场小楼';
% scene_path ='数据\11.6太阳成像';
% scene_path ='数据\10.26西操白天烟囱和高层'; % 场景数据文件路径
scene_cycle = 0 : 1 : 2;          % 处理的轮次
elevation = 0 : 1 : 120;           % 俯仰扫描位置范围
elev_pos_start = 0;               % 俯仰角起始角度对应的扫描位置编号
elevation_start_angle = 30;     % 俯仰扫描起始角，不知道可以默认填0
elevation_end_angle = 60;         % 俯仰扫描终止角，不知道可以默认填扫描次数

% G矩阵数据路径
gmat_path ='数据\11.22辐射场G矩阵70m_发射天线水平';
azimuth = -30 : 0.1 : 30;       % 方位角度范围，单位（度）
azim_pos_start = 0;             % 方位角起始角度对应的扫描位置编号
use_gmatrix_flag = 1;           % G矩阵数据使用标志符
ideal_gmatrix_flag=0;           % 理想G矩阵数据使用标志符

filter_gmatrix_flag=1;          % 是否对G矩阵进行滤波处理的标志符
Gfliter_para=100;               % 滤波参数——滤波频率数
DCfilter_flag=1;                % 滤波参数——直流滤波标志符
LFfilter_flag=1;                % 滤波参数——低通滤波标志符 


SNRcal_flag=0;                  %使用信噪比SNR搜索函数标志
SNRwin=[66 80 1 401];           %图像噪声统计窗口范围，[下、上、左、右]
target_pos=[68 298];            %图像目标位置，  [纵、横]

inverse_algo = 'FFT'; % %'Dsvd'; %'Tsvd'; %'PseudoInverse'; %'OneStep'; %'VanCitterAPN'; %'VanCitter'; % 'Tikhonov';            
% 反演算法名称，目前有'FFT','Tikhonov','VanCitter', 'VanCitterAPN', 'OneStep',
% 'PseudoInverse','Tsvd','Dsvd'
inverse_para = 601; %1; %150; %1 %1; %100; %3; %0.18;  %            
% 反演算法参数，对迭代算法而言，该参数表示迭代次数；对傅氏反演而言，该参数表示补零的个数；对‘Tikhnonv’算法代表正则参数的值
baseline = 'redun';             % 基线名称，目前有'all', 'great', 'small', 'redun'四种
relativity_flag = 0;            % 相关函数标志符：1表示采用相关系数进行反演处理，0表示直接采用相关值进行处理
zerobaseline_flag=1;            % 零基线标志符：1表示包含零基线进行反演，0表示不包含零基线进行反演
window_name = 'rectwin';        % 可见度函数加窗

cali_extsrc_flag = 1;           % 方位无关乘性误差——外部源校正标志符
extsrc_path ='数据\11.22辐射场中间校正70m50组';  % 外部源校正数据文件路径
cali_extsrc_algo = 'JR';        % 外部源校正算法: 'JR', 'CLB1', 'CLB2'
extsrc_cycle = 0 : 1 : 49;      % 外部源校正数据的轮次编号

cali_consterr_flag = 1;         % 加性误差——外部校正标志符（外部场景对消）
consterr_path = '数据\10.26西操白天烟囱和高层';
% 天空背景数据
consterr_pos = 75:1:80;      % 系统固定误差数据的位置编号 
% (取图像的75-85行数据，即图像上面的天空的数据作为外部场景用于加性误差对消)
consterr_cycle = 0 : 1 : 5;     % 系统固定误差数据的轮次编号

% 没用到通道非相干噪声注入
% 因通道非相关噪声注入法只能校正共本振热噪声耦合到各通道产生的加性误差（本振热噪声耦合到多个通道在可见度中表现为额外的相关输出），
% 在输出图像上难以判断其效果（效果不明显），一般不用；非相干噪声由独立的匹配负载产生。
% 其替代方法是采用外部场景对消，因该方法可同时校正共本振热噪声以及天线互耦产生的加性噪声，效果较好。
cali_uncornoise_flag = 0;         % 通道非相关噪声注入校正标志符
% uncornoise_path = 'D:\新建文件夹\12.03辐射场底噪50组';   % 非相关噪声注入数据的文件路径
uncornoise_pos = 0 : 1 :0;        % 通道非相关噪声注入校正数据的位置编号
uncornoise_cycle = 0 : 1 : 49;    % 通道非相关噪声注入校正的轮次编号


P = 90;                           %最大基线数
delta_u = 1;                      %最小基线间隔数 
antenna_num = 16;                 %单元天线数量  
norm_ant_position = [0 1 2 5 10 15 26 37 48 59 70 76 82 88 89 90];  %16天线单元阵——各阵元位置
w = window(window_name, 2*P+1);  %生成窗函数
ant_pair_baseline = GetAntPairBaseline(norm_ant_position);       %生成所有基线对
%%%%%%%%%%%%%%%%%%%参数设置结束%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 以下是程序主体，一般不要修改 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 参数检查
switch lower(baseline)
    case {'all', 'great', 'small', 'redun'}
    otherwise
        disp('Unknown baseline.')
        return
end
switch lower(inverse_algo)
    case {'vancitter', 'vancitterapn', 'onestep', 'pseudoinverse', 'bg','tikhonov','tsvd','dsvd'}
        use_gmatrix_flag = 1;
    case 'fft'
        if strcmpi(baseline, 'all') == 1
            disp('fft invserion does not support "all" baseline.')
        end
    otherwise
        disp('Unknown inverse algorithm.')
        return
end
switch lower(cali_extsrc_algo)
    case {'jr', 'clb1', 'clb2'}
    otherwise
        disp('Unknown calibration algorithm with external noise source.')
        return
end
%%%%%%%%%%%%%%%%%%%参数检查结束%%%%%%%%%%%%%%%%%%%

% 读取目标场景、G矩阵数据文件，生成互相关矩阵sceneCorr和gmatCorr
elev_pos = elev_pos_start : 1 : length(elevation)+elev_pos_start-1;
azim_pos = azim_pos_start : 1 : length(azimuth)+azim_pos_start-1;
sceneCorr = GetCorrMatFromDat(scene_path, relativity_flag, antenna_num, elev_pos, scene_cycle);
if use_gmatrix_flag == 1
    gmatCorr = GetCorrMatFromDat(gmat_path, relativity_flag, antenna_num, azim_pos, 0);
end
%%%%%%%%%%%%%%%%%%%数据读取结束%%%%%%%%%%%%%%%%%%%

% 外部校正系统加性误差（外部场景对消）
if cali_consterr_flag == 1
    consterrCorr = mean(GetCorrMatFromDat(consterr_path, relativity_flag, antenna_num, consterr_pos, consterr_cycle), 3);
    for k = 1 : length(elevation)
        sceneCorr(:,:,k) = sceneCorr(:,:,k) - consterrCorr;
    end
    if use_gmatrix_flag == 1
        for k = 1 : length(azimuth)
            gmatCorr(:,:,k) = gmatCorr(:,:,k) - consterrCorr;
        end
    end
end
%%%%%%%%%%%%%%%%%%%外部系统加性误差校正结束%%%%%%%%%%%%%%%%%%%

% 通道非相关噪声注入校正
if cali_uncornoise_flag == 1
    uncornoiseCorr = mean(GetCorrMatFromDat(uncornoise_path, relativity_flag, antenna_num, uncornoise_pos, uncornoise_cycle), 3);
    for k = 1 : length(elevation)
        sceneCorr(:,:,k) = sceneCorr(:,:,k) - uncornoiseCorr;
    end
    if use_gmatrix_flag == 1
        for k = 1 : length(azimuth)
            gmatCorr(:,:,k) = gmatCorr(:,:,k) - uncornoiseCorr;
        end
    end
end
%%%%%%%%%%%%%%%%%%%通道非相关噪声注入校正结束%%%%%%%%%%%%%%%%%%%

% 校正系统方位无关乘性误差
if cali_extsrc_flag == 1
    extsrcCorr = GetCorrMatFromDat(extsrc_path, relativity_flag, antenna_num, 0, extsrc_cycle);
    switch lower(cali_extsrc_algo)
        case 'jr'
            adjustvar = JROneSourceCalibration(extsrcCorr, delta_u, norm_ant_position, 0);
            adjustvar = diag(adjustvar);
            for k = 1 : length(elevation)
                sceneCorr(:,:,k) = inv(adjustvar) * sceneCorr(:,:,k) * inv(adjustvar');
            end
            if use_gmatrix_flag == 1
                for k = 1 : length(azimuth)
                    gmatCorr(:,:,k) = inv(adjustvar) * gmatCorr(:,:,k) * inv(adjustvar');
                end
            end
        case 'clb1'
            angle_R=angle(extsrcCorr);
            for k = 1 : length(elevation)
                sceneCorr(:,:,k) = sceneCorr(:,:,k) .* exp(-j*angle_R);
            end
            if use_gmatrix_flag == 1
                for k = 1 : length(azimuth)
                    gmatCorr(:,:,k) = gmatCorr(:,:,k) * exp(-j*angle(extsrcCorr));
                end
            end
        case 'clb2'
            [phaseCali, ampCali] = CalcPhaseAndGainByRedun(norm_ant_position, extsrcCorr);
            adjustvar = diag(exp(j*phaseCali) .* ampCali);
            for k = 1 : length(elevation)
                sceneCorr(:,:,k) = inv(adjustvar) * sceneCorr(:,:,k) * inv(adjustvar');
            end
            if use_gmatrix_flag == 1
                for k = 1 : length(azimuth)
                    gmatCorr(:,:,k) = inv(adjustvar) * gmatCorr(:,:,k) * inv(adjustvar');
                end
            end
    end
end
%%%%%%%%%%%%%%%%%%%系统方位无关乘性误差校正结束%%%%%%%%%%%%%%%%%%%

% 生成可见度函数并对可见度进行加窗处理
sceneV = GetVisibilityFromMat(sceneCorr, baseline, norm_ant_position);  %从互相关矩阵中生成可见度函数 sceneV
switch lower(baseline)           %加窗处理
    case 'all'
        for k = 1 : size(sceneV, 1)
            sceneV(k, :) = sceneV(k, :) * w(P + 1 + ant_pair_baseline(k,1));
        end
    otherwise
        for k = 1 : size(sceneV, 1)
            sceneV(k, :) = sceneV(k, :) * w(P + k);
        end
end
%%%%%%%%%%%%%%%%%%%可见度函数生成与加窗处理结束%%%%%%%%%%%%%%%%%%%




%如果采用G矩阵反演法，则生成G矩阵并滤波处理；
if use_gmatrix_flag == 1
    G = GetVisibilityFromMat(gmatCorr, baseline, norm_ant_position);
if filter_gmatrix_flag ==1
    G = G_filter_complex(G,Gfliter_para,DCfilter_flag,LFfilter_flag);
end
end
%%%%%%%%%%%%%%%%%%%G矩阵数据生成与滤波处理结束%%%%%%%%%%%%%%%%%%%

% 选择反演算法进行图像反演
switch lower(inverse_algo)
    case 'tikhonov'
        if SNRcal_flag==1
        [TA_scene,GMat,GrMat] = TikhonovInverse_SNR(sceneV, G, inverse_para,zerobaseline_flag,ideal_gmatrix_flag,SNRwin,target_pos);
        else
        [TA_scene,GMat,GrMat] = TikhonovInverse(sceneV, G, inverse_para,zerobaseline_flag,ideal_gmatrix_flag); 
        end
    case 'tsvd'
        TA_scene = TsvdInverse(sceneV, G, inverse_para,zerobaseline_flag,ideal_gmatrix_flag);
    case 'dsvd'
        if SNRcal_flag==1
        TA_scene = DsvdInverse_SNR(sceneV, G, inverse_para,zerobaseline_flag,ideal_gmatrix_flag,SNRwin,target_pos);
        else
        TA_scene = DsvdInverse(sceneV, G, inverse_para,zerobaseline_flag,ideal_gmatrix_flag);    
        end
    case 'vancitter'
        TA_scene = VanCitterInverse(sceneV, G, inverse_para);
    case 'vancitterapn'
        TA_scene = VanCitterAPNInverse(sceneV, G, inverse_para);
    case 'onestep'
        TA_scene = OneStepInverse(sceneV, G, inverse_para);
    case 'pseudoinverse'
        [TA_scene,GMat,GrMat] = PseudoInverse(sceneV, G, zerobaseline_flag,ideal_gmatrix_flag);
    case 'bg'
        [TA_scene,GMat,GrMat] = BGInverse_ck(sceneV, G, inverse_para,zerobaseline_flag,ideal_gmatrix_flag);
    case 'fft'
        TA_scene = FFTInverse(sceneV, inverse_para);
        azimuth = linspace(min(azimuth), max(azimuth), inverse_para);
end
%%%%%%%%%%%%%%%%%%%图像反演结束%%%%%%%%%%%%%%%%%%%

% 画出成像过程中的综合孔径方向图
% AMat=GrMat*(GrMat');
% % figure;mesh(AMat);
% figure; plot(AMat(:,301));
% APN=sum(AMat(:,301))
% figure; plot(diag(AMat));
% A = GrMat*GMat;
% APN=sum(A(300,:));
%%%%%%%%%%%%%%%%%%%综合孔径方向图绘制结束%%%%%%%%%%%%%%%%%%%

% 绘制图像并保存图像数据
strtemp = textscan(scene_path, '%s', 'delimiter', '\\');
strtemp = strtemp{1,1};
whiten_status = strtemp{size(strtemp,1),1};
save_path = strtemp{size(strtemp,1)-1,1};
% mkdir(save_path);
ImageFileName = sprintf('%s\\Image_%s_%s%d_%s_%sBaselines_%s', save_path, whiten_status, inverse_algo, inverse_para, cali_extsrc_algo, baseline, window_name);
if relativity_flag == 1
    ImageFileName = sprintf('%s_r', ImageFileName);
end

if use_gmatrix_flag == 1
if filter_gmatrix_flag == 1
    ImageFileName = sprintf('%s_f', ImageFileName);
end
end
TA_scene=25.256.*TA_scene+78.17;
switch lower(inverse_algo)
    case { 'PseudoInverse', 'bg','tikhonov'}
        SaveDrawG(azimuth, elevation, TA_scene,ImageFileName,save_flag,GMat,GrMat);
    otherwise
        SaveDraw_CK(azimuth, elevation,elevation_start_angle ,elevation_end_angle,TA_scene,ImageFileName,save_flag);
end
%%%%%%%%%%%%%%%%%%%%绘制图像并保存图像数据结束%%%%%%%%%%%%%%%%%%%%

toc
