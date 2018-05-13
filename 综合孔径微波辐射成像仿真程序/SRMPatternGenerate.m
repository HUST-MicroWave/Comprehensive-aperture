function coef_matrix = SRMPatternGenerate(antenna_pattern_info,angle_info,array_type);
%   �﷨��
%   coef_matrix = SRMPatternGenerate(antenna_pattern_info,angle_info,array_type);
% 
%   �������ܣ�
%   �������ߵ���״�ͳߴ磬��ʽ��������ĳЩ�����ϵķ���ͼ
%  
%   �������: 
% antenna_pattern_info�ṹ�壺
%     antenna_type   ��������״�������¼��������ѡ
%         'isotropic'  ���룬���������Ϊ1
%         'rectangle'   ���ο���
%         'circle'     Բ�ο���
%     wavelength     �����߹�������
%     antenna_size   �����߳ߴ磬�����¼���������������Ӧ
%         ������д
%         2��Ԫ�ص���������һ��Ԫ��Ϊ�����ڶ���Ԫ��Ϊ��
%         1��Ԫ�أ�Ϊ���߰뾶
% array_type      ��ƽ������һάֱ����������2�����
%         1       ��һάֱ������
%         0       ��ƽ����
% angle_info      ���Ƕ���Ϣ����������Щ�Ƕȵķ���ͼ��������3�����
%     ������������Ϊ1      ��һάֱ�����еķ����
%     ������������Ϊ2      ��ƽ�����У�������Դ�ķ����theta��phy
%     2��Ԫ�ص�����      ��ƽ�����У����ӳ�����theta���ֳɵķ�����phy���ֳɵķ���
%         
%   ���������
%   coef_matrix       :ָ���Ƕȵķ���ͼ
% 
%   ����:
% antenna_pattern_info.antenna_type = 'rectangle';
% antenna_pattern_info.wavelength = 0.008;
% antenna_pattern_info.antenna_size = [0.008 0.008];
% angle_info = [-90:90];
% array_type = 1;
% coef_matrix = SRMPatternGenerate(antenna_pattern_info,angle_info,array_type);
% plot(coef_matrix);
%
%   ���ţ����пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $

% �������룺
antenna_type = antenna_pattern_info.antenna_type; %�������ʹӽṹ���л�ȡ
antenna_size = antenna_pattern_info.antenna_size; %���߳ߴ�ӽṹ���л�ȡ
wavelength = antenna_pattern_info.wavelength;     %���߹��������ӽṹ���л�ȡ

%%%%%%%%%%%%%%%%%����ͼΪ�ֶ�����%%%%%%%
if(ischar(antenna_type)==0) 
    coef_matrix = antenna_type;  %ֱ�Ӷ�ȡ
    array_type = 2;              %����������������
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%һά�����%%%%%%%%%%%%%%%%%%%%%


if(array_type==1) %һά�����
    %������ʽ��
    switch lower(antenna_type)
        case 'rectangle'% ���ο���
            lx = pi*antenna_size(1)/wavelength;
            for k = 1:length(angle_info)
                coef_matrix(k) = abs(cosd(angle_info(k))*sinc(lx*sind(angle_info(k))));
            end
            %�������߽���

        case'isotropic'%���룬���������Ϊ1
            coef_matrix = ones(size(angle_info));
            %�������߽���

        case'circle'%Բ�ο���
            Ba = 2*pi*antenna_size/wavelength;
            for k = 1:length(angle_info)
                if (abs(sind(angle_info(k)))<=0.0001) %�����ĸΪ0ʱ����
                    coef_matrix(k) = 1;
                else
                    coef_matrix(k) = abs(2*real(besselj(1,Ba*sind(angle_info(k))))/(Ba*sind(angle_info(k))));
                end
            end
            %Բ�����߽���
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ƽ�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(array_type==0)  %ƽ�������
    %������ʽ��
    switch lower(antenna_type)
        case 'rectangle'% ���ο���
            lx = pi*antenna_size(1)/wavelength;
            ly = pi*antenna_size(2)/wavelength;
            source_num = length(angle_info(1,:));
            for k = 1:source_num
                u = sind(angle_info(1,k))*cosd(angle_info(2,k));
                v = sind(angle_info(1,k))*sind(angle_info(2,k));
                coef_matrix(k) = abs(sinc(lx*u)*sinc(ly*v));
            end
            %�������߽���

        case'isotropic'%���룬���������Ϊ1
            coef_matrix = ones(1,length(angle_info(1,:)));
            %�������߽���

        case'circle'%Բ�ο���
            Ba = 2*pi*antenna_size/wavelength;
            source_num = length(angle_info(1,:));
            for k = 1:source_num
                if(sind(angle_info(1,k))<=0.0001)  %�����ĸΪ0ʱ����
                    coef_matrix(k) = 1;
                else
                    coef_matrix(k) = abs(2*real(besselj(1,Ba*sind(angle_info(1,k))))/(Ba*sind(angle_info(1,k))));
                end
            end
            %Բ�����߽���
    end
end


