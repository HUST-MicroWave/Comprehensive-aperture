function T = FFT1D(v)

% һά����Ҷ����
% ���пƼ���ѧ
baselinenum = length(v);
% ���߰���matlab��ifft˳������
ext_v = [v fliplr(conj(v(2:baselinenum)))];
% ifft֮���ͼ�����
T = fftshift(ifft(ext_v));
% ȡͼ��ʵ��
T = real(T);
