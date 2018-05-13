function [Visibility_unred_all,self_correlation_matrix] = GetUnred_Visibility(path,ant_pos,un_red_UV,channel_num,Remove_flag,polor_flag,cali_flag)
%读取可见度函数，生成自相关矩阵,并作冗余平均；
% 华中科技大学
%   Detailed explanation goes here
% 参数说明：
%path-可见度路径
%polor_flag-选择极化方式；
%cali_flag-定标天线的取舍；
% Remove_flag=1;
% judge_parameter;%剔除同一基线获得的可见度中偏差较大的值，judge_parameter为判断门限,或者取2倍的标准偏差；
% min_space=0.875;
V_0=0;  %零基线相关值；
un_red_UV=un_red_UV(:,1)+1i*un_red_UV(:,2);
UV_all=zeros(size(ant_pos,2),size(ant_pos,2),2);
for n1=1:size(ant_pos,2)
    for n2=1:size(ant_pos,2)
        UV_all(n1,n2,:)=(ant_pos(:,n2)-ant_pos(:,n1));
    end
end
UV_complex=UV_all(:,:,1)+1i*UV_all(:,:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 读取可见度函数，生成自相关矩阵；

visibility_all = Readdata2corrmat(path, channel_num);
%Recever_temp=load('I:\工作文档\SMOS数据反演\数据\接收机输出\recever_temp1.txt');
%visibility_zeros=diag(Recever_temp);
visibility_zeros=diag(V_0*ones(channel_num,1));
visibility_all=visibility_all+visibility_zeros;
% visibility_nonCal=visibility_all([4:24 28:48 52:72],[4:24 28:48 52:72]);%去除定标天线的相关值

if cali_flag==0
    visibility_nonCal=visibility_all([1 4:24 25 28:48 49 52:72],[1 4:24 25 28:48 49 52:72]);%去掉定标天线的相关值；
%     ant_pos=ant_pos(:,[3:23 26:46 49:69]);
    self_correlation_matrix=visibility_nonCal;
else
    switch polor_flag %选择所使用的极化方式；
    case 'VVV'%选择VVV极化方式
        visibility1=visibility_all([1 3:24 25 27:48 49 51:72],[1 3:24 25 27:48 49 51:72]);
    case 'HHH'%选择HHH极化方式
        visibility1=visibility_all([1:2 4:24 25:26 28:48 49:50 52:72],[1:2 4:24 25:26 28:48 49:50 52:72]);
%     case 'HVV'%选择HVV极化方式
%         visibility1=visibility_all([1 2 4:24  25 26 28:48 49 50 52:72],[1 2 4:24  25 26 28:48 49 50 52:72]);      
    end
  self_correlation_matrix=visibility1;
end
% 对可见度加窗;
% switch window_name
%     case {'Blackman','Hanning','Lanczos'}
%         W=zeros(size(self_correlation_matrix));
%         ant_num=size(self_correlation_matrix,1);
%         for k1=1:ant_num
%             for k2=1:ant_num
%                 dw=sqrt((real(UV_complex(k1,k2))).^2+(imag(UV_complex(k1,k2)).^2))/(sqrt(3)*ant_num*min_space);
%                 switch window_name
%                     case 'Blackman'
%                         W(k1,k2)=0.42+0.5*cos(pi*dw)+0.08*cos(2*pi*dw);%加Blackman窗；
%                     case 'Hanning'
%                         W(k1,k2)=0.5+0.5*cos(pi*dw);
%                     case 'Lanczos'
%                         W(k1,k2)=sin(pi*dw)/(pi*dw+0.001);
%                 end
%             end
%         end
%         self_correlation_matrix=self_correlation_matrix.*W;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 将可见度函数取冗余平均进行存储；
unred_conter=length(un_red_UV);
Visibility_unred_all=zeros(unred_conter,2);
Num=zeros(unred_conter,1);
for k=1:unred_conter
    Visibility_unred_all(k,1)=un_red_UV(k);
    UV_dd=abs(UV_complex-un_red_UV(k));
    [indexrows,indexcols]=find(UV_dd<=1e-10);
    datak=diag(self_correlation_matrix(indexrows,indexcols));
    if length(datak)==1;
        LENGTH=length(datak);
    else LENGTH=length(datak)-1;
    end
    sigma=sqrt(sum((abs(datak)-abs(imag(datak))).^2)/LENGTH);
    if Remove_flag==0
        sumk=sum(datak);
        Num(k)=length(datak);
    else
        indexk1=find(abs(datak)>=1e-10);
        datak=datak(indexk1);
        meank=mean(datak);
        judge_parameter=2*sigma;
        indexk=find(abs(datak-meank) >= judge_parameter);
        datak(indexk)=0;
        sumk=sum(datak);
        Num(k)=length(datak)-length(indexk)+0.0001;
    end
    Visibility_unred_all(k,2)=sumk./(Num(k));
   %Visibility_unred_all(k,2)=self_correlation_matrix(indexrows(1),indexcols(1));
end
Visibility_unred_all=Visibility_unred_all(:,2);
end



