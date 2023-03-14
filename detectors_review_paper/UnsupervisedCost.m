%%Script to compute the ratio of probability of detection move and
%%probability of detection rest

clc
clear all
close all

%% Defining parameters in the script
mode       = "Train";                                   % 1. Test :  To compare the detectors ,  2. Train : To identify the best parameter 
% opt        = "Cuboid";
% Optparamsdir  = 'Optparams\cuboid\';                    
Outdir     = strcat('output\',mode,'\');
savedir    = strcat('costfunction\',mode,'\',opt,'\');
%%
type       = {'biophy'};
method     = {"","Noise"};
algoname   = {'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];              % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();         % 
saveflag   = 0;                % 1 to enable saving the files

 
for a = 1:length(algoname)
    
    field = strcat(algoname{a},'trail',num2str(N),type{k},'dur',...
            num2str(dur),'SNR',num2str(SNRdB));
            if string(type{k}) == "biophy"
            field      = strcat(algoname{a},'trail',num2str(N),type{k},'dur',...
            num2str(dur),'SNR',num2str(SNRdB),'force',num2str(force));
            end
            datafile   = strcat(char(mode),'Output',field,'.mat');
            
end