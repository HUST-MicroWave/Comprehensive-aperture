function Calibrated_self_correlation_matrix = CASCalibration(self_correlation_matrix,Calculated_error)

% У��������λ���
% ���пƼ���ѧ

Calibrated_self_correlation_matrix = inv(diag(Calculated_error))*self_correlation_matrix*inv(conj(diag(Calculated_error)));