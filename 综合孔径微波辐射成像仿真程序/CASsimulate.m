function T_dist = CASsimulate(Fov,delta,CAS_param,div)

% ��ȡ���·ֲ�
% Fov �ӳ���λ[-1 1]:һά�� [-1 1 ��ƽ����
%                           -1 1]
% delta һ���ֱ����µ��ӳ���С��� [0.01]:һά�� [0.01 0.02]��ƽ����
% div   �����ӳ����ֹ��� *SpaceDivisionHELP()
% ���пƼ���ѧ

%%%%%%�����Դ������%%%%%%%
if CAS_param.idealpoint_simu==1
    % ���������Դ��λ�ò���
    place = CAS_param.idealpoint_place;
    if size(place,1)==1 %һά����
        % �������Դ��������ֵ��Ч��һ���ֱ��ʵ�Ԫ��
        power = CAS_param.idealpoint_power*delta/(Fov(2)-Fov(1));
        T_dist_point = [power;place];
    end
    if size(place,1)==2 %ƽ������
        % �������Դ��������ֵ��Ч��һ���ֱ��ʵ�Ԫ��
        power = CAS_param.idealpoint_power*delta(1)*delta(2)/(Fov(1,2)-Fov(1,1))/(Fov(2,2)-Fov(2,1));
        T_dist_point = [power;place];
    end
else
    %�������Դ����ʱ
    T_dist_point = [];
end


T_dist = T_dist_point;

          
            
            

    
    

