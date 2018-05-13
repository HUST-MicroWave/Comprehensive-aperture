function re_self_correlation_matrix = SRMCorrelationSim(self_correlation_matrix,sampling_num,error_Qphase)

% ��������ؾ���ľ�ֵ���������ģ�����ɷ�������ؾ���
% �ú������ɵ�����ؾ���ľ�ֵ���䣬����ͨ����˹��������
% ���пƼ���ѧ

%���߸���
antenna_num = length(self_correlation_matrix(1,:));
% ��������ؾ���ķ���:
for p = 1:antenna_num
    for q = 1:antenna_num
        correlation_matrix_var(p,q) = self_correlation_matrix(p,p)*self_correlation_matrix(q,q)/sampling_num;
    end
end

% ������׼���������
% ��������ʼ��
error_matrix = zeros(antenna_num,antenna_num);
% �����������
for p = 2:antenna_num
    for q = 1:p-1
        error_matrix(p,q) = (randn(1,1)+j*randn(1,1))/sqrt(2);
    end
end
% ��֤��������hermite����
error_matrix = error_matrix+error_matrix';
% ��֤�������ĶԽ���Ϊʵ��
for k = 1:antenna_num  
    error_matrix(k,k) = randn(1,1); %�Խ�����Ϊʵ�������
end

% �������������
error_matrix = error_matrix.*sqrt(correlation_matrix_var);
self_correlation_matrix = self_correlation_matrix + error_matrix;

%%%% ������������
error_Qphase_matrix = error_Qphase;
% ��ȡ�ɼ�����λ
angle_matrix = angle(self_correlation_matrix);
% ��ȡ�ɼ��ȷ���
amp_matrix = abs(self_correlation_matrix);
% ����������ɼ���ʵ�����䣬�ı�ɼ����鲿�Ӷ��ı�����Ƕ�
re_self_correlation_matrix = amp_matrix.*cos(angle_matrix) + j*amp_matrix.*sin(angle_matrix-error_Qphase_matrix);

