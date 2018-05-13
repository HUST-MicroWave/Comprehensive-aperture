function  y = G_filter_complex(G,Gfilter_para,DCfilter_flag,LFfilter_flag)
% 华中科技大学
azimuth_num = size(G, 2);
basesline_num=size(G, 1)-1;

y=G;

for k=1:1:basesline_num
G_real_spectrum=fft(real(G(k+1,:)));
G_imag_spectrum=fft(imag(G(k+1,:)));

if DCfilter_flag==1
G_real_spectrum(1)=0;
G_imag_spectrum(1)=0;
end

if LFfilter_flag==1 && k>1     
for m=2:1:basesline_num
G_real_spectrum(k)=0;
G_imag_spectrum(k)=0;
end
end

for l=k+Gfilter_para:1:azimuth_num
G_real_spectrum(l)=0;
G_imag_spectrum(l)=0;
end

y(k+1,:)=real(ifft(G_real_spectrum))+i*real(ifft(G_imag_spectrum));


end

% G_real_spectrum=fft(real(G(1,:)));
% for l=1+1:1:azimuth_num
% G_real_spectrum(l)=0;
% end
% y(1,:)=real(ifft(G_real_spectrum));