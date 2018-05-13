function T = FFT1D(v)

% 一维傅里叶反演
% 华中科技大学
baselinenum = length(v);
% 基线按照matlab的ifft顺序排列
ext_v = [v fliplr(conj(v(2:baselinenum)))];
% ifft之后对图像搬移
T = fftshift(ifft(ext_v));
% 取图像实部
T = real(T);
