function v = R2V(R,pos);

% 直线阵列自相关矩阵到可见度转化
% R目标可见度
% pos天线位置
% 冗余平均
% 华中科技大学
antnum = length(pos);

v_num = zeros(1,pos(antnum)-pos(1)+1);
v_sum = v_num;

for row = 1:antnum
    for col = row:antnum        
        v_sum(pos(col)-pos(row)+1) = v_sum(pos(col)-pos(row)+1) + R(row,col);
        v_num(pos(col)-pos(row)+1) = v_num(pos(col)-pos(row)+1) + 1;
    end
end
for k = 1:length(v_num)
    if(v_num(k)==0)
    else
        v_num(k) = 1/v_num(k);
    end
end
v = v_sum.*v_num;