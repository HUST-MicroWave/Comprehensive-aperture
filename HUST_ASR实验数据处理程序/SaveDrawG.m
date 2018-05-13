function y = SaveDrawG(x, y, TA_scene, filename,save_flag,GMat,GrMat)
%%%%%%%%%%%% 保存图像Mat和Fig，并绘制图像
%%%%%%%%%%%% % 华中科技大学 熊祖彪，2007-11-30
% TA_origin=TA_scene;
% TA_scene=TA_scene./max(max(TA_scene,[],2));
figure;
h = pcolor(x, y, TA_scene);
set( h, 'linestyle', 'none')
xlabel('方位角(度)');
ylabel('俯仰角(度)');

% figure;
% h = pcolor(x, y, TA_origin);
% set( h, 'linestyle', 'none')
% xlabel('方位角(度)');
% ylabel('俯仰角(度)');


%%%%%%%%%%%% 绘制对应零度角归一化综合孔径方向图
% AntennaMat=GrMat*GMat;
% Fsyn=AntennaMat(300,:);
% Fsyn=Fsyn./max(Fsyn);
% figure;
% plot(Fsyn,'-r'); 
% figure;
% plot(10*log10(abs(Fsyn)),'-b');

%%%%%%%%%%%% 存储图像文件和数据文件
ImageMatFileName = sprintf('%s.mat', filename);
ImageFigFileName = sprintf('%s.fig', filename);
TA_mean=mean(TA_scene,2);
TA_std=std(TA_scene,0,2);

if save_flag==1
save(ImageMatFileName,'TA_origin', 'TA_scene','TA_mean','TA_std','GMat','GrMat');
saveas(h, ImageFigFileName, 'fig');

end