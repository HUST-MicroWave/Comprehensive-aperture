function DrawInvPic(T,min_spacing,inv_name)
% 华中科技大学
switch inv_name
    
    case 'fft1D'
        % 获取像素点数
        pixel = length(T);
        % 根据最小间距确定视场范围
        if min_spacing<0.5 %当最小间距小于半波长时
            fov = [-1 1];
            deletepix = floor(pixel*(0.5-min_spacing)); %被截去的部分(每边)
            T = T([deletepix+1:(pixel-deletepix)]);        %取图像中间部分
            xi = linspace(fov(1),fov(2),pixel-2*deletepix);
        else                 %当最小间距大于半波长时
            fov = [-1 1]/2/min_spacing;
            xi = linspace(fov(1),fov(2),pixel);
        end             
        % 画图       
        figure;
        plot(xi,T,'-','Linewidth',0.5,'Marker','.','MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',6);
        title('傅氏反演图像');
        xlabel('sin\theta','FontSize',10);
        ylabel('反演亮温(K)','FontSize',10);
        
    case 'fft2D'
        % 获取像素点数
        pixel = size(T);
        % 根据最小间距确定视场范围
        if min_spacing<0.5 %当最小间距小于半波长时
            fov = [-1 1;-1 1];
            deletepix = [floor(pixel(1)*(0.5-min_spacing)) floor(pixel(2)*(0.5-min_spacing))]; %被截去的部分(每边)
            T = T([deletepix(1)+1:(pixel(1)-deletepix(1))],[deletepix(2)+1:(pixel(2)-deletepix(2))]);        %取图像中间部分
            xi = linspace(fov(1,1),fov(1,2),pixel(2)-2*deletepix(2));
            eta = linspace(fov(2,1),fov(2,2),pixel(1)-2*deletepix(1));
        else                 %当最小间距大于半波长时
            fov = [-1 1;-1 1]/2/min_spacing;
            xi = linspace(fov(1,1),fov(1,2),pixel(2));
            eta = linspace(fov(2,1),fov(2,2),pixel(1));
        end
        % 画图
        figure;
        TB = T;
        % 去掉视场范围之外的点
        for l = 1:length(xi)
            for m = 1:length(eta)
                if ((xi(l)^2+eta(m)^2)>1)
                    TB(m,l) = 0;
                end
            end
        end
        imagesc(fov(1,:),fov(2,:),TB);
        set(gca,'YDir','normal')
        title('傅氏反演图像');
        xlabel('\xi');
        ylabel('\eta');
        figure;
        % 将画图坐标转化为矩阵
        xi = ones(length(eta),1)*xi;
        eta = eta'*ones(1,size(xi,2));
        mesh(xi,eta,T);
        title('傅氏反演图像');
        xlabel('\xi');
        ylabel('\eta');
        
    case 'hfft'
        % 计算天线个数n: n^2+n+1=个数
        ant_num = sqrt(length(T)-3/4)-1/2;
        max_arm = ant_num/3;
        % 获取Y形阵的UV平面采样点与视场
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
        title('Y型阵反演图像');
        xlabel('\xi');
        ylabel('\eta');
        axis square     
          
    case 'dftcircle'
        % 获取像素点数
        pixel = length(T);
        pixel_num = floor(sqrt(pixel));
        % 根据最小间距确定视场范围
        if min_spacing<0.5 %当最小间距小于半波长时
            fov = [-1 1;-1 1];
            xi = linspace(fov(1,1),fov(1,2),pixel_num);
            eta = linspace(fov(2,1),fov(2,2),pixel_num);
        else                 %当最小间距大于半波长时
            fov = [-1 1;-1 1]/2/min_spacing;
            xi = linspace(fov(1,1),fov(1,2),pixel_num);
            eta = linspace(fov(2,1),fov(2,2),pixel_num);
        end
        % 画图
        figure;
        TB = reshape(T,pixel_num,pixel_num);
        % 去掉视场范围之外的点
        for l = 1:length(xi)
            for m = 1:length(eta)
                if ((xi(l)^2+eta(m)^2)>1)
                    TB(m,l) = 0;
                end
            end
        end
        imagesc(fov(1,:),fov(2,:),TB);
        set(gca,'YDir','normal')
        title('傅氏反演图像');
        xlabel('\xi');
        ylabel('\eta');
%         figure;
%         % 将画图坐标转化为矩阵
%         xi = ones(length(eta),1)*xi;
%         eta = eta'*ones(1,size(xi,2));
%         mesh(xi,eta,T);
%         title('傅氏反演图像');
%         xlabel('\xi');
%         ylabel('\eta');
        
end

        
        
        
        