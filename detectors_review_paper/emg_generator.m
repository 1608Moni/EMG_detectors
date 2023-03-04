%% Script to generate EMG using a bandpass filtered Gaussian white noise.
% Date: 23 March 2022
% Authors: Monisha Yuvaraj & Sivakumar Balasubramanian

clc;
clear;
close all;

% Define variables used in the script
datadir = '..\data';

% Define the parameters for generating the EMG signal.
emg_param = emgparams();

%% Generate EMG data for different SNR

%Initialising variables
R         = length(emg_param.SNRs);
C         = ((emg_param.dur*emg_param.fs));
n         = emg_param.notrials;
data      = zeros(R,C,n);
emg       = struct();
emg.param = emg_param;


 for i = 1:n
    [D, Dyn_variance] = generating_signal(emg_param);
    data(:,:,i) = D;
 end
 
 data = permute(data,[3,2,1]);  % matrix with dimension: n x C x R
 
 
%% Save the data file along with parameters
 for i = 1:length(emg_param.SNRs)
     emg.data   = data(:,:,i);
     emg.SNR    = emg_param.SNRs(i);
     emg.dynVar = Dyn_variance(i,:);               % regenerate the same test data
     emg.type   = "testdata";
     field      = strcat('SNR',num2str(round(emg_param.SNRs(i))),...
                  'trail',num2str(emg_param.notrials),...
                  'dur',num2str(emg_param.dur),emg_param.type);

     name       = fullfile(datadir, strcat('TestEMGData',field));
     save(name,'-struct','emg')
 end

