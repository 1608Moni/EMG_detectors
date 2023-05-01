%% Script to save the optimised parameter in a excel sheet
clc
clear all
close all

optparamsdir = 'Optparams\cuboid\';
type       = {'biophy'};
algoname   = {'hodges','modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','lidierth','modifiedLidierth','Detector2018'};%,'modifiedhodges','AGLRstep','AGLRstepLaplace','fuzzyEnt','SamEnt','lidierth','modifiedLidierth','Bonato','TKEO','cwt','SSA'};
SNR        = [0];
paramalgo  = [];
paramSNR   = [];
%%
for i = 1:length(SNR)
    for j = 1:length(algoname)
        for k = 1:length(type)
            filename = strcat(type{k},algoname{j},num2str(SNR(i)),'.mat');
            filename = string(filename);
            optparamfile = optparamsdir + filename;
            optparam     = load(optparamfile);
            %% 
            param(:,k) = optparam.param';            
        end
        paramalgo = [paramalgo ; param];
        clear param;
    end
    paramSNR  = [paramSNR paramalgo];
    paramalgo = [];
end

writematrix(paramSNR,'PulseDetectionOptimumparameter.xls')