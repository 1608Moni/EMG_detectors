function y=AR_MODEL(x,N,len,p,fulldata)
%% Function to do the adaptive whitening filter.
% parameters are estmiated using auto-regressive model.
% INPUT : RAW-EMG, length of signal and sampling frequency
% OUTPUT : whitened signal.

% y = zeros(len,1);
%  y = x;
y=x;
%% define the parameters used
% p     = 8;                       % Order of the filter
% t     = (1/fs):(1/fs):(N/fs);    % Time instantce
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
x1 = x_mod(p+1:end);
x_sqr = transpose(x_cap)*x_cap;
x_rem = transpose(x_cap)*x1;

%% Estimating the parameters
 a_estimate1 = inv(x_sqr)*x_rem; 

% [a_estimate2, e] = aryule(x, p);

%%

for i=1:len
     if i > p 
         if  i < length(x)+1
            add = sum(a_estimate1.*x(i-p:i-1));
            y(i) = x(i);
%             length(y)
%             if  i < length(x)+1
              w(i) = x(i) - add;
%             end
         else
             add =  sum(a_estimate1'.*y(i-p:i-1));
             y(i) = add + sqrt(var(w)).*randn;
         end
     end    
end


% for i=1:length(x)
%      if i > p
%         ycap(i) = sum(a_estimate1'.*y(i-p:i-1));
% %         y(i) = ycap(i)+randn;
% %         w(i) = x(i) - ycap(i);
% %         y = [ y  add+((sqrt(var(x))/1.5)*randn)];
%      end    
% end

%  figure 
% % 
%  subplot(2,1,1)
%  plot(fulldata)
%  hold on
%  plot(y(p:end),'Color',[0.8, 0, 0, 0.3])
%  subplot(2,1,2)
%  plot(w)
 
%  figure
%  plot(y(p:end))
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
% disp(strcat('variance : ', num2str(var(w))))
%  legend('x-estmated','x')
end


