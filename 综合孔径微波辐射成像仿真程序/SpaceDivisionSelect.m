function division = SpaceDivisionSelect(div,delta)
    
% 按照阵列的分辨率的倍数进行的划分
% 华中科技大学

if (ischar(div)==1)
    divcoef = str2num(div);
    % 按照阵列的分辨率进行的划分
    if (isempty(divcoef)==1)
        if (length(delta)==1) %线阵
            division = 2/delta;
        else
            division = [2/delta(1) 2/delta(2)];
        end

    elseif (length(divcoef)==1) % ['n']        将一维场景按照阵列的分辨率的n倍进行划分，'3'通常应用于G矩阵的测量中
        division = 2/delta*divcoef;
    else                    % ['n m']    将二维场景按照阵列的分辨率的n，m倍进行划分
        division = [2/delta(1)*divcoef(1) 2/delta(2)*divcoef(2)];
    end

    % 按照预设值进行划分
else
    division = div;
end



