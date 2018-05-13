function [phase, gain] = CalcPhaseAndGainByRedun(norm_ant_pos,corr_mat)
% 华中科技大学
[redun_count,redun_baseline_set] = GetRedunBaselineSet(norm_ant_pos);
fun_num = size(redun_baseline_set,1);
ant_num = length(norm_ant_pos);
A = zeros(fun_num, ant_num-1);
total = 1;
for i = 1:size(redun_count,2)
    for k = total : (total+redun_count(2,i)-1)
        if redun_baseline_set(k,2) ~= 1
            A(k,redun_baseline_set(k,2)-1) = 1;
        end
        A(k,redun_baseline_set(k,3)-1) = -1;
        %A(k,sys_param.ant_num+i-1) = 1;
    end
    total = total + redun_count(2,i);
end
B = zeros(fun_num,1);
for i = 1:fun_num
    B(i) = angle(corr_mat(redun_baseline_set(i,2),redun_baseline_set(i,3)));
end
phase = [0;pinv(A)*B];
% rand(A) deficient, 欠定方程，需要约束条件

%增益
G= zeros(fun_num, ant_num);
total = 1;
for i = 1:size(redun_count,2)
    for k = total : (total+redun_count(2,i)-1)
        if redun_baseline_set(k,2) ~= 1
           G(k,redun_baseline_set(k,2)-1) = 1;
        end    
        G(k,redun_baseline_set(k,3)-1) = 1;
        G(k,ant_num) = 1;
    end
    total = total + redun_count(2,i);
end
B = zeros(fun_num,1);
for i = 1:fun_num
    B(i) = log10(abs(corr_mat(redun_baseline_set(i,2),redun_baseline_set(i,3))));
end
temp = pinv(G)*B;
gain = [1;10.^temp(1:ant_num-1)];