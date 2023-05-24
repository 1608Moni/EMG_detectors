clc 
clear all
close all

mode       = "Test";                                   % 1. Test :  To compare the detectors ,  2. Train : To identify the best parameter 
opt        = "Cuboid";
Optparamsdir  = 'Optparams\cuboid\';                    
Outdir     = strcat('output\',mode,'\');
savedir    = strcat('costfunction\',mode,'\',opt,'\');
method       = {'Pulse500',''};
type       = {'biophy'};
algoname   = {'modifiedhodges','hodges','Detector2018'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];           % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();      
for k = 1:length(method)
    for a = 1:length(algoname)
     %% Load the output file for the corresponding model,SNR and detector
     field      = strcat(algoname{a},'trail',num2str(N),type{1},'dur',...
     num2str(dur),'SNR',num2str(SNRdB(1)));
     if string(type{k}) == "biophy"
        field      = strcat(algoname{a},'trail',num2str(N),type{1},'dur',...
        num2str(dur),'SNR',num2str(SNRdB(1)),'force',num2str(force));
     end
        datafile   = strcat(method{k},char(mode),'Output',field,'.mat');
%%            
% %             %%Detector 2018 with the parameters used in the paper
%              datafile  = strcat('Param2', char(mode),'Output',field,'.mat');
%%        
        datafile   = string(datafile);
        outputfile = Outdir + datafile;       
            output =  load(outputfile);
            %% Compute the cost func for each detector
            [CFoutput] = costfunc(output,algoname{a},string(type{k}));  
     
    end
end