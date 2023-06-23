%% Script to compute the cost function for comparing the detector
%
clc
clear all
close all

%% Defining parameters in the script
mode       = "Test";                                   % 1. Test :  To compare the detectors ,  2. Train : To identify the best parameter 
opt        = "Cuboid";
Optparamsdir  = 'Optparams\';                    
Outdir     = strcat('output\',mode,'\');
savedir    = strcat('costfunction\',mode,'\',opt,'\');
%%
type       = {'biophy'};
algoname   = {'modifiedhodges','modifiedLidierth','AGLRstep','AGLRstepLaplace','lidierth','hodges','Detector2018'};%,'Detector2018'};%,'AGLRstepLaplace','modifiedLidierth','AGLRstep','lidierth','hodges','Detector2018'};%'AGLRstepLaplace','modifiedLidierth','AGLRstep','lidierth','hodges','Detector2018'};%,,'Detector2018'};%;'modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'FuzzyEnt','modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};%,'hodges','modifiedhodges','lidierth','modifiedLidierth','bonato','TKEO','AGLRstep','AGLRstepLaplace','FuzzyEnt','SampEnt','CWT','SSA'};%,'lidierth','modifiedLidierth','Bonato','TKEO'};%'lidierth','modifiedLidierth','Bonato','TKEO','FuzzEnt','cwt','SSAEnt'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 15;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];           % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();         % 
saveflag   = 0;                % 1 to enable saving the files

 lamda_on  = 5000:-500:500; 
 lamda_off = 500:500:5000; 
 
 
%% Go through the datafiles and compute the cost function
for a = 1:length(algoname)
    l=1;
    for k = 1:length(lamda_on)
        for i = 1:length(lamda_off) 
            
            %% Load the output file for the corresponding model,SNR and detector
            mode       = strcat("Test","ON_",num2str(lamda_on(k)),"OFF_",num2str(lamda_off(i)));
            field      = strcat(algoname{a},'trail',num2str(N),type{1},'dur',...
            num2str(dur),'SNR',num2str(SNRdB(1)));
            if string(type{1}) == "biophy"
            field      = strcat(algoname{a},'trail',num2str(N),type{1},'dur',...
            num2str(dur),'SNR',num2str(SNRdB(1)),'force',num2str(force));
            end
%              if string(algoname{a}) == "AGLRstepLaplace" || string(algoname{a}) == "AGLRstep" ||...
%                      string(algoname{a}) == "lidierth" || string(algoname{a}) == "modifiedLidierth"
%                 datafile   = strcat('WeightedCostT_EdgePmove',char(mode),'Output',field,'.mat');
% % %                disp('a')
%              else
               datafile   = strcat('ConstantT_EdgePmove',char(mode),'Output',field,'.mat');
%              end
           
%%            
% %             %%Detector 2018 with the parameters used in the paper
%              datafile  = strcat('Param2', char(mode),'Output',field,'.mat');
%%        
            datafile   = string(datafile);
            outputfile = Outdir + datafile;       
            output =  load(outputfile);
            %% Compute the cost func for each detector
            [CFoutput] = CostFactorsBurst(output,algoname{a},a,string(type{1}),...
            lamda_on(k),lamda_off(i));         
            
             mean_cohenkappa(k,i) = CFoutput.mean; 
             
             %%
             Overallcost(l,:) = CFoutput.CF;
             OverallrFP(l,:) = CFoutput.rFP;
             OverallrFN(l,:) = CFoutput.rFN;
             OverallfdelT_ON(l,:) = CFoutput.fdelT_ON;
             OverallfdelT_off(l,:) = CFoutput.fdetT_Off;
             l=l+1;
%             P(:,i)     = CFoutput.CF(CFoutput.Optindex,:)';  
%             %% store the optimum paramters 
%             d = ['The optimum parameters for','are : ',num2str( output.params.combo{CFoutput.Optindex})];
%             disp(d)
%             param = output.params.combo{CFoutput.Optindex};             
%             %% Formating to create box plot
%             if i == 1
%                Cost_SNR0(:,a) = P(:,i); 
%             elseif i == 2
%                Cost_SNRneg3(:,a) = P(:,i); 
%             end
        
%             if mode == "Train"
%              %% save the optimum paramters for each detector in .mat file
%                 pathname   = fileparts(Optparamsdir);
%                 name = fullfile(pathname,strcat('Pmove',type{k},algoname{a},num2str(SNRdB(i)),'.mat'));
%                 if saveflag == 1 
%                     save(name,'param');
%                 end
%             end
    
            if mode == "Test"
                pathname       = fileparts(savedir);
                text           = strcat('kappa',char(mode),type(k),algoname{a},'SNR',num2str(SNRdB(i)));    
                name           = fullfile(pathname, text{1});
                if saveflag == 1            
                    save(name,'-struct','CFoutput','-v7.3')  
                end
            end
            clear output   
        end 
    end
     box(:,a) = mean_cohenkappa(:);
     overallbox(:,a) = Overallcost(:);
     RFP(:,a) = OverallrFP(:);
     RFN(:,a) = OverallrFN(:);
     fdelT_off(:,a) = OverallfdelT_off(:);
     fdelT_ON(:,a) = OverallfdelT_ON(:);
     avgOn(:,a) = CFoutput.Avg_Latency_ON;
     avgOff(:,a) = CFoutput.Avg_Latency_off;
     
%  
    figure(1)
    subplot(2,4,a)
    h= heatmap(lamda_off,lamda_on,mean_cohenkappa,'ColorLimit',[0 0.5]); %'ColorLimit',[0.7 1]
    h.Colormap = spring;
    ylabel('LamdaON')
    xlabel('LamdaOFF')
    title(algoname{a})
%   
end
mean(RFP,1)
nanmean(RFN,1)
figure(2)
boxplot(box,'Label',algoname);
% hold on
yline(0.2,'r--')
title('500 ms Pulse')
ylabel('cost')
figure(3)
data = [RFP, RFN, fdelT_off, fdelT_ON]; % Cost_SNR0, f_delToff_SNR0,  f_delTOn_SNR0,
algorname = repmat(algoname,1,4);
costfactors = [repmat({'rFP'},1,length(algoname)),repmat({'rFN'},1,length(algoname)),repmat({'Off'},1,length(algoname)),repmat({'On'},1,length(algoname))]; %repmat({'cost'},1,length(algoname)),repmat({'Off'},1,length(algoname)),repmat({'On'},1,length(algoname)),...
boxplot(data,{algorname,costfactors},'colors',repmat('kmbg',1,4),'factorgap',[7 1],'labelverbosity','minor','BoxStyle','filled');
% ylim([0 1])
% 
% figure
% subplot(4,1,1)
% boxplot(RFP,'Label',algoname);
% ylim([0 0.2])
% ylabel('False positive rate')
% title('500 ms Pulse')
% subplot(4,1,2)
% boxplot(RFN,'Label',algoname);
% ylim([0 0.2])
% ylabel('False negative rate')
% xlabel('Detectors')
% subplot(4,1,3)
% boxplot(fdelT_off,'Label',algoname);
% 
% ylabel('latency_off')
% title('500 ms Pulse')
% subplot(4,1,4)
% boxplot( fdelT_ON,'Label',algoname);
% ylabel('latency_on')
% xlabel('Detectors')
