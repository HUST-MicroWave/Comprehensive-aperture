%%%%%%%%%%%% HUST-ASRʵ�����ݴ���������
%%%%%%%%%%%% ���пƼ���ѧ��2007-11-30��Revised March 2014
clear all; clc; tic;
% close all;
% ��������

save_flag=0;                      % �洢���ݵı�־��
%%%%%%%%���޸��������ʱ����Ӧ��ͬ�ķ��ݳ�������Ĳ��������仯������������ִΣ�����ɨ��λ�÷�Χ�ȡ�
scene_path ='����\11.19���ϸ߲�100m˫Ŀ��';
% scene_path ='����\11.06���䳡С¥';
% scene_path ='����\11.6̫������';
% scene_path ='����\10.26���ٰ����̴Ѻ͸߲�'; % ���������ļ�·��
scene_cycle = 0 : 1 : 2;          % ������ִ�
elevation = 0 : 1 : 120;           % ����ɨ��λ�÷�Χ
elev_pos_start = 0;               % ��������ʼ�Ƕȶ�Ӧ��ɨ��λ�ñ��
elevation_start_angle = 30;     % ����ɨ����ʼ�ǣ���֪������Ĭ����0
elevation_end_angle = 60;         % ����ɨ����ֹ�ǣ���֪������Ĭ����ɨ�����

% G��������·��
gmat_path ='����\11.22���䳡G����70m_��������ˮƽ';
azimuth = -30 : 0.1 : 30;       % ��λ�Ƕȷ�Χ����λ���ȣ�
azim_pos_start = 0;             % ��λ����ʼ�Ƕȶ�Ӧ��ɨ��λ�ñ��
use_gmatrix_flag = 1;           % G��������ʹ�ñ�־��
ideal_gmatrix_flag=0;           % ����G��������ʹ�ñ�־��

filter_gmatrix_flag=1;          % �Ƿ��G��������˲�����ı�־��
Gfliter_para=100;               % �˲����������˲�Ƶ����
DCfilter_flag=1;                % �˲���������ֱ���˲���־��
LFfilter_flag=1;                % �˲�����������ͨ�˲���־�� 


SNRcal_flag=0;                  %ʹ�������SNR����������־
SNRwin=[66 80 1 401];           %ͼ������ͳ�ƴ��ڷ�Χ��[�¡��ϡ�����]
target_pos=[68 298];            %ͼ��Ŀ��λ�ã�  [�ݡ���]

inverse_algo = 'FFT'; % %'Dsvd'; %'Tsvd'; %'PseudoInverse'; %'OneStep'; %'VanCitterAPN'; %'VanCitter'; % 'Tikhonov';            
% �����㷨���ƣ�Ŀǰ��'FFT','Tikhonov','VanCitter', 'VanCitterAPN', 'OneStep',
% 'PseudoInverse','Tsvd','Dsvd'
inverse_para = 601; %1; %150; %1 %1; %100; %3; %0.18;  %            
% �����㷨�������Ե����㷨���ԣ��ò�����ʾ�����������Ը��Ϸ��ݶ��ԣ��ò�����ʾ����ĸ������ԡ�Tikhnonv���㷨�������������ֵ
baseline = 'redun';             % �������ƣ�Ŀǰ��'all', 'great', 'small', 'redun'����
relativity_flag = 0;            % ��غ�����־����1��ʾ�������ϵ�����з��ݴ���0��ʾֱ�Ӳ������ֵ���д���
zerobaseline_flag=1;            % ����߱�־����1��ʾ��������߽��з��ݣ�0��ʾ����������߽��з���
window_name = 'rectwin';        % �ɼ��Ⱥ����Ӵ�

cali_extsrc_flag = 1;           % ��λ�޹س��������ⲿԴУ����־��
extsrc_path ='����\11.22���䳡�м�У��70m50��';  % �ⲿԴУ�������ļ�·��
cali_extsrc_algo = 'JR';        % �ⲿԴУ���㷨: 'JR', 'CLB1', 'CLB2'
extsrc_cycle = 0 : 1 : 49;      % �ⲿԴУ�����ݵ��ִα��

cali_consterr_flag = 1;         % ���������ⲿУ����־�����ⲿ����������
consterr_path = '����\10.26���ٰ����̴Ѻ͸߲�';
% ��ձ�������
consterr_pos = 75:1:80;      % ϵͳ�̶�������ݵ�λ�ñ�� 
% (ȡͼ���75-85�����ݣ���ͼ���������յ�������Ϊ�ⲿ�������ڼ���������)
consterr_cycle = 0 : 1 : 5;     % ϵͳ�̶�������ݵ��ִα��

% û�õ�ͨ�����������ע��
% ��ͨ�����������ע�뷨ֻ��У����������������ϵ���ͨ�������ļ�����������������ϵ����ͨ���ڿɼ����б���Ϊ���������������
% �����ͼ���������ж���Ч����Ч�������ԣ���һ�㲻�ã�����������ɶ�����ƥ�为�ز�����
% ����������ǲ����ⲿ������������÷�����ͬʱУ���������������Լ����߻�������ļ���������Ч���Ϻá�
cali_uncornoise_flag = 0;         % ͨ�����������ע��У����־��
% uncornoise_path = 'D:\�½��ļ���\12.03���䳡����50��';   % ���������ע�����ݵ��ļ�·��
uncornoise_pos = 0 : 1 :0;        % ͨ�����������ע��У�����ݵ�λ�ñ��
uncornoise_cycle = 0 : 1 : 49;    % ͨ�����������ע��У�����ִα��


P = 90;                           %��������
delta_u = 1;                      %��С���߼���� 
antenna_num = 16;                 %��Ԫ��������  
norm_ant_position = [0 1 2 5 10 15 26 37 48 59 70 76 82 88 89 90];  %16���ߵ�Ԫ�󡪡�����Ԫλ��
w = window(window_name, 2*P+1);  %���ɴ�����
ant_pair_baseline = GetAntPairBaseline(norm_ant_position);       %�������л��߶�
%%%%%%%%%%%%%%%%%%%�������ý���%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �����ǳ������壬һ�㲻Ҫ�޸� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �������
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
%%%%%%%%%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%

% ��ȡĿ�곡����G���������ļ������ɻ���ؾ���sceneCorr��gmatCorr
elev_pos = elev_pos_start : 1 : length(elevation)+elev_pos_start-1;
azim_pos = azim_pos_start : 1 : length(azimuth)+azim_pos_start-1;
sceneCorr = GetCorrMatFromDat(scene_path, relativity_flag, antenna_num, elev_pos, scene_cycle);
if use_gmatrix_flag == 1
    gmatCorr = GetCorrMatFromDat(gmat_path, relativity_flag, antenna_num, azim_pos, 0);
end
%%%%%%%%%%%%%%%%%%%���ݶ�ȡ����%%%%%%%%%%%%%%%%%%%

% �ⲿУ��ϵͳ�������ⲿ����������
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
%%%%%%%%%%%%%%%%%%%�ⲿϵͳ�������У������%%%%%%%%%%%%%%%%%%%

% ͨ�����������ע��У��
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
%%%%%%%%%%%%%%%%%%%ͨ�����������ע��У������%%%%%%%%%%%%%%%%%%%

% У��ϵͳ��λ�޹س������
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
%%%%%%%%%%%%%%%%%%%ϵͳ��λ�޹س������У������%%%%%%%%%%%%%%%%%%%

% ���ɿɼ��Ⱥ������Կɼ��Ƚ��мӴ�����
sceneV = GetVisibilityFromMat(sceneCorr, baseline, norm_ant_position);  %�ӻ���ؾ��������ɿɼ��Ⱥ��� sceneV
switch lower(baseline)           %�Ӵ�����
    case 'all'
        for k = 1 : size(sceneV, 1)
            sceneV(k, :) = sceneV(k, :) * w(P + 1 + ant_pair_baseline(k,1));
        end
    otherwise
        for k = 1 : size(sceneV, 1)
            sceneV(k, :) = sceneV(k, :) * w(P + k);
        end
end
%%%%%%%%%%%%%%%%%%%�ɼ��Ⱥ���������Ӵ��������%%%%%%%%%%%%%%%%%%%




%�������G�����ݷ���������G�����˲�����
if use_gmatrix_flag == 1
    G = GetVisibilityFromMat(gmatCorr, baseline, norm_ant_position);
if filter_gmatrix_flag ==1
    G = G_filter_complex(G,Gfliter_para,DCfilter_flag,LFfilter_flag);
end
end
%%%%%%%%%%%%%%%%%%%G���������������˲��������%%%%%%%%%%%%%%%%%%%

% ѡ�����㷨����ͼ����
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
%%%%%%%%%%%%%%%%%%%ͼ���ݽ���%%%%%%%%%%%%%%%%%%%

% ������������е��ۺϿ׾�����ͼ
% AMat=GrMat*(GrMat');
% % figure;mesh(AMat);
% figure; plot(AMat(:,301));
% APN=sum(AMat(:,301))
% figure; plot(diag(AMat));
% A = GrMat*GMat;
% APN=sum(A(300,:));
%%%%%%%%%%%%%%%%%%%�ۺϿ׾�����ͼ���ƽ���%%%%%%%%%%%%%%%%%%%

% ����ͼ�񲢱���ͼ������
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
%%%%%%%%%%%%%%%%%%%%����ͼ�񲢱���ͼ�����ݽ���%%%%%%%%%%%%%%%%%%%%

toc
