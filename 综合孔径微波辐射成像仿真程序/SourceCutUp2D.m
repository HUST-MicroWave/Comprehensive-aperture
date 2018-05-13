function T_dist_source = SourceCutUp2D(scope_l,scope_m,power,center,hs)


% չԴ�зֺ���������Ԥ����Ƶ����񣬽��仮��Ϊ�����Դ
% center      չԴ����λ��
% hs          չԴ��߳�
% scope_l     Ԥ������
% power       չԴ������(K)

% Դ���ĵ������
source_center_lc = sind(center(1))*cosd(center(2));  %l����
source_center_mc = sind(center(1))*sind(center(2));  %m����
source_center = [source_center_lc source_center_mc];
% Դ�İ�߳�
source_deltalm = [sind(hs(1)) sind(hs(2))];
% ����İ�߳�
scope_deltalm = [(scope_l(2)-scope_l(1)) (scope_m(2)-scope_m(1))]/2;   
% Դ������İ�߳���
delta_scope_source = abs(source_deltalm-scope_deltalm);
% Դ������İ�߳���
sum_scope_source = source_deltalm+scope_deltalm;
% ��ʼ��Դ
T_dist_source = [];

for laxis = 1:length(scope_l)
    for maxis = 1:length(scope_m)
        % ����Դ���������������ĵľ���
        lspace = source_center_lc - scope_l(laxis); %l����
        mspace = source_center_mc - scope_m(maxis); %m����
        % �ж�Դ�������Ƿ��ཻ
        if (abs(lspace)<sum_scope_source(1)) && (abs(mspace)<sum_scope_source(2)) && ((scope_l(laxis)^2+scope_m(maxis)^2)<=1)
            %����l����ı������
            if (lspace<delta_scope_source(1))
                l_coef = 1;
            else
                l_coef = (lspace-delta_scope_source(1))/(sum_scope_source(1)-delta_scope_source(1));
            end
            %����l����ı������
            if (mspace<delta_scope_source(2))
                m_coef = 1;
            else
                m_coef = (mspace-delta_scope_source(2))/(sum_scope_source(2)-delta_scope_source(2));
            end
            %����Դ�������е����
            area = l_coef*m_coef;
            %����Ƕ�
            theta = asind(sqrt(scope_l(laxis)^2+scope_m(maxis)^2));
            phy = angle(scope_l(laxis)+j*scope_m(maxis))*180/pi;
            T_dist_k = real([power*area;theta;phy]);
            T_dist_source  = [T_dist_source  T_dist_k];            
        end
    end
end
