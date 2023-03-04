%% Script to save the mean and standard deviation of the validated cost 
%
%
clc
clear all
close all

mode  = "Test";
opt   = "Cuboid";
costdir = strcat('costfunction\',mode,'\',opt,'\');
type       = {'gaussian','laplacian','biophy'};
factor     = {'rFN','','rFP','','Latency','','CF'};
SNR        = {'0 dB','-3 dB','0 dB','-3 dB','0 dB','-3 dB','0 dB','-3 dB'};
algoname   = {'Detector2018','modifiedhodges','AGLRstep','AGLRstepLaplace',...
             'FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt'};
SNRdB      = [0,-3];


for k = 1:length(type)
    for a = 1:length(algoname)
        for i = 1:length(SNRdB) 
            datafile = strcat('Param2Optcost',char(mode),type(k),algoname{a},'SNR',num2str(SNRdB(i)),'.mat');  
            Costfile = costdir + string(datafile);
            costoutput = load(Costfile);
            S{a,i}     = strcat(num2str(round(mean(costoutput.rFN),3)),char(177),num2str(round(std(costoutput.rFN),3)));
            S{a,(i+2)} = strcat(num2str(round(mean(costoutput.rFP),3)),char(177),num2str(round(std(costoutput.rFP),3))); 
            S{a,(i+4)} = strcat(num2str(round(mean(costoutput.Latency),3)),char(177),num2str(round(std(costoutput.Latency),3)));  
            S{a,(i+6)} = strcat(num2str(round(mean(costoutput.CF),3)),char(177),num2str(round(std(costoutput.CF),3)));  
        end
    end
    name = strcat(type(k),'mean_StdtableRMSdetector2018param.xls');
    writecell(factor,name{1},'Range','B1:I1');
    writecell(SNR,name{1},'Range','B2:I2')
    writecell(S,name{1},'Range','B3:I14')
    writecell(algoname',name{1},'Range','A3:A14')
end