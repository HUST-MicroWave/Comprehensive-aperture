function T = HFFT(visibility,pos,Fov,extent_UV)

% 得到亮温分布
% 华中科技大学
for k = 1:length(Fov)
    l = real(Fov(k));
    m = imag(Fov(k));
    T(k) = 0;
    for pos = 1:length(extent_UV)
        u = real(extent_UV(pos));
        v = imag(extent_UV(pos));
        a  = exp(2*pi*j*(u*l+v*m));
        T(k) = T(k)+visibility(pos)*a;
    end
    T(k) = T(k)/length(Fov);
end
T = real(T);