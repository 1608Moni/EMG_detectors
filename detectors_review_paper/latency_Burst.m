clc
clear all
close all

%% Defining parameters in the script
mode       = "Test";                                   % 1. Test :  To compare the detectors ,  2. Train : To identify the best parameter 
opt        = "Cuboid";
Optparamsdir  = 'Optparams\';                    
Outdir     = strcat('output\',mode,'\');
datadir    = '..\data\';
savedir    = strcat('costfunction\',mode,'\',opt,'\');
%%
type       = {'biophy'};
algoname   = {'modifiedhodges','AGLRstep','hodges','AGLRstepLaplace','Detector2018','modifiedLidierth','lidierth'};%;'modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'FuzzyEnt','modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};%,'hodges','modifiedhodges','lidierth','modifiedLidierth','bonato','TKEO','AGLRstep','AGLRstepLaplace','FuzzyEnt','SampEnt','CWT','SSA'};%,'lidierth','modifiedLidierth','Bonato','TKEO'};%'lidierth','modifiedLidierth','Bonato','TKEO','FuzzEnt','cwt','SSAEnt'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];           % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();         % 
saveflag   = 0;                % 1 to enable saving the files

lamda_on  = 5000:-500:500; 
lamda_off = 500:500:5000; 

%% Load the binary output
field      = strcat(algoname{a},'trail',num2str(N),type{1},'dur',...
            num2str(dur),'SNR',num2str(SNRdB(1)),'force',num2str(force));
datafile1   = strcat('Pmove',char(mode),'Output',field,'.mat');
datafile1   = string(datafile1);
outputfile = Outdir + datafile1;       
output =  load(outputfile);

%% Load the groundtruth
datafile   =  strcat('Pmove',char(output.dataparams.mode),...
              'SNR',num2str(SNR),'trail',num2str(Ntrial),'dur',num2str(dur),char(type));
GTfile     = datadir + string(datafile);
data       = load(GTfile);
groundtruth = data.groundtruth;   


%%
