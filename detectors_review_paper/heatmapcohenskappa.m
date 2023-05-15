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
algoname   = {'modifiedhodges','Detector2018','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','FuzzyEnt'};%;'modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'FuzzyEnt','modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};%,'hodges','modifiedhodges','lidierth','modifiedLidierth','bonato','TKEO','AGLRstep','AGLRstepLaplace','FuzzyEnt','SampEnt','CWT','SSA'};%,'lidierth','modifiedLidierth','Bonato','TKEO'};%'lidierth','modifiedLidierth','Bonato','TKEO','FuzzEnt','cwt','SSAEnt'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];           % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();         % 
saveflag   = 1;                % 1 to enable saving the files

 lamda_on  = 5000:-500:500; 
 lamda_off = 500:500:5000; 
 
 
%% Go through the datafiles and compute the cost function
for a = 1:length(algoname)
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
            datafile   = strcat('ConstantPmove',char(mode),'Output',field,'.mat');
%%            
% %             %%Detector 2018 with the parameters used in the paper
%              datafile  = strcat('Param2', char(mode),'Output',field,'.mat');
%%        
            datafile   = string(datafile);
            outputfile = Outdir + datafile;       
            output =  load(outputfile);
            %% Compute the cost func for each detector
            [CFoutput] = agreementStats(output,algoname{a},string(type{1}),a);         
            
            mean_cohenkappa(k,i) = CFoutput.mean; 
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
    figure(1)
    subplot(2,4,a)
    h= heatmap(lamda_off,lamda_on,mean_cohenkappa, 'ColorLimits',[0 1]);
    h.Colormap = spring;
    ylabel('LamdaON')
    xlabel('LamdaOFF')
    title(algoname{a})
%     if mode == "Test"
%         %% Save the opt cost (Test data) and Plot the boxchart for the 2 different SNR and detectors
%         Optcost{1} = Cost_SNR0;
%         Optcost{2} = Cost_SNRneg3;
%         pathname       = fileparts(savedir);
%         text           = strcat('ValidatedcostforboxplotInfinitynormsorted',char(mode),type(k),'Detector',num2str(length(algoname)));
%         name           = fullfile(pathname, text{1});
%         if saveflag == 1
%             save(strcat(name,'.mat'),'Optcost'); 
%         end
%         %% Savnig the best cost function distribution for further analysis
%         CF.cost  = A;
%         pathname       = fileparts(savedir);
%         text           = strcat('AnovaInifinitynormsorted',char(mode),type(k),'Detector',num2str(length(algoname)));    
%         name           = fullfile(pathname, text{1});
%         if saveflag == 1
%             save(name,'-struct','CF','-v7.3') 
%         end
%     end
end