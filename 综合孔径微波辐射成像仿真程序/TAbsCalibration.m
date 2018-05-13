function T = TAbsCalibration(inv_T,inverse_name);

% �Է���ͼ����ж��꣬ʹ�÷��ݽ����������¶�Ӧ
% ���пƼ���ѧ
switch inverse_name
    case 'fft2D'
        % ��FFT���ݲ���ȡ�����¾�ֵ����������в���
        T = inv_T * size(inv_T,1) * size(inv_T,2);
    case {'fft1D','hfft'}
        T = inv_T * length(inv_T); 
    otherwise
    T=inv_T;        
end
