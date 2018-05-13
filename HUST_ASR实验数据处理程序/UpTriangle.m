function v = UpTriangle(R)
% 华中科技大学
R_length = length(R(1,:));

k = 1;
for p = 2:R_length
    for q = 1:p-1
        v(k,1) = R(q,p);
        k = k+1;
    end
end