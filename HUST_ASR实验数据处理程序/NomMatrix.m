function norm_R = NomMatrix(R)
% 华中科技大学
ant_num = size(R,1);
for p = 2:ant_num-1
    for q = p+1:ant_num
        if(R(p,q)-(R(1,q)-R(1,p))>pi/2)
            R(p,q) = R(p,q)-2*pi;
        elseif((R(1,q)-R(1,p))-R(p,q)>pi/2)
            R(p,q) = R(p,q)+2*pi;
        end
    end
end

norm_R = R;
            
        