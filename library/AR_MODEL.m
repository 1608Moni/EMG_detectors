function y=AR_MODEL(x,N,fs)
%% Function to do the adaptive whitening filter.
% parameters are estmiated using auto-regressive model.
% INPUT : RAW-EMG, length of signal and sampling frequency
% OUTPUT : whitened signal.


%% define the parameters used
p     = 8;                       % Order of the filter
t     = (1/fs):(1/fs):(N/fs);    % Time instantce
M     = N+1-p;                   % arrange data into set of M linear equation
x_mod = zeros(N+1,1);
x_cap = zeros(M,p);
x1    = zeros(M,1);
a_estimate = zeros(p,1);


%% arrange the time series into M linear equation (Matrix form)
x=x';
x_mod(2:end)=x;

k=1;
for i=1:length(x)-p+1
x_cap(k,:) = x_mod(i:(p-1)+i);
k=k+1;
end

%% Paramter estimation
x1=x_mod(p+1:end);
x_sqr = transpose(x_cap)*x_cap;
x_rem = transpose(x_cap)*x1;

a_estimate = inv(x_sqr)*x_rem; 
x_estimate = filter(a_estimate,1,x);


%% adaptive whitening %%

for i=1:length(t)
    if i-p >0
        add = sum(a_estimate.*x(i-p:i-1));
        y(i) = x(i) - add;
    end    
end

% figure 
% 
% subplot(2,2,1)
% plot(w)
% hold on
% plot(x,'LineWidth',1)
% legend('Gaussian Noise','Zero-Phase bandpass filtered')
% subplot(2,2,2)
% plot(abs(fft(w)))
% hold on
% plot(abs(fft(x)))
% ylabel('|fft(w)|')
% subplot(2,2,3)
% plot(y)
% hold on
% plot(x,'LineWidth',1)
% legend('Adaptive whitening (1/AR) )','Zero-Phase bandpass filtered' )
% subplot(2,2,4)
% plot(abs(fft(y)))
% ylabel('|fft(y)|')
% figure
% plot(x_estimate)
% hold on
% plot(x)
% legend('x-estmated','x')


