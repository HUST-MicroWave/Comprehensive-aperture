function ant_pair_baseline=GetAntPairBaseline(norm_ant_position)
%   函数功能：
%   求给定的一种MRLA排列方式下，任一基线所对应的天线对
%  
%   输入参数:%
%   norm_ant_position     :归一化的阵元位置,第一个阵元位置记为0,其它阵元位置均为相对于第一个阵元的间距,单位间距取为1            
%
%   输出参数：
%   ant_pair_baseline     :存储任一基线所对应的天线对编号的矩阵
%
%   范例:
%   求给定的一种MRLA排列方式下，任一基线所对应的天线对
%   norm_ant_position=[0     1     2     5    10    15    26    37    48     59    70    76    82    88    89    90];
%   ant_pair_baseline = GetAntPairBaseline(norm_ant_position);
%   save result.mat ant_pair_baseline

%   董健，华中科技大学.
%   $版本号: 1.0 $  $Date: 2007/7/06 $

ant_num=length(norm_ant_position);
 baseline=zeros(ant_num,ant_num);   % baseline存储由所有天线对构成的基线
for i=1:ant_num-1
    for j=i+1:ant_num
        baseline(i,j)=norm_ant_position(j)-norm_ant_position(i);        
    end
end

baseline_max=norm_ant_position(ant_num);   % baseline_max为最大基线

%以矩阵件形式存储任一基线所对应的天线对编号
ant_pair_baseline=zeros(ant_num*(ant_num-1)/2,3);
flag=1;                    %标识号
for k=1:baseline_max
    for i=1:ant_num-1
        for j=i+1:ant_num
            if k==baseline(i,j)
                 ant_pair_baseline(flag,1)=k;           %矩阵第一列存储基线号
                 ant_pair_baseline(flag,2)=i;           %矩阵第二列存储天线1编号
                 ant_pair_baseline(flag,3)=j;           %矩阵第三列存储天线2编号
                 flag=flag+1;
            end            
        end
    end
    
end

%----------文件结束----------