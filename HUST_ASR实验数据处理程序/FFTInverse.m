%%%%%%%%%%%% 傅氏反演
%%%%%%%%%%%% % 华中科技大学 熊祖彪，2008-10-10

function y = FFTInverse(Visibility, points_num)

elevation_num = size(Visibility, 2);
baseline_num = size(Visibility, 1);

TA = zeros(elevation_num,points_num);
for m=1:1:elevation_num
    TA(m,:) = FFTInverseZero(Visibility(:,m).', points_num-2*baseline_num+1);
end
y = fliplr(real(TA));
