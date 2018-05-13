function [ant_pos,antenna_num] = SRMAntPosGenerate(array_type,array_num);

%   �﷨��
%   ant_pos = SRMAntPosGenerate(array_type,array_num);
% 
%   �������ܣ�
%   ����λ�ò�������
%  
%   �������:
% array_type     ��������ʽ�������¼������
%         'mrla'         ����С������
%         'Y_shape'      :Y����
%         'T_shape'      :T����
% array_num      �����߸��� 
%   ���������
% ant_pos  :��������
% 
%   ����:
% array_type = 'Y_type' 
% array_num =24;
% ant_pos = SRMAntPosGenerate(array_type,array_num);
% 
%   ���ţ����пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2008/01/01 $



if (ischar(array_type)==0)
    %�ֶ�����Ĺ���
    ant_pos = array_type;
    antenna_num = size(ant_pos,2);
else
    %���е���ʽ��AntennaPositionHELP()
    switch array_type
        case 'mrla'
            %��С������
            ant_pos = SRMGenerateMRLAAntennaPos(array_num);
            antenna_num = array_num;
        case 'ula'
            %����ֱ����
            ant_pos = [0:array_num-1];
            antenna_num = array_num;
        case 'Y_shape'
            %����Y����
            cell = array_num/3-1:-1:0;
            cell1 = (-j)*cell;
            cell2 = (cell+1)*exp(j*pi/6);
            cell3 = cell*exp(j*pi*5/6)+j;
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;
        case 'y_shape'
            %��ͨY����
            cell = (array_num-1)/3:-1:1;
            cell1 = (-j)*cell;
            cell2 = cell*exp(j*pi/6);
            cell3 = cell*exp(j*pi*5/6);
            ant_pos_x = [0 real([cell1 cell2 cell3])];
            ant_pos_y = [0 imag([cell1 cell2 cell3])];
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;
        case 'T_shape'
            %T����
            cell = array_num/3:-1:1;
            cell1 = (-j)*cell;
            cell2 = cell;
            cell3 = (-1)*cell;
            ant_pos_x = real([cell1 cell2 cell3]);
            ant_pos_y = imag([cell1 cell2 cell3]);
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;
        case 'O_shape'
            %Բ����
            cell_angle = 0:array_num-1;
            cell = exp(j*cell_angle*2*pi/array_num);
            ant_pos_x = real(cell);
            ant_pos_y = imag(cell);
            ant_pos = [ant_pos_x;ant_pos_y];
            antenna_num = array_num;            
    end
end