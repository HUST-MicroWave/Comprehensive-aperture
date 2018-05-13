function y = SaveDrawG(x, y, TA_scene, filename,save_flag,GMat,GrMat)
%%%%%%%%%%%% ����ͼ��Mat��Fig��������ͼ��
%%%%%%%%%%%% % ���пƼ���ѧ ����룬2007-11-30
% TA_origin=TA_scene;
% TA_scene=TA_scene./max(max(TA_scene,[],2));
figure;
h = pcolor(x, y, TA_scene);
set( h, 'linestyle', 'none')
xlabel('��λ��(��)');
ylabel('������(��)');

% figure;
% h = pcolor(x, y, TA_origin);
% set( h, 'linestyle', 'none')
% xlabel('��λ��(��)');
% ylabel('������(��)');


%%%%%%%%%%%% ���ƶ�Ӧ��Ƚǹ�һ���ۺϿ׾�����ͼ
% AntennaMat=GrMat*GMat;
% Fsyn=AntennaMat(300,:);
% Fsyn=Fsyn./max(Fsyn);
% figure;
% plot(Fsyn,'-r'); 
% figure;
% plot(10*log10(abs(Fsyn)),'-b');

%%%%%%%%%%%% �洢ͼ���ļ��������ļ�
ImageMatFileName = sprintf('%s.mat', filename);
ImageFigFileName = sprintf('%s.fig', filename);
TA_mean=mean(TA_scene,2);
TA_std=std(TA_scene,0,2);

if save_flag==1
save(ImageMatFileName,'TA_origin', 'TA_scene','TA_mean','TA_std','GMat','GrMat');
saveas(h, ImageFigFileName, 'fig');

end