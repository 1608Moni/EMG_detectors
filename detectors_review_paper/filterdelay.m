clc
clear all
close all

fc = 1.5;
fs = 500;

impulse_ = zeros(1,15000);

impulse_(7500:end) = 1;
t = 0:(1/fs):(length(impulse_)/fs);
%Low Pass filter
[b,a]   = butter(2,fc/(fs/2));
EMG_lpf = filter(b,a,impulse_);

figure
subplot(2,1,1)
plot(t(1:end-1),impulse_(1:end))
subplot(2,1,2)
plot(t(1:end-1),EMG_lpf(1:end));