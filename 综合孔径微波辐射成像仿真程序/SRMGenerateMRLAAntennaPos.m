function norm_ant_position=SRMGenerateMRLAAntennaPos(ant_num)
%   �������ܣ�
%   ��������Ŀ��Ԫʱ����С������������У�MRLA�����з�ʽ
%  
%   �������:%
%   ant_num     :��Ԫ��Ŀ              
%
%   ���������
%   norm_ant_position     :��һ������Ԫλ��,��һ����Ԫλ�ü�Ϊ0,������Ԫλ�þ�Ϊ����ڵ�һ����Ԫ�ļ��,��λ���ȡΪ1

%
%   ����:
%   ��������Ŀ��Ԫʱ����С������������У�MRLA�����з�ʽ
%   ant_num = 16;
%   norm_ant_position = SRMGenerateMRLAAntennaPos(ant_num);
%   save result.mat norm_ant_position

%   ���������пƼ���ѧ.
%   $�汾��: 1.0 $  $Date: 2007/7/06 $

% D.A.Linebarger�����MRLA�����㷨
r=fix((ant_num-4)/6);                      % r,lΪ��ʶ��Ԫ���,����ظ������ı���
l=ant_num-4*r-3;
aperture_length=4*r*r+8*r+4*r*l+3*l+3;     %aperture_lengthΪ���е���󳤶�

element_spacing=SRMGetElementSpacing(r,l,ant_num);       % spacingΪMRLA���з�ʽ�µĸ���Ԫ���

r=fix((ant_num-4)/6)+1;
l=ant_num-4*r-3;
temp=4*r*r+8*r+4*r*l+3*l+3;                %tempΪ�ڶ��μ����aperture_lengthֵ

if(temp>aperture_length)                   %���temp������������aperture_lengthֵ,�ͽ�����Ϊ���е���󳤶�
    aperture_length=temp;
    element_spacing=SRMGetElementSpacing(r,l,ant_num);
end

norm_ant_position=zeros(1,ant_num);             % ant_positionΪ����Ԫ��λ��
for i=1:ant_num
    for j=1:i-1
        norm_ant_position(i)=norm_ant_position(i)+element_spacing(j);
    end
end

%----------�ļ�����-----------
