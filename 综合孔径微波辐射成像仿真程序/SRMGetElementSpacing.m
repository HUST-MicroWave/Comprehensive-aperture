function element_spacing=GetElementSpacing(r,l,ant_num)
%   函数功能：
%   求MRLA阵列中各阵元的间距
%  
%   输入参数:%
%   ant_num     :阵元数目              
%   r,l         :r,l为标识阵元间隔,间隔重复次数的变量
%
%   输出参数：
%   spacing     :各阵元间距
%
%   范例:
%   求MRLA阵列中各阵元的间距
%   
%   ant_num = 16;
%   r=2;
%   l=5;
%   element_spacing = GetElementSpacing(r,l,ant_num);
%   save result.mat element_spacing

%  董健，华中科技大学.
%   $版本号: 1.0 $  $Date: 2007/7/06 $

element_spacing=zeros(1,ant_num-1);
for i=1:r
    element_spacing(i)=1;
end
element_spacing(r+1)=r+1;
for i=r+2:2*r+1
    element_spacing(i)=2*r+1;
end
for i=2*r+2:2*r+1+l
    element_spacing(i)=4*r+3;
end
for i=2*r+2+l:3*r+2+l
    element_spacing(i)=2*r+2;
end
for i=3*r+3+l:ant_num-1
    element_spacing(i)=1;
end

%----------文件结束----------