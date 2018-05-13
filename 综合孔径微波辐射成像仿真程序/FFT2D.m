function T = FFT2D(visibility)

% 二维傅里叶变换
% 傅里叶反演得到图像
% 华中科技大学
T = real(ifft2(ifftshift(visibility)));
% 图像搬移
T = fftshift(T);