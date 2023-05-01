%% Script to save the mean and standard deviation of the validated cost 
%
%
clc
clear all
close all

mode  = "Pulse500Test";
opt   = "Cuboid";
costdir = strcat('costfunction\');
type       = {'biophy'};
factor     = {'rFN','rFP','Latency_ON','Latency_OFF','CF'};
SNR        = {'0 dB','0 dB','0 dB','0 dB','0 dB'};
algoname   = {'Detector2018','modifiedhodges','AGLRstep','AGLRstepLaplace',...
             'FuzzyEnt','modifiedLidierth','hodges','lidierth'};
SNRdB      = [0];


for k = 1:length(type)
    for a = 1:length(algoname)
        for i = 1:length(SNRdB) 
            datafile = strcat('Optcost',char(mode),type(k),algoname{a},'SNR',num2str(SNRdB(i)),'.mat');  
            Costfile = costdir + string(datafile);
            costoutput = load(Costfile);
            S{a,i}     = strcat(num2str(round(mean(costoutput.rFN),3)),char(177),num2str(round(std(costoutput.rFN),3)));
            S{a,(i+1)} = strcat(num2str(round(mean(costoutput.rFP),3)),char(177),num2str(round(std(costoutput.rFP),3))); 
            S{a,(i+2)} = strcat(num2str(round(mean(costoutput.Latency_on),3)),char(177),num2str(round(std(costoutput.Latency_on),3)));  
            S{a,(i+3)} = strcat(num2str(round(mean(costoutput.Latency_off),3)),char(177),num2str(round(std(costoutput.Latency_off),3)));   
            S{a,(i+4)} = strcat(num2str(round(mean(costoutput.CF),3)),char(177),num2str(round(std(costoutput.CF),3)));  
        end 
    end
    name = strcat(type(k),'mean_StdtablePulsedetectionparam.xls');
   writecell(factor,name{1},'Range','B1:F1');
     writecell(SNR,name{1},'Range','B2:F2')
    writecell(S,name{1},'Range','B3:F14') 
    writecell(algoname',name{1},'Range','A3:A14')
end