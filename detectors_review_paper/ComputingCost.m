%% Script to compute the cost function for comparing the detector
%
clc
clear all
close all

%% Defining parameters in the script
mode       = "Pulse500Train";                                   % 1. Test :  To compare the detectors ,  2. Train : To identify the best parameter 
opt        = "Cuboid";
Optparamsdir  = 'Optparams\cuboid\';                    
Outdir     = strcat('output\');
savedir    = strcat('costfunction\');
%%
type       = {'biophy'};
algoname   = {'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt'};%,'AGLRstep','AGLRstepLaplace'};%,'AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};%,'hodges','modifiedhodges','lidierth','modifiedLidierth','bonato','TKEO','AGLRstep','AGLRstepLaplace','FuzzyEnt','SampEnt','CWT','SSA'};%,'lidierth','modifiedLidierth','Bonato','TKEO'};%'lidierth','modifiedLidierth','Bonato','TKEO','FuzzEnt','cwt','SSAEnt'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];           % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();         % 
saveflag   = 1;                % 1 to enable saving the files


%% Go through the datafiles and compute the cost function
for k = 1:length(type)
    for a = 1:length(algoname)
        for i = 1:length(SNRdB) 
            %% Load the output file for the corresponding model,SNR and detector
            field      = strcat(algoname{a},'trail',num2str(N),type{k},'dur',...
            num2str(dur),'SNR',num2str(SNRdB(i)));
            if string(type{k}) == "biophy"
            field      = strcat(algoname{a},'trail',num2str(N),type{k},'dur',...
            num2str(dur),'SNR',num2str(SNRdB(i)),'force',num2str(force));
            end
            datafile   = strcat(char(mode),'Output',field,'.mat');
%%            
% %             %%Detector 2018 with the parameters used in the paper
%              datafile  = strcat('Param2', char(mode),'Output',field,'.mat');
%%        
            datafile   = string(datafile);
            outputfile = Outdir + datafile;       
            output =  load(outputfile);
            %% Compute the cost func for each detector
            [CFoutput] = costfunc(output,algoname{a},string(type{k}));         
            P(:,i)     = CFoutput.CF(CFoutput.Optindex,:)';  
            %% store the optimum paramters 
            d = ['The optimum parameters for','are : ',num2str( output.params.combo{CFoutput.Optindex})];
            param = output.params.combo{CFoutput.Optindex};             
            %% Formating to create box plot
            if i == 1
               Cost_SNR0(:,a) = P(:,i); 
            elseif i == 2
               Cost_SNRneg3(:,a) = P(:,i); 
            end
        
            if mode == "Pulse500Train"
             %% save the optimum paramters for each detector in .mat file
                pathname   = fileparts(Optparamsdir);
                name = fullfile(pathname,strcat(type{k},algoname{a},num2str(SNRdB(i)),'.mat'));
                if saveflag == 1 
                    save(name,'param');
                end
            end
    
            if mode == "Pulse500Test"
                pathname       = fileparts(savedir);
                text           = strcat('Optcost',char(mode),type(k),algoname{a},'SNR',num2str(SNRdB(i)));    
                name           = fullfile(pathname, text{1});
                if saveflag == 1            
                    save(name,'-struct','CFoutput','-v7.3')  
                end
            end
            clear output   
        end 
        A{a}   = P;
    end
    
    %%
    figure
    boxplot(Cost_SNR0);
    
    if mode == "Pulse500Test"
        %% Save the opt cost (Test data) and Plot the boxchart for the 2 different SNR and detectors
        Optcost{1} = Cost_SNR0;
        Optcost{2} = Cost_SNRneg3;
        pathname       = fileparts(savedir);
        text           = strcat('ValidatedcostforboxplotInfinitynormsorted',char(mode),type(k),'Detector',num2str(length(algoname)));
        name           = fullfile(pathname, text{1});
        if saveflag == 1
            save(strcat(name,'.mat'),'Optcost'); 
        end
        %% Savnig the best cost function distribution for further analysis
        CF.cost  = A;
        pathname       = fileparts(savedir);
        text           = strcat('AnovaInifinitynormsorted',char(mode),type(k),'Detector',num2str(length(algoname)));    
        name           = fullfile(pathname, text{1});
        if saveflag == 1
            save(name,'-struct','CF','-v7.3') 
        end
    end
end