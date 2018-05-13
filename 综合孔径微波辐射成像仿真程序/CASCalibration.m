function Calibrated_self_correlation_matrix = CASCalibration(self_correlation_matrix,Calculated_error)

% 校正幅度相位误差
% 华中科技大学

Calibrated_self_correlation_matrix = inv(diag(Calculated_error))*self_correlation_matrix*inv(conj(diag(Calculated_error)));