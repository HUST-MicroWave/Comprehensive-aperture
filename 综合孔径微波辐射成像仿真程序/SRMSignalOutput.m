function self_correlation_matrix = SRMSignalOutput(T_dist,ant_pos,min_spacing,pattern_coef,mutual,T_rec,error_amp,error_Iphase,error_Qphase);

%   �﷨��
%   self_correlation_matrix = SRMSignalOutput(sampling_num,T_dist,ant_pos,min_spacing,pattern_coef,mutual,T_rec,error_amp,error_Iphase,error_Qphase);
% 
%   �������ܣ�
%   ��ȡ��Ӧ��Ϣ�����������ź������
%  
%   �������:
%              
% T_dist     �����߿����������·ֲ����󣬷�3�����
%     ������������Ϊ2      ��һάֱ������
%     ������������Ϊ3      ��ƽ�����У�������Դ
%     ����������������3      ��ƽ�����У����ӳ���
% ant_pos     ������������ʽ����2�����
%     ������������Ϊ1      ��һάֱ������
%     ������������Ϊ2      ��ƽ������
% min_spacing     ����С�������м������λΪ����
% pattern_coef    �����߷���ͼ�������߿����������·ֲ��������Ӧ
% mutual      :���߻������
%   ���������
%self_correlation_matrix       : ����ؾ���
% 
%   ����:
% 
% source_place = [-20 0 20 30]; %��������
% source_power = [1 1 1.5 2];  %Դ�Ĺ���
% T_dist = [source_power;source_place];
% min_spacing = 1/2;
% ant_pos = [0 2 5 6]; 
% pattern_coef = [1 1 1 1]; %����4���źŶ�Ӧ�ķ���ͼ��Ȩ
% T_rec = 10;
% error_amp = [1 1 1 1];
% error_Iphase = [0 0 0 0];
% error_Qphase = [0 0 0 0];
% mutual = eye(4);
% self_correlation_matrix = SRMSignalOutput(sampling_num,T_dist,ant_pos,min_spacing,pattern_coef,mutual,T_rec,error_amp,error_Iphase,error_Qphase);
% IAM_SAR_jr(self_correlation_matrix,min_spacing*ant_pos,'standard');
% 
%   ���ţ����пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $




%���߸���
antenna_num = length(ant_pos(1,:));
%���еĻ������е��ڻ��ߵ���С�ߴ�˻�������
ant_pos =  min_spacing*ant_pos; 
%ͨ���������
error_amp_phase = exp(j*error_Iphase).*error_amp;

%�ж���һά���л���ƽ������
if(isvector(ant_pos) == 1)
    flag = 1; %һά����
else
    flag = 0; %ƽ������
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%һά���е����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag==1)
    %����������Ϣ
    scene_power = T_dist(1,:); %Դ�Ĺ�������
    scene_theta = T_dist(2,:); %Դ��λ������
    
    for k = 1:antenna_num %��ȡ��Ԫ���߷���ͼ
        coef_matrix(k,:) = cell2mat(pattern_coef(k));
    end
    
    % ������������A��
    for k=1:length(scene_power)
        A(:,k)=sqrt(coef_matrix(:,k)).*[exp(2*pi*j*ant_pos*sind(scene_theta(k)))].';       
    end
    
    % ����ͨ�������������µ���������A:
    A = diag(error_amp_phase)*A;
    % ���ǻ�ź����µ���������A:
    A = mutual*A;   
    % ����ź�����ؾ���
    self_correlation_matrix = A*diag(scene_power)*A';
    % ����ͨ������������ؾ����Ӱ��
    self_correlation_matrix = self_correlation_matrix + diag(error_amp)*diag(error_amp)*T_rec;   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%ƽ�����е����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag ==0)    
    scene_power = T_dist(1,:); %Դ�Ĺ�������
    scene_theta = T_dist(2,:); %Դ��λ������theta
    scene_phy = T_dist(3,:);   %Դ��λ������phy
    
    for k = 1:antenna_num%��ȡ��Ԫ���߷���ͼ
        coef_matrix(k,:) = cell2mat(pattern_coef(k));
    end

    % ������������A��
    for k=1:length(scene_power)
        A(:,k)=sqrt(coef_matrix(:,k)).*[exp(2*pi*j*sind(scene_theta(k))*(ant_pos(1,:)*cosd(scene_phy(k))+ant_pos(2,:)*sind(scene_phy(k))))].';
    end

    % ����ͨ�������������µ���������A:
    A = diag(error_amp_phase)*A;
    % ���ǻ�ź����µ���������A:
    A = mutual*A;
    % ����ź�����ؾ���
%      self_correlation_matrix = A*diag(scene_power)*A';
     %�������ģ̫��ʱ���þ���ֿ��㷨
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
    
    
    
    
    % ����ͨ�����׶�����ؾ����Ӱ��
    self_correlation_matrix = self_correlation_matrix + diag(error_amp)*diag(error_amp)*T_rec;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

