function T = TAbsCalibration(inv_T,inverse_name);

% 对反演图像进行定标，使得反演结果与绝对量温对应
% 华中科技大学
switch inverse_name
    case 'fft2D'
        % 在FFT反演部分取了量温均值，在这里进行补偿
        T = inv_T * size(inv_T,1) * size(inv_T,2);
    case {'fft1D','hfft'}
        T = inv_T * length(inv_T); 
    otherwise
    T=inv_T;        
end
