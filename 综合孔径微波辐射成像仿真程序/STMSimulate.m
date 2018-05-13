function T_dist = STMSimulate(Fov,delta,STM_param,div)

% ��ȡ���·ֲ�
% Fov �ӳ���Χ    [-1 1]:һά�� [-1 1 ��ƽ����
%                                 -1 1]
% delta һ���ֱ����µ��ӳ���С��� [0.01]:һά�� [0.01 0.02]��ƽ����
% div   �����ӳ����ֹ��� *SpaceDivisionHELP()
% ���пƼ���ѧ


%%%%%%�����Դ������%%%%%%%
if STM_param.idealpoint_simu==1
    % ���������Դ��λ�ò���
    place = STM_param.idealpoint_place;
    if size(place,1)==1 %һά����
        % �������Դ��������ֵ��Ч��һ���ֱ��ʵ�Ԫ��
        power = STM_param.idealpoint_power*delta/(Fov(2)-Fov(1));
        T_dist_point = [power;place];
    end
    if size(place,1)==2 %ƽ������
        % �������Դ��������ֵ��Ч��һ���ֱ��ʵ�Ԫ��
        power = STM_param.idealpoint_power*delta(1)*delta(2)/(Fov(1,2)-Fov(1,1))/(Fov(2,2)-Fov(2,1));
        T_dist_point = [power;place];
        % ����Y���󣬰��վ������񻮷ֵķֱ���С����ʵ�ʰ��������λ��ֵ�������ˣ��ڼ���������ʱ��Ҫ��������������
        if lower(STM_param.array_type) == 'y_shape'
            T_dist_point(1,:) = T_dist_point(1,:)*8/3;
        end
    end
else
    %�������Դ����ʱ
    T_dist_point = [];
end

%%%%%%չԴ������%%%%%%%
if STM_param.extentpoint_simu == 1
    
    %%%%%%һά����%%%%%%%%%%%    
    if(size(Fov,1)==1)   %�ж������Ƿ�Ϊһά����
        % ��ʼ��չԴ
        T_dist_extent = [;];
        % �Կռ䰴��Ԥ��Ļ��ֵķ������л��֣���ÿռ仮�ֵķ���
        division = SpaceDivisionSelect(div,delta);
        % ���ջ��ֻ�ȡ�ӳ��еķ����
        scope = linspace(-1,1,division);
        lengthscope = length(scope);
        % ����չԴ���棬��Ҫ֪������ʼ�Ƕ�
        place_start = sind(STM_param.extentpoint_place_start);
        place_end = sind(STM_param.extentpoint_place_end);
        power = STM_param.extentpoint_power*(scope(2)-scope(1))/(Fov(2)-Fov(1));
        for source_num = 1:length(place_start)
            % ����չԴ�зֺ��������仮��Ϊ�����Դ
            T_dist_source = SourceCutUp(place_start(source_num),place_end(source_num),scope,power(source_num));
            T_dist_extent = [T_dist_extent T_dist_source];
        end
    end
    
    %%%%%%ƽ������%%%%%%%%%%%
    if(size(Fov,1)==2)   %�ж������Ƿ�Ϊ��ά����
        % ��ʼ��չԴ
        T_dist_extent = [;;];
        % �Կռ䰴��Ԥ��Ļ��ֵķ������л��֣���ÿռ仮�ֵķ���
        division = SpaceDivisionSelect(div,delta);
        % ���ջ��ֻ�ȡ�ӳ��еķ����
        scope_m = linspace(-1,1,division(2));
        scope_l = linspace(-1,1,division(1));
        for k = 1:size(STM_param.extentpoint_model,1)
            switch STM_param.extentpoint_model(k,:)
                case 'rectangular'
                    for rec_k = 1:length(STM_param.extentpoint_rec_power)
                        power = STM_param.extentpoint_rec_power(rec_k)*(scope_l(2)-scope_l(1))*(scope_m(2)-scope_m(1))/(Fov(1,2)-Fov(1,1))/(Fov(2,2)-Fov(2,1));
                        center = STM_param.extentpoint_rec_place_center(rec_k,:);
                        hs = STM_param.extentpoint_rec_place_hs(rec_k,:);
                        T_dist_source = SourceCutUp2D(scope_l,scope_m,power,center,hs);
                        T_dist_extent = [T_dist_extent T_dist_source];
                    end
            end
        end
        % ����Y���󣬰��վ������񻮷ֵķֱ���С����ʵ�ʰ��������λ��ֵ�������ˣ��ڼ���������ʱ��Ҫ��������������
        if lower(STM_param.array_type) == 'y_shape'
            T_dist_extent(1,:) = T_dist_extent(1,:)*8/3;
        end
    end
else
    %��չԴ����ʱ
    T_dist_extent = [];
end

%%%%%%ͼƬ���봦����%%%%%%%
if STM_param.picinsert_simu == 0
    T_dist_pic = [;;];
else
    if (STM_param.picinsert_simu == 1) %ͼƬ����
        pic = imread(STM_param.filename);
        pic = double(pic(:,:,1));
    end
    if (STM_param.picinsert_simu == 2) %������
        load(STM_param.matfile);
        pic = abs(pic);
    end
    T_dist_pic = [;;];
    row_pix = size(pic,1);
    col_pix = size(pic,2);
    row = linspace(STM_param.pic_scope(1,1),STM_param.pic_scope(1,2),row_pix);
    col = linspace(STM_param.pic_scope(2,1),STM_param.pic_scope(2,2),col_pix);
    for pic_row = 1:length(row)
        for pic_col = 1:length(col)
            %���λ��
            pic_point = col(pic_col)+j*row(pic_row);
            if (abs(pic_point/90)<=1)
                power = pic(row_pix-pic_row+1,pic_col)/row_pix/col_pix;
                theta = abs(pic_point);
                phy = angle(pic_point)*180/pi;
                T_dist_source = [power;theta;phy];
                T_dist_pic = [T_dist_pic T_dist_source];
            end
        end
    end
end

T_dist = [T_dist_point T_dist_extent T_dist_pic];

          
            
            

    
    

