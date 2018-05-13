
% function Plot_self_Visibility(path)
% 华中科技大学 绘制自相关函数
path='数据\导出的可见度\clib_visibility_5VVV';
channel_num=72;
visibility_all = Readdata2corrmat(path, channel_num);
k=0:71;
j=0:71;
r=(1-1/50)*sqrt(2)/2;
theta=pi/4:pi/2:7*pi/4;
figure(1);
axis([0 71 0 71]);
set(gca,'ydir','reverse');
title('\bfReal of Visibility');
set(gca,'FontSize',10);
set(gcf,'position',[0 0 400 300]);
for k1=1:72
    for k2=1:72
        X=k(k1)+r*cos(theta);
        Y=j(k2)+r*sin(theta);
         hold on;
        fill(X,Y,real(visibility_all(k1,k2)),'linestyle', 'none');
        end
end
        colorbar('location','EastOutside');
        
figure(2);
axis([0 71 0 71]);
set(gca,'ydir','reverse');
title('\bfImag of Visibility');
set(gca,'FontSize',10);
set(gcf,'position',[0 0 400 300]);
for k1=1:72
    for k2=1:72
        X=k(k1)+r*cos(theta);
        Y=j(k2)+r*sin(theta);
        hold on;
        fill(X,Y,imag(visibility_all(k1,k2)),'linestyle', 'none');
    end
end
   colorbar('location','EastOutside');
% end