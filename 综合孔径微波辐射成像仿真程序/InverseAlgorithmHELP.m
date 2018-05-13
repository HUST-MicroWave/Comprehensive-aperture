function InverseAlgorithmHELP()


% 可供选择的反演算法类型为：
% 
% 傅里叶反演类
% （1）
% 'auto'   反演方法自动选择，程序根据阵列类型自行选择合适的反演算法，不会出错适合新手，其余方法适合高手 （强烈推荐）
% （2）
% 'fft1d'  一维阵列的傅里叶反演方法
% （3）
% 'fft2d'  二维阵列的傅里叶反演方法
% （4）
% 'hfft'   针对Y型阵列的六角形傅里叶反演方法
% 
% G矩阵反演类(未完成，完善中)
% （1）
% 'vancitter1d'
% （2）
% 'onestep1d'
% （3）
% 'pseudoinverse1d'
% （4）
% 'vancitter2d'
% （5）
% 'onestep2d'
% （6）
% 'pseudoinverse2d'
%
% 详细说明：
% 一维阵列：'fft1d'
% 'mrla' 最小冗余直线阵
% 'ula' 均匀直线阵
% 
% 二维阵列：'fft2d'
% 'T_shape' T形平面阵
% 'O_shape' 圆形平面阵
% 'cross_shape' 圆形平面阵
% 
% 特殊二维阵列：'hfft'
% 'Y_shape' Y形平面阵
% 华中科技大学 靳榕2010.11.9