function inverse_name = InverseAlgorithmSelect(inverse_name_initial,array_type)

% 反演方法选择
% 华中科技大学 
if strcmp('auto',inverse_name_initial)   %根据阵列类型智能选择反演方法
    if (ischar(array_type)==0)
        switch size(array_type,1)
            case 1
                inverse_name = 'fft1D';
            case 2
                inverse_name = 'fft2D';
        end
    else
        %阵列的形式：AntennaPositionHELP()
        switch array_type
            case 'mrla'
                inverse_name = 'fft1D';
            case 'ula'
                inverse_name = 'fft1D';
            case 'Y_shape'
                inverse_name = 'hfft';
            case 'T_shape'
                inverse_name = 'fft2D';
            case 'O_shape'
                inverse_name = 'dftcircle';
            case 'cross_shape'
                inverse_name = 'fft2D';
        end
    end
else
    % 手动输入反演方法情况
    inverse_name = inverse_name_initial;
end

        