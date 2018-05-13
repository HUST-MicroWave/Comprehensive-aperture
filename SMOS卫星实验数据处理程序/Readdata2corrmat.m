function visibility_all = Readdata2corrmat(path, channel_num)
%��ȡL1a�Ŀɼ������ݲ�����ת��Ϊʵ�ʵ�����ؾ���
% ���пƼ���ѧ

visibility_all=zeros(channel_num, channel_num);

filename=sprintf('%s.txt',path);

corr_mat1=load(filename);

%������ת����ʵ�ʵĸ�����
if size(corr_mat1,2)==2 %����������Ǹ����󣬵�һ����ʵ�����ڶ������鲿�������Ϊ�������д洢��
    corr_mat_real=corr_mat1(:,1)';
    corr_mat_imag=corr_mat1(:,2)';
    corr_mat=corr_mat_real+1i*corr_mat_imag;
end
%%
%���ɼ������ݳ��ϻ���Ȩϵ����
%�������Ȩϵ����
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
    %��������ǿɼ������ݣ�����ת����Hermmit������������ƺ�����ϵ��������������ת����
    visibility_all=visibility_all+visibility_all';
end
end