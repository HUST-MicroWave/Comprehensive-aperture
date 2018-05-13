function T_dist_source = SourceCutUp2D(scope_l,scope_m,power,center,hs)


% 展源切分函数，按照预先设计的网格，将其划分为多个点源
% center      展源中心位置
% hs          展源半边长
% scope_l     预设网格
% power       展源的能量(K)

% 源中心点的坐标
source_center_lc = sind(center(1))*cosd(center(2));  %l方向
source_center_mc = sind(center(1))*sind(center(2));  %m方向
source_center = [source_center_lc source_center_mc];
% 源的半边长
source_deltalm = [sind(hs(1)) sind(hs(2))];
% 网格的半边长
scope_deltalm = [(scope_l(2)-scope_l(1)) (scope_m(2)-scope_m(1))]/2;   
% 源与网格的半边长差
delta_scope_source = abs(source_deltalm-scope_deltalm);
% 源与网格的半边长和
sum_scope_source = source_deltalm+scope_deltalm;
% 初始化源
T_dist_source = [];

for laxis = 1:length(scope_l)
    for maxis = 1:length(scope_m)
        % 计算源的中心与网格中心的距离
        lspace = source_center_lc - scope_l(laxis); %l方向
        mspace = source_center_mc - scope_m(maxis); %m方向
        % 判断源与网格是否相交
        if (abs(lspace)<sum_scope_source(1)) && (abs(mspace)<sum_scope_source(2)) && ((scope_l(laxis)^2+scope_m(maxis)^2)<=1)
            %计算l方向的比例面积
            if (lspace<delta_scope_source(1))
                l_coef = 1;
            else
                l_coef = (lspace-delta_scope_source(1))/(sum_scope_source(1)-delta_scope_source(1));
            end
            %计算l方向的比例面积
            if (mspace<delta_scope_source(2))
                m_coef = 1;
            else
                m_coef = (mspace-delta_scope_source(2))/(sum_scope_source(2)-delta_scope_source(2));
            end
            %计算源在网格中的面积
            area = l_coef*m_coef;
            %计算角度
            theta = asind(sqrt(scope_l(laxis)^2+scope_m(maxis)^2));
            phy = angle(scope_l(laxis)+j*scope_m(maxis))*180/pi;
            T_dist_k = real([power*area;theta;phy]);
            T_dist_source  = [T_dist_source  T_dist_k];            
        end
    end
end
