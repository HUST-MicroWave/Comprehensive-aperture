function visibility_all = Readdata2corrmat(path, channel_num)
%读取L1a的可见度数据并将其转换为实际的自相关矩阵；
% 华中科技大学

visibility_all=zeros(channel_num, channel_num);

filename=sprintf('%s.txt',path);

corr_mat1=load(filename);

%将矩阵转换成实际的复矩阵
if size(corr_mat1,2)==2 %如果导出的是复矩阵，第一列是实部，第二列是虚部，将其变为复数进行存储；
    corr_mat_real=corr_mat1(:,1)';
    corr_mat_imag=corr_mat1(:,2)';
    corr_mat=corr_mat_real+1i*corr_mat_imag;
end
%%
%将可见度数据乘上基线权系数；
%导入基线权系数；
% load Weights.mat
% corr_mat=corr_mat.*Weights';
%%
%end
start=1;
end1=channel_num-1;
for k=1:channel_num-1
    visibility_all(k,k+1:channel_num)=corr_mat(start:end1);
    start=end1+1;
    end1=end1+channel_num-k-1;
end
if size(corr_mat1,2)==2
    %如果读的是可见度数据，则将其转换成Hermmit阵，如果是消条纹函数的系数或其他参数则不转换；
    visibility_all=visibility_all+visibility_all';
end
end