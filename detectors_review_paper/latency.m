function [LatencyON, f_delTON,LatencyOFF, f_delTOFF] = latency(t0capon,t0capoff,t0,fs,tdur)
%% Function to compute latency and the normalised latency
%latency values are normalised between 0 and 1 and only latencies above 100ms are neglected
% Input  : Estimated onset and Actual onset
% Output : Normalised latency 

%% Latency above 250 ms are normalised to 1

LatencyON = ((t0capon*fs))-t0;                  % Latency in ms
if (0 <=LatencyON) && (LatencyON <= 250)        % condition for 100 ms
   f_delTON = (LatencyON/250);
else
   f_delTON = 1;
end

LatencyOFF = ((t0capoff*fs))-(t0+tdur);                  % Latency in ms
if (0 <=LatencyOFF) && (LatencyOFF <= 250)        % condition for 100 ms
   f_delTOFF = (LatencyOFF/250);
else
   f_delTOFF = 1;
end
    
end