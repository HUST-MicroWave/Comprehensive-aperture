function y = SaveDraw_CK(x, y, start_angle,end_angle,TA_scene, filename,save_flag)
%%%%%%%%%%%% ����ͼ��Mat��Fig��������ͼ��
%%%%%%%%%%%% % ���пƼ���ѧ ����룬2007-11-30
% TA_origin=TA_scene;
% TA_scene=TA_scene./max(max(TA_scene,[],2));
y=(end_angle-start_angle)/(length(y)-1)*y+start_angle;
figure;
h = pcolor(x, y, TA_scene);
set( h, 'linestyle', 'none')
xlabel('��λ��(��)');
ylabel('������(��)');



%%%%%%%%%%%% �洢ͼ���ļ��������ļ�
ImageMatFileName = sprintf('%s.mat', filename);
ImageFigFileName = sprintf('%s.fig', filename);
TA_mean=mean(TA_scene,2);
TA_std=std(TA_scene,0,2);

if save_flag==1
save(ImageMatFileName, 'TA_origin','TA_scene','TA_mean','TA_std');
saveas(h, ImageFigFileName, 'fig');
end
