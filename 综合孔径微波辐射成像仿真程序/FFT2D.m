function T = FFT2D(visibility)

% ��ά����Ҷ�任
% ����Ҷ���ݵõ�ͼ��
% ���пƼ���ѧ
T = real(ifft2(ifftshift(visibility)));
% ͼ�����
T = fftshift(T);