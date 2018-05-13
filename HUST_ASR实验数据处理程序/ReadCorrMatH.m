function corr_mat = ReadCorrMatH(file_name)
%%%%%%%%%%%% ��ȡһ���ɼ��������ļ������Hermitian��ؾ���
%%%%%%%%%%%% ���пƼ���ѧ ����룬2008-10-10
fid1 = fopen(file_name,'r');
%��ȡ����������д�С
size_mat = fscanf(fid1,'%f\t%f',2);

%��ȡ����
xn=fscanf(fid1,'\r\n(%f,%f)\t',[size_mat(1)*2,size_mat(2)]);
fclose(fid1);

%������ת������ʵ��������ȵ������Ǿ���
channel_num = size_mat(1);
corr_mat = zeros(channel_num, channel_num);
for column = 1:1:channel_num
    corr_mat(column,column) = xn(2*column-1,column)+i*xn(2*column,column);
    for row = column+1:1:channel_num
        corr_mat(column,row) = xn(2*row-1,column)+i*xn(2*row,column);
        corr_mat(row,column) = conj(corr_mat(column,row));
    end
end
%corr_mat = corr_mat.';

%-----------------�ļ�����------------
