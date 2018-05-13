function y = SaveDraw_CK(x, y, start_angle,end_angle,TA_scene, filename,save_flag)
%%%%%%%%%%%% 保存图像Mat和Fig，并绘制图像
%%%%%%%%%%%% % 华中科技大学 熊祖彪，2007-11-30
% TA_origin=TA_scene;
% TA_scene=TA_scene./max(max(TA_scene,[],2));
y=(end_angle-start_angle)/(length(y)-1)*y+start_angle;
figure;
h = pcolor(x, y, TA_scene);
set( h, 'linestyle', 'none')
xlabel('方位角(度)');
ylabel('俯仰角(度)');



%%%%%%%%%%%% 存储图像文件和数据文件
ImageMatFileName = sprintf('%s.mat', filename);
ImageFigFileName = sprintf('%s.fig', filename);
TA_mean=mean(TA_scene,2);
TA_std=std(TA_scene,0,2);

if save_flag==1
save(ImageMatFileName, 'TA_origin','TA_scene','TA_mean','TA_std');
saveas(h, ImageFigFileName, 'fig');
end
