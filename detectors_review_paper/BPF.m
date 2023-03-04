function x = BPF(p, fl, fh, fs, w)
%% Function to BPF the gaussian noise in the frequency range of surface EMG signals
% Input params : P  - order of the filter
%                fl - cutoff frequency lower limit (Hz)
%                fh - cutoff frequency upper limit (Hz)
%                fs - Sampling rate (Hz)
%                w  - Guassian noise   
% Outpt params : x  - Band pass filtered output
% filtfilt (Non-causal) function is used to ensure zero phase filtering.

d1 = designfilt('bandpassfir','FilterOrder',p, ...
         'CutoffFrequency1',fl,'CutoffFrequency2',fh, ...
         'SampleRate',fs);
x = filtfilt(d1,w);
end