function w = wavelet(lamda,a,tou)

% wavelet function
Ka=1;


fs = 1;
N  = 13000;
t  = -N/2:1/fs:N/2;



for k=1:length(t)-1

  
w(k) = Ka*2*(((t(k)-tou)/a)/lamda)*exp(-(((t(k)-tou)/a)^2/lamda^2));


end

% plot((w));
end
