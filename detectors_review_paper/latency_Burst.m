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


%% Load the groundtruth
datafile   =  strcat('Pmove',char(mode),...
              'SNR',num2str(SNRdB),'trail',num2str(N),'dur',num2str(dur),char(type));
GTfile     = datadir + string(datafile);
data       = load(GTfile);
groundtruth = data.groundtruth;   

%%
for a = 1:length(algoname)
    for k = 1:length(lamda_on)
        for i = 1:length(lamda_off) 
            %% Load the binary output
            field      = strcat(algoname{a},'trail',num2str(N),type{1},'dur',...
            num2str(dur),'SNR',num2str(SNRdB(1)),'force',num2str(force));
            datafile1   = strcat('Pmove',char(mode),'Output',field,'.mat');
            datafile1   = string(datafile1);
            outputfile = Outdir + datafile1;       
            output =  load(outputfile);
            
            fs                 = output.dataparams.fs;
            t0                 = (output.dataparams.t0*output.dataparams.fs);      % Actual Onset time
            params             = output.params.combo;
            No_of_combo_params = numel(params); 
            
             %For each parameter combination compute cost function      
             for q = 1:No_of_combo_params      
                binop    =  output.binop{q};
                t0cap    =  output.t0cap{q};
                %% To Obtain the Wshift to generalise time samples  for computing the factor
                if string(algoname) == "Detector2018" 
                    params = output.params.combo{q};              
                    Wshift = params(3);
                    Wsize  = params(1)*fs;
                    fs1    = fs/Wshift ;
                    t1     = (1/fs1):(1/fs1):output.dataparams.dur;
                elseif string(algoname) == "bonato"
                    Wshift = 2;
                    Wsize  = 0;
                else
                    Wshift = 1;
                    Wsize  = 0;
                end
                %% Compute cost function for N = 50 trails for each parameter combination
                t1 = (Wshift/fs):(Wshift/fs):13000/fs; 
                t = (1/fs):(1/fs):13;
                for p = 1:N
                    binop(find(binop == 0)) = -1;
                    groundtruth(find(groundtruth == 0)) = -1;
                    
                    [lEdge_GT, tEdge_GT] = edge(groundtruth(p,:));
                    [lEdge_Bin, tEdge_Bin] = edge(binop(p,:));
                    
                    % To 
                    if length(lEdge_GT) > length(tEdge_GT)
                       tEdge_GT = [tEdge_GT dur*fs];
                    elseif length(lEdge_GT) < length(tEdge_GT)
                       lEdge_GT = [lEdge_GT dur*fs];
                    end
                     
                    for h = 1:length(tEdge_GT)
                        t0cap_On(h) = (lEdge_GT(h)-1)+min(find(binop(p,lEdge_GT(h):tEdge_GT(h)) == 1));
                        
                    end
                    
                    
                   
                    
                    figure(p)
                    stairs(groundtruth(p,:),'LineWidth',1.5);
                    hold on
                    stairs(binop(p,:),'--r');
                    hold on
                    stem(t0cap_On,binop(p,t0cap_On),'m','LineWidth',1);
%                      hold on
%                      stem(leadingEdge,-groundtruth(p,leadingEdge),'r');
%                     hold on
%                     stem(trailingEdge,groundtruth(p,trailingEdge),'m');
%                      ylim([-1.1 1.1])            
                end
            
             end
            
        end
    end
end



%% To identify leading and trailing edges of the binary signal







