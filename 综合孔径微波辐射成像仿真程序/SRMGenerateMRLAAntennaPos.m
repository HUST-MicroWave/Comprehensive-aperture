function norm_ant_position=SRMGenerateMRLAAntennaPos(ant_num)
%   函数功能：
%   求任意数目阵元时的最小冗余度线性阵列（MRLA）排列方式
%  
%   输入参数:%
%   ant_num     :阵元数目              
%
%   输出参数：
%   norm_ant_position     :归一化的阵元位置,第一个阵元位置记为0,其它阵元位置均为相对于第一个阵元的间距,单位间距取为1

%
%   范例:
%   求任意数目阵元时的最小冗余度线性阵列（MRLA）排列方式
%   ant_num = 16;
%   norm_ant_position = SRMGenerateMRLAAntennaPos(ant_num);
%   save result.mat norm_ant_position

%   董健，华中科技大学.
%   $版本号: 1.0 $  $Date: 2007/7/06 $

% D.A.Linebarger提出的MRLA排列算法
r=fix((ant_num-4)/6);                      % r,l为标识阵元间隔,间隔重复次数的变量
l=ant_num-4*r-3;
aperture_length=4*r*r+8*r+4*r*l+3*l+3;     %aperture_length为阵列的最大长度

element_spacing=SRMGetElementSpacing(r,l,ant_num);       % spacing为MRLA排列方式下的各阵元间隔

r=fix((ant_num-4)/6)+1;
l=ant_num-4*r-3;
temp=4*r*r+8*r+4*r*l+3*l+3;                %temp为第二次计算的aperture_length值

if(temp>aperture_length)                   %如果temp大于最初计算的aperture_length值,就将其设为阵列的最大长度
    aperture_length=temp;
    element_spacing=SRMGetElementSpacing(r,l,ant_num);
end

norm_ant_position=zeros(1,ant_num);             % ant_position为各阵元的位置
for i=1:ant_num
    for j=1:i-1
        norm_ant_position(i)=norm_ant_position(i)+element_spacing(j);
    end
end

%----------文件结束-----------
