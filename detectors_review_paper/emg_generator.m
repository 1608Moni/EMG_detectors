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
    [Output] = generating_signal(emg_param);
    data(:,:,i) = Output.data;
    Dyn_variance(:,:,i) = Output.DynVariance;
    ProbMove(i) = Output.Pmove;
    Groundtruth(i,:) = Output.groundtruth;
 end
 
 data = permute(data,[3,2,1]);                      % matrix with dimension: n x C x R
 Dyn_variance = permute(Dyn_variance,[3,2,1]); 
 
%% Save the data file along with parameters
 for i = 1:length(emg_param.SNRs)
     emg.data   = data(:,:,i);
     emg.SNR    = emg_param.SNRs(i);
     emg.dynVar = Dyn_variance(:,:,i);               % regenerate the same test data
     emg.Probmove = ProbMove;
     emg.Groundtruth =  Groundtruth;
     emg.method = "Pmove";
     emg.mode   = "Train";
     field      = strcat(char(emg.method),char(emg.mode),'SNR',num2str(round(emg_param.SNRs(i))),...
                  'trail',num2str(emg_param.notrials),...
                  'dur',num2str(emg_param.dur),emg_param.type);
     name       = fullfile(datadir, strcat(field));
     save(name,'-struct','emg')
 end

