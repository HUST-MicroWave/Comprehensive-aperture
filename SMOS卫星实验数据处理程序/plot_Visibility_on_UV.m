% function plot_Visibility_on_UV(Visibility_unred_all,un_red_UV)
% ���пƼ���ѧ
load Visibility_unred_all.mat;
load un_red_UV.mat;
%%%%���ƿɼ��Ⱥ�����ʵ�����鲿�����õ���hex��ʽ���
if size(un_red_UV,2)==2
un_red_UV=un_red_UV(:,1)+1i*un_red_UV(:,2);
end
un_red_UV=un_red_UV*exp(-1i*pi/3);
r=1.52/3;
theta = pi/6:pi/3:11*pi/6;
x = r*cos(theta);
y = r*sin(theta);

%%%�ɼ���ʵ��
        figure(1);
        for k=2:size(Visibility_unred_all,1)
            xaxis = real(un_red_UV(k))+x;
            yaxis = imag(un_red_UV(k))+y;
            T1=real(Visibility_unred_all);
            fill(xaxis,yaxis,T1(k),'linestyle', 'none'),hold on;
        end
        xlabel('\bfU'),ylabel('\bfV');title('\bfReal of the Visibility')
%        caxis([-3.5,14.3]);
       set(gca,'FontSize',10); 
       axis([-30 30 -30 30]);
       set(gcf,'position',[0 0 400 300])
       colorbar('location','EastOutside');
%%%�ɼ����鲿
       figure(2);
       for k=2:size(Visibility_unred_all,1)
           xaxis = real(un_red_UV(k))+x;
           yaxis = imag(un_red_UV(k))+y;
           T2=imag(Visibility_unred_all);
           fill(xaxis,yaxis,T2(k),'linestyle', 'none'),hold on;
       end
        xlabel('\bfU'),ylabel('\bfV');title('\bfImag of the Visibility')
        set(gca,'FontSize',10); 
        axis([-30 30 -30 30]);
        set(gcf,'position',[0 0 400 300])
        colorbar('location','EastOutside');
% end
