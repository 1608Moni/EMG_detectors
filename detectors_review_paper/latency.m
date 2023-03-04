function [Latency, f_delT] = latency(t0cap,t0,fs)
%% Function to compute latency and the normalised latency
%latency values are normalised between 0 and 1 and only latencies above 100ms are neglected
% Input  : Estimated onset and Actual onset
% Output : Normalised latency 

%% Latency above 250 ms are normalised to 1

Latency = ((t0cap*fs))-t0;                  % Latency in ms
if (0 <=Latency) && (Latency <= 250)        % condition for 100 ms
   f_delT = (Latency/250);
else
   f_delT = 1;
end
    
end