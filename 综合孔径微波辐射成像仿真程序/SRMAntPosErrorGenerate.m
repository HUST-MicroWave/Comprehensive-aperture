function real_ant_pos = SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity,ant_pos_error_type);

%   �﷨��
%   real_ant_pos =  SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity,ant_pos_error_type);
% 
%   �������ܣ�
%   ����λ��������
%  
%   �������:
%   norm_ant_pos     ������������ʽ����2�����
%         ������������Ϊ1      ��һάֱ������
%         ������������Ϊ2      ��ƽ������
%   norm_min_spacing     ����С�������м������λΪ����         
%   ant_pos_error_quantity  �������������Ĵ�С
%   ant_pos_error_type  �����������������
%   ���������
%   real_ant_pos  :�������Ļ�������
% 
%   ����:
%   norm_min_spacing = 1/2;
%   norm_ant_pos = [0 2 5 6]; 
%   ant_pos_error_quantity =0.1;
%   real_ant_pos =SRMAntPosErrorGenerate(norm_min_spacing,norm_ant_pos,ant_pos_error_quantity);
% 
%   ����,���пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $

%�ж���һά���л���ƽ������
if(isvector(norm_ant_pos) == 1)
    flag = 1; %һά����
else
    flag = 0; %ƽ������
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%һά���е����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag ==1)
    % �õ��µĻ������У�
    switch lower(ant_pos_error_type)
        case 'normal'    %������̫�ֲ�
            real_ant_pos = norm_ant_pos + norm_min_spacing*ant_pos_error_quantity*randn(size(norm_ant_pos));%������
        case 'constant'  %���ʳ����ֲ�
            real_ant_pos = norm_ant_pos + ant_pos_error_quantity;
        case 'uniform'   %���ʾ��ȷֲ�
            real_ant_pos = norm_ant_pos + ((ant_pos_error_quantity(2)-ant_pos_error_quantity(1))*rand(size(norm_ant_pos))+ant_pos_error_quantity(1));
        otherwise        %���Ϊ�ֶ�����
            real_ant_pos = norm_ant_pos + ant_pos_error_type;    
    end
    real_ant_pos = sort(real_ant_pos); %��ֹ������ʱ������[0 2 1 3 4]�Ȳ���������
    real_ant_pos = real_ant_pos - real_ant_pos(1);%ʹ��һ������ʼ��Ϊ0����Ϊ�ο���
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%ƽ�����е����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(flag ==0)
    % �õ��µĻ������У�
    switch lower(ant_pos_error_type)
        case 'normal'    %������̫�ֲ�
            real_ant_pos = norm_ant_pos + norm_min_spacing*ant_pos_error_quantity*randn(size(norm_ant_pos));%������
        case 'constant'  %���ʳ����ֲ�
            real_ant_pos = norm_ant_pos + ant_pos_error_quantity;
        case 'uniform'   %���ʾ��ȷֲ�
            real_ant_pos = norm_ant_pos + ((ant_pos_error_quantity(2)-ant_pos_error_quantity(1))*rand(size(norm_ant_pos))+ant_pos_error_quantity(1));
        otherwise        %���Ϊ�ֶ�����
            real_ant_pos = norm_ant_pos + ant_pos_error_type;
    end
    real_ant_pos(1,:) = real_ant_pos(1,:) - real_ant_pos(1,1);%ʹ��һ������ʼ��Ϊ0����Ϊ�ο���
    real_ant_pos(2,:) = real_ant_pos(2,:) - real_ant_pos(2,1);%ʹ��һ������ʼ��Ϊ0����Ϊ�ο���
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%