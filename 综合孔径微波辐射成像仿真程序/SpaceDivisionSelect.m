function division = SpaceDivisionSelect(div,delta)
    
% �������еķֱ��ʵı������еĻ���
% ���пƼ���ѧ

if (ischar(div)==1)
    divcoef = str2num(div);
    % �������еķֱ��ʽ��еĻ���
    if (isempty(divcoef)==1)
        if (length(delta)==1) %����
            division = 2/delta;
        else
            division = [2/delta(1) 2/delta(2)];
        end

    elseif (length(divcoef)==1) % ['n']        ��һά�����������еķֱ��ʵ�n�����л��֣�'3'ͨ��Ӧ����G����Ĳ�����
        division = 2/delta*divcoef;
    else                    % ['n m']    ����ά�����������еķֱ��ʵ�n��m�����л���
        division = [2/delta(1)*divcoef(1) 2/delta(2)*divcoef(2)];
    end

    % ����Ԥ��ֵ���л���
else
    division = div;
end



