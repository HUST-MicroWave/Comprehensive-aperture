function ant_pair_baseline=GetAntPairBaseline(norm_ant_position)
%   �������ܣ�
%   �������һ��MRLA���з�ʽ�£���һ��������Ӧ�����߶�
%  
%   �������:%
%   norm_ant_position     :��һ������Ԫλ��,��һ����Ԫλ�ü�Ϊ0,������Ԫλ�þ�Ϊ����ڵ�һ����Ԫ�ļ��,��λ���ȡΪ1            
%
%   ���������
%   ant_pair_baseline     :�洢��һ��������Ӧ�����߶Ա�ŵľ���
%
%   ����:
%   �������һ��MRLA���з�ʽ�£���һ��������Ӧ�����߶�
%   norm_ant_position=[0     1     2     5    10    15    26    37    48     59    70    76    82    88    89    90];
%   ant_pair_baseline = GetAntPairBaseline(norm_ant_position);
%   save result.mat ant_pair_baseline

%   ���������пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2007/7/06 $

ant_num=length(norm_ant_position);
 baseline=zeros(ant_num,ant_num);   % baseline�洢���������߶Թ��ɵĻ���
for i=1:ant_num-1
    for j=i+1:ant_num
        baseline(i,j)=norm_ant_position(j)-norm_ant_position(i);        
    end
end

baseline_max=norm_ant_position(ant_num);   % baseline_maxΪ������

%�Ծ������ʽ�洢��һ��������Ӧ�����߶Ա��
ant_pair_baseline=zeros(ant_num*(ant_num-1)/2,3);
flag=1;                    %��ʶ��
for k=1:baseline_max
    for i=1:ant_num-1
        for j=i+1:ant_num
            if k==baseline(i,j)
                 ant_pair_baseline(flag,1)=k;           %�����һ�д洢���ߺ�
                 ant_pair_baseline(flag,2)=i;           %����ڶ��д洢����1���
                 ant_pair_baseline(flag,3)=j;           %��������д洢����2���
                 flag=flag+1;
            end            
        end
    end
    
end

%----------�ļ�����----------