%% Script to get all the results required for the manuscript
% 1. Boxchart of the validated cost function
% 2. ANOVA test
% 3. Bootstrap test

clc
clear all
close all

%% Define parameters for the script
mode    = "Test";
algoname   = {'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};
opt        = "Cuboid";
costdir = strcat('costfunction\',mode,'\',opt,'\');
type    = ["gaussian","laplacian","biophy"];
boxplotflag = 1;        % 1 to plot the boxchart ; 0 otherwise
anovaflag   = 0;        % 1 for run two-way anova test ; 0 otherwise
bootstrapflag = 0;      % 1 for bootstrap sampling
new = [];
%% 
model = ["Gaussian","Laplacian","Biophysical"];

%%
for i = 1:length(type)
    %%
    if boxplotflag == 1
        file =  strcat('ValidatedcostforboxplotInfinitynormsorted',char(mode),type(i),'Detector',num2str(length(algoname)),'.mat');
        file = string(file);
        costfile = costdir + file;
        costboxplot = load(costfile);
        createboxplot(costboxplot, model(i));
    end
    %%
    if anovaflag == 1
        file =  strcat('AnovaInifinitynormsorted',char(mode),type(i),'Detector',num2str(length(algoname)),'.mat');
        file = string(file);
        costfile = costdir + file;
        costAnova = load(costfile);
        testAnova(costAnova,type(i))
        %%
%         if bootstrapflag == 1
%          Sample = 100;
%          Caccept = 0.25;   
%          new = bootsraptest(costAnova,i,Sample,Caccept,new);
%          % to save as excerl
%          savefilename = strcat('Prob_optTrails','Detector',num2str(length(algoname)),num2str(Sample),'Samples',...
%          'Caccept',num2str(Caccept),'.xls');
%          type1 = {'Gaussian','','Laplacian','','BioPhy'};
%          Snr  = {'SNR0','SNR-3','SNR0','SNR-3','SNR0','SNR-3'};
%          writematrix(new,savefilename,'Range','B3:G15');
%          writecell(algoname',savefilename,'Range','A3:A15');
%          writecell(Snr,savefilename,'Range','B2:G2');
%          writecell(type1,savefilename,'Range','B1:G1');
%         end       
    end
    
  
    

end
