function corr_mat = ReadCorrMatH(file_name)
%%%%%%%%%%%% 读取一个可见度数据文件，获得Hermitian相关矩阵
%%%%%%%%%%%% 华中科技大学 熊祖彪，2008-10-10
fid1 = fopen(file_name,'r');
%读取矩阵的行与列大小
size_mat = fscanf(fid1,'%f\t%f',2);

%读取矩阵
xn=fscanf(fid1,'\r\n(%f,%f)\t',[size_mat(1)*2,size_mat(2)]);
fclose(fid1);

%将矩阵转换成与实际行列相等的上三角矩阵
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

%-----------------文件结束------------
