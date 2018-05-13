function DrawInvPic(T,min_spacing,inv_name)
% ���пƼ���ѧ
switch inv_name
    
    case 'fft1D'
        % ��ȡ���ص���
        pixel = length(T);
        % ������С���ȷ���ӳ���Χ
        if min_spacing<0.5 %����С���С�ڰ벨��ʱ
            fov = [-1 1];
            deletepix = floor(pixel*(0.5-min_spacing)); %����ȥ�Ĳ���(ÿ��)
            T = T([deletepix+1:(pixel-deletepix)]);        %ȡͼ���м䲿��
            xi = linspace(fov(1),fov(2),pixel-2*deletepix);
        else                 %����С�����ڰ벨��ʱ
            fov = [-1 1]/2/min_spacing;
            xi = linspace(fov(1),fov(2),pixel);
        end             
        % ��ͼ       
        figure;
        plot(xi,T,'-','Linewidth',0.5,'Marker','.','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',6);
        title('���Ϸ���ͼ��');
        xlabel('sin\theta','FontSize',10);
        ylabel('��������(K)','FontSize',10);
        
    case 'fft2D'
        % ��ȡ���ص���
        pixel = size(T);
        % ������С���ȷ���ӳ���Χ
        if min_spacing<0.5 %����С���С�ڰ벨��ʱ
            fov = [-1 1;-1 1];
            deletepix = [floor(pixel(1)*(0.5-min_spacing)) floor(pixel(2)*(0.5-min_spacing))]; %����ȥ�Ĳ���(ÿ��)
            T = T([deletepix(1)+1:(pixel(1)-deletepix(1))],[deletepix(2)+1:(pixel(2)-deletepix(2))]);        %ȡͼ���м䲿��
            xi = linspace(fov(1,1),fov(1,2),pixel(2)-2*deletepix(2));
            eta = linspace(fov(2,1),fov(2,2),pixel(1)-2*deletepix(1));
        else                 %����С�����ڰ벨��ʱ
            fov = [-1 1;-1 1]/2/min_spacing;
            xi = linspace(fov(1,1),fov(1,2),pixel(2));
            eta = linspace(fov(2,1),fov(2,2),pixel(1));
        end
        % ��ͼ
        figure;
        TB = T;
        % ȥ���ӳ���Χ֮��ĵ�
        for l = 1:length(xi)
            for m = 1:length(eta)
                if ((xi(l)^2+eta(m)^2)>1)
                    TB(m,l) = 0;
                end
            end
        end
        imagesc(fov(1,:),fov(2,:),TB);
        set(gca,'YDir','normal')
        title('���Ϸ���ͼ��');
        xlabel('\xi');
        ylabel('\eta');
        figure;
        % ����ͼ����ת��Ϊ����
        xi = ones(length(eta),1)*xi;
        eta = eta'*ones(1,size(xi,2));
        mesh(xi,eta,T);
        title('���Ϸ���ͼ��');
        xlabel('\xi');
        ylabel('\eta');
        
    case 'hfft'
        % �������߸���n: n^2+n+1=����
        ant_num = sqrt(length(T)-3/4)-1/2;
        max_arm = ant_num/3;
        % ��ȡY�����UVƽ����������ӳ�
        [extent_UV Fov] = GenerateUVCellofYShape(min_spacing,max_arm);
        r = abs(Fov(1)-Fov(2))/3;
        angle = pi/6:pi/3:11*pi/6;
        x = r*cos(angle);
        y = r*sin(angle);
        X = real(Fov);
        Y = imag(Fov);
        figure()
        for k = 1:length(T)
            if (X(k)^2+Y(k)^2<=1)
            xaxis = X(k)+x;
            yaxis = Y(k)+y;
            hold on
            fill(xaxis,yaxis,T(k),'linestyle', 'none');
            end
        end
        title('Y������ͼ��');
        xlabel('\xi');
        ylabel('\eta');
        axis square     
          
    case 'dftcircle'
        % ��ȡ���ص���
        pixel = length(T);
        pixel_num = floor(sqrt(pixel));
        % ������С���ȷ���ӳ���Χ
        if min_spacing<0.5 %����С���С�ڰ벨��ʱ
            fov = [-1 1;-1 1];
            xi = linspace(fov(1,1),fov(1,2),pixel_num);
            eta = linspace(fov(2,1),fov(2,2),pixel_num);
        else                 %����С�����ڰ벨��ʱ
            fov = [-1 1;-1 1]/2/min_spacing;
            xi = linspace(fov(1,1),fov(1,2),pixel_num);
            eta = linspace(fov(2,1),fov(2,2),pixel_num);
        end
        % ��ͼ
        figure;
        TB = reshape(T,pixel_num,pixel_num);
        % ȥ���ӳ���Χ֮��ĵ�
        for l = 1:length(xi)
            for m = 1:length(eta)
                if ((xi(l)^2+eta(m)^2)>1)
                    TB(m,l) = 0;
                end
            end
        end
        imagesc(fov(1,:),fov(2,:),TB);
        set(gca,'YDir','normal')
        title('���Ϸ���ͼ��');
        xlabel('\xi');
        ylabel('\eta');
%         figure;
%         % ����ͼ����ת��Ϊ����
%         xi = ones(length(eta),1)*xi;
%         eta = eta'*ones(1,size(xi,2));
%         mesh(xi,eta,T);
%         title('���Ϸ���ͼ��');
%         xlabel('\xi');
%         ylabel('\eta');
        
end

        
        
        
        