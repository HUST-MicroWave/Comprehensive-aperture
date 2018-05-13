function mutual_matrix = SRMMutualErrorGenerate(min_spacing,ant_pos,mutual_error_quantity,mutual_error_type);

%   �﷨��
%   mutual_matrix = SRMMutualErrorGenerate(min_spacing,ant_pos,mutual_error_quantity,mutual_error_type);
% 
%   �������ܣ�
%   �����������
%  
%   �������:
%   ant_pos     ������������ʽ����2�����
%         ������������Ϊ1      ��һάֱ������
%         ������������Ϊ2      ��ƽ������
%   min_spacing     ����С�������м������λΪ����
%   mutual_error_quantity    �������С 
%   mutual_error_type  ����������
%   ���������
%   mutual_matrix  :�������
% 
%   ����:
% 
%   min_spacing = 1/2;
%   ant_pos = [0 2 5 6]; 
%   mutual_error_quantity = 0.01;
%   mutual_error_type = 'normal';
%   mutual_matrix = SRMMutualErrorGenerate(min_spacing,ant_pos,mutual_error_quantity,mutual_error_type);
% 
%  ���ţ����пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $


if(ischar(mutual_error_type)==0)       %�������Ϊ�ֶ�����
    mutual_matrix = mutual_error_type;
else
    %���߸���:
    ata_num = length(ant_pos(1,:));
    %�������ģ����������ͬ��Ӧ�������߾���ԽԶ������ԽС��ԭ��
    if(isvector(ant_pos) == 1)%�����һά����
        ant_pos(2,:) = zeros(1,ata_num);%����ת��Ϊ����λ�þ�Ϊ0��ƽ�����У��Ա�ͳһ����
    end

    % �õ��������distance_matrix,���i�е�j�е�Ԫ�ر�ʾ��i���������j�����ߵľ����
    distance_matrix = zeros(ata_num,ata_num);%��ʼ��
    for p = 1:ata_num
        for q = 1:ata_num
            if(q>p)
                distance_matrix(p,q) = abs((ant_pos(1,q)-ant_pos(1,p))+j*(ant_pos(2,q)-ant_pos(2,p)));
            end
        end
    end
    % ���������ǻ�����󣬻����С�����ɷ���
    mutual_matrix = zeros(ata_num,ata_num);%��ʼ��
    for p = 1:ata_num
        for q = 1:ata_num
            if(q>p)
                switch lower(mutual_error_type)
                    case 'normal'
                        %�����������ϵ�������С��mutual_error_quantity�����ȣ������ɷ���
                        mutual_matrix(p,q) = randn(1,1)*mutual_error_quantity/(min_spacing*distance_matrix(p,q));
                        mutual_matrix(p,q) = abs(mutual_matrix(p,q));
                    case 'constant'
                        mutual_matrix(p,q) = mutual_error_quantity/(min_spacing*distance_matrix(p,q));
                    case 'uniform'
                        %�����������ϵ�������С��mutual_error_quantity�����ȣ������ɷ���
                        mutual_matrix(p,q) = (rand(1,1)*(mutual_error_quantity(2)-mutual_error_quantity(1))+mutual_error_quantity(1))/(min_spacing*distance_matrix(p,q));
                end
            end
        end
    end
    % �����������
    mutual_matrix = mutual_matrix+mutual_matrix.';             %�ǶԽ��߲���ӦΪ�ԳƵ�
    mutual_matrix_diag = ones(1,ata_num)-sum(mutual_matrix);   %�Խ��߲���Ӧ��ȥ������ʧ��������
    mutual_matrix = mutual_matrix+diag(mutual_matrix_diag);    %���������ֽ�ϻ�û������
end



