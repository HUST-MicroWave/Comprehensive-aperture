function v = R2V(R,pos);

% ֱ����������ؾ��󵽿ɼ���ת��
% RĿ��ɼ���
% pos����λ��
% ����ƽ��
% ���пƼ���ѧ
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