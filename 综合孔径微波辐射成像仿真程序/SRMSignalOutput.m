function self_correlation_matrix = SRMSignalOutput(T_dist,ant_pos,min_spacing,pattern_coef,mutual,T_rec,error_amp,error_Iphase,error_Qphase);

%   语法：
%   self_correlation_matrix = SRMSignalOutput(sampling_num,T_dist,ant_pos,min_spacing,pattern_coef,mutual,T_rec,error_amp,error_Iphase,error_Qphase);
% 
%   函数功能：
%   读取相应信息，产生天线信号输出。
%  
%   输入参数:
%              
% T_dist     ：天线口面视在亮温分布矩阵，分3种情况
%     输入矩阵的行数为2      ：一维直线阵列
%     输入矩阵的行数为3      ：平面阵列，少量点源
%     输入矩阵的行数大于3      ：平面阵列，复杂场景
% ant_pos     ：基线排列形式，分2种情况
%     输入矩阵的行数为1      ：一维直线阵列
%     输入矩阵的行数为2      ：平面阵列
% min_spacing     ：最小基线排列间隔，单位为波长
% pattern_coef    ：天线方向图，与天线口面视在亮温分布矩阵相对应
% mutual      :天线互耦矩阵
%   输出参数：
%self_correlation_matrix       : 自相关矩阵
% 
%   范例:
% 
% source_place = [-20 0 20 30]; %来波方向
% source_power = [1 1 1.5 2];  %源的功率
% T_dist = [source_power;source_place];
% min_spacing = 1/2;
% ant_pos = [0 2 5 6]; 
% pattern_coef = [1 1 1 1]; %输入4个信号对应的方向图加权
% T_rec = 10;
% error_amp = [1 1 1 1];
% error_Iphase = [0 0 0 0];
% error_Qphase = [0 0 0 0];
% mutual = eye(4);
% self_correlation_matrix = SRMSignalOutput(sampling_num,T_dist,ant_pos,min_spacing,pattern_coef,mutual,T_rec,error_amp,error_Iphase,error_Qphase);
% IAM_SAR_jr(self_correlation_matrix,min_spacing*ant_pos,'standard');
% 
%   靳榕，华中科技大学.
%   $版本号: 1.0 $  $Date: 2008/01/01 $




%天线个数
antenna_num = length(ant_pos(1,:));
%阵列的基线排列等于基线的最小尺寸乘基线排列
ant_pos =  min_spacing*ant_pos; 
%通道幅相误差
error_amp_phase = exp(j*error_Iphase).*error_amp;

%判断是一维阵列还是平面阵列
if(isvector(ant_pos) == 1)
    flag = 1; %一维阵列
else
    flag = 0; %平面阵列
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%一维阵列的情况%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag==1)
    %分析场景信息
    scene_power = T_dist(1,:); %源的功率向量
    scene_theta = T_dist(2,:); %源的位置向量
    
    for k = 1:antenna_num %读取单元天线方向图
        coef_matrix(k,:) = cell2mat(pattern_coef(k));
    end
    
    % 定义引导向量A：
    for k=1:length(scene_power)
        A(:,k)=sqrt(coef_matrix(:,k)).*[exp(2*pi*j*ant_pos*sind(scene_theta(k)))].';       
    end
    
    % 考虑通道幅相误差情况下的引导向量A:
    A = diag(error_amp_phase)*A;
    % 考虑互藕情况下的引导向量A:
    A = mutual*A;   
    % 求出信号自相关矩阵
    self_correlation_matrix = A*diag(scene_power)*A';
    % 考虑通道噪声对自相关矩阵的影响
    self_correlation_matrix = self_correlation_matrix + diag(error_amp)*diag(error_amp)*T_rec;   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%平面阵列的情况%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag ==0)    
    scene_power = T_dist(1,:); %源的功率向量
    scene_theta = T_dist(2,:); %源的位置向量theta
    scene_phy = T_dist(3,:);   %源的位置向量phy
    
    for k = 1:antenna_num%读取单元天线方向图
        coef_matrix(k,:) = cell2mat(pattern_coef(k));
    end

    % 定义引导向量A：
    for k=1:length(scene_power)
        A(:,k)=sqrt(coef_matrix(:,k)).*[exp(2*pi*j*sind(scene_theta(k))*(ant_pos(1,:)*cosd(scene_phy(k))+ant_pos(2,:)*sind(scene_phy(k))))].';
    end

    % 考虑通道幅相误差情况下的引导向量A:
    A = diag(error_amp_phase)*A;
    % 考虑互藕情况下的引导向量A:
    A = mutual*A;
    % 求出信号自相关矩阵
%      self_correlation_matrix = A*diag(scene_power)*A';
     %当矩阵规模太大时，用矩阵分块算法
    N=10;
    scenepixel_num=size(scene_power,2) ;
    channels_num=size(A,1);
    self_correlation_matrix=zeros(channels_num,channels_num);
    scenepixel_div = round(scenepixel_num/N);
    for n=1:N-1
    S1=diag(scene_power(:,(n-1)*scenepixel_div+1:n*scenepixel_div));
    A1=A(:,(n-1)*scenepixel_div+1:n*scenepixel_div);
    self_correlation_matrix=self_correlation_matrix+A1*S1*A1';
    end
    
    
    S1=diag(scene_power(:,(N-1)*scenepixel_div+1:scenepixel_num));
    A1=A(:,(N-1)*scenepixel_div+1:scenepixel_num);
    self_correlation_matrix=self_correlation_matrix+A1*S1*A1';
    
    
    
    
    % 考虑通道本底对自相关矩阵的影响
    self_correlation_matrix = self_correlation_matrix + diag(error_amp)*diag(error_amp)*T_rec;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

