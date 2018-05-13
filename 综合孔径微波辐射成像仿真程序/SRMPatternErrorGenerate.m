function real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);

%   �﷨��
%   real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);
% 
%   �������ܣ�
%   ��������ͼ���
%  
%   �������:
%   coef_matrix  ������ͼ����
%   pattern_error_quantity     ������ͼ����С
%   antenna_num    �����߸���
%   pattern_error_type :����ͼ�������
%   ���������
%   real_coef_matrix  :�������ߵķ���ͼ���󣬷�װ��cell��
% 
%   ����:
% 
%   coef_matrix = ones(4,5);
%   pattern_error_quantity = 0.1;
%   antenna_num = 24;
%   pattern_error_type = 'normal';
%   real_coef_matrix = SRMPatternErrorGenerate(coef_matrix,pattern_error_quantity,antenna_num,pattern_error_type);
% 
%   ���ţ����пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $

for antenna_seria = 1:antenna_num%��ÿ�����߶������²���
    switch lower(pattern_error_type)
        case 'normal'
            error_coef_matrix = coef_matrix + pattern_error_quantity*randn(size(coef_matrix));%�������ע��
        case 'constant'
            error_coef_matrix = coef_matrix + pattern_error_quantity;%�������ע��
        case 'uniform'
            error_coef_matrix = coef_matrix + (pattern_error_quantity(2)-pattern_error_quantity(1))*rand(size(coef_matrix))+pattern_error_quantity(1);%�������ע��
    end
    % ע���������֮����Ҫ�Է���ͼ���¹�һ��
    %ʹ�÷���ͼ������[0 1]��Χ�ڣ�
    for p = 1:size(error_coef_matrix,1)
        for q = 1:size(error_coef_matrix,2)
            if(error_coef_matrix(p,q)>1)
                error_coef_matrix(p,q) = 1;
            elseif(error_coef_matrix(p,q)<0)
                error_coef_matrix(p,q) = 0;
            end
        end
    end
    real_coef_matrix(antenna_seria) = {error_coef_matrix};%��װ��cell��
end
