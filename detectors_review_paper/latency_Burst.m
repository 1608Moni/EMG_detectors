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
algoname   = {'Detector2018'};%'modifiedhodges','AGLRstep','hodges','AGLRstepLaplace','Detector2018','modifiedLidierth','lidierth'};%;'modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'FuzzyEnt','modifiedhodges','lidierth','modifiedLidierth','AGLRstep','hodges','AGLRstepLaplace','Detector2018'};%'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt','modifiedLidierth','hodges','Detector2018','lidierth','TKEO','bonato','SampEnt','CWT','SSA'};%,'hodges','modifiedhodges','lidierth','modifiedLidierth','bonato','TKEO','AGLRstep','AGLRstepLaplace','FuzzyEnt','SampEnt','CWT','SSA'};%,'lidierth','modifiedLidierth','Bonato','TKEO'};%'lidierth','modifiedLidierth','Bonato','TKEO','FuzzEnt','cwt','SSAEnt'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];           % Testing for 2 different SNR 0 dB and -3 dB
CF         = struct();         % 
saveflag   = 0;                % 1 to enable saving the files


lamda_on  = 500;%:-500:500; 
lamda_off = 500;%:500:5000; 


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
            tB                 = output.params.tB;
            
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
                t1 = (Wshift/fs):(Wshift/fs):dur; 
                t = (1/fs):(1/fs):13;
               
              
                 for p = 1:N
                 
                     plotflag = 0;
                     plotflag1 = 0;
                    t0cap_off = [];
                    binop(find(binop == 0)) = -1;
                    groundtruth(find(groundtruth == 0)) = -1;
                    
                    %% To compute the latency of the burst
                    [lEdge_GT, tEdge_GT] = edge(groundtruth(p,:));
                    [lEdge_Bin, tEdge_Bin] = edge(binop(p,:));
                    
                    if (length(lEdge_GT) > length(tEdge_GT))  && (lEdge_GT(end) ~= (dur*fs)/Wshift)
                       tEdge_GT = [tEdge_GT dur*fs];
                    end  
                    
                    for h = 1:length(tEdge_GT)
                        t0cap_On(h) = (lEdge_GT(h)-1)+min(find(binop(p,lEdge_GT(h):tEdge_GT(h)) == 1));
                        Latency_On(h) = min(find(binop(p,lEdge_GT(h):tEdge_GT(h)) == 1))-1;
                        if h > 1 
                            t0cap_off(h-1) = (tEdge_GT(h-1)-1)+min(find(binop(p,tEdge_GT(h-1):lEdge_GT(h)) == -1));
                            Latency_Off(h-1) = min(find(binop(p,tEdge_GT(h-1):lEdge_GT(h)) == -1))-1;
                        end
                        if length(tEdge_GT) == 1
                            t0cap_off = [];
                            Latency_Off = [];   % for cases where there is only one burst
                        end                       
                    end
                    
                    if (length(lEdge_GT) == length(tEdge_GT)) && (tEdge_GT(end) ~= (dur*fs)/Wshift)
                        tempVar = (tEdge_GT(end)-1)+min(find(binop(p,tEdge_GT(end):end) == -1));
                        Latency_temp = min(find(binop(p,tEdge_GT(end):end) == -1));
                        t0cap_off = [t0cap_off tempVar];
                        Latency_Off = [Latency_Off Latency_temp];
                    end
                    
                   
                    
                    %% To compute the rFP and rFN
                    [rFP(q,p),rFN(q,p)]= crosscorrcompute(groundtruth(p,tB:Wshift:end),binop(p,(tB/Wshift):end));
                    
                    if isempty(t0cap_off) == 1 
                        t0cap_off = NaN;
                        Latency_Off = NaN;
                        plotflag = 1;
                        disp('Offset not detected')
                    end
                    
                    if isempty(t0cap_On) == 1
                        t0cap_On = NaN;
                        Latency_On = NaN;
                          plotflag1 = 1;
                    end
                    
                     Avg_Latency_ON(q,p) = mean(Latency_On);
                    Avg_Latency_Off(q,p) = mean(Latency_Off);
                    
                    
                    
                
                    figure(p)
%                     subplot(2,1,1)
                    stairs(groundtruth(p,:),'LineWidth',1.5);
                    hold on
                    stairs(binop(p,:),'r');
                    if plotflag1 == 0
                        hold on                   
                        stem(t0cap_On,binop(p,t0cap_On),'m','LineWidth',1);
                    end
                    if plotflag == 0
                        hold on
                        stem(t0cap_off,-binop(p,t0cap_off),'g','LineWidth',1);
                    end
                    hold on
                    stem(lEdge_GT,groundtruth(p,lEdge_GT),'k');
                    hold on
                    stem(tEdge_GT,groundtruth(p,tEdge_GT),'c');
                    ylim([-1.1 1.1])  
                    txt = {strcat('rFP = ',num2str(round(rFP(q,p),3)))};
                    text(4.5,0.8,txt,'FontSize',12) 
                    txt1 = {strcat('rFN = ',num2str(round(rFN(q,p),3)))};
                    text(4.5,0.6,txt1,'FontSize',12) 
                    txt = {strcat('AvgLatencyOn = ',num2str(round(Avg_Latency_ON(q,p),3)))};
                    text(4.5,0.4,txt,'FontSize',12) 
                    txt1 = {strcat('AvgLatencyOff = ',num2str(round(Avg_Latency_Off(q,p),3)))};
                    text(4.5,0.3,txt1,'FontSize',12) 
%                     pause(2)
%                     close all
%                     subplot(2,1,2)
%                     stairs(binop(p,:),'r');
                    
                    name = strcat(algoname(a),'Lamda_ON',num2str(lamda_on(k)),'Lamda_OFF',num2str(lamda_off(k)));
                    title(name)
                    export_fig(char(name),'-pdf','-append',figure(p)); 
                    clear tEdge_GT;
                    clear lEdge_GT;
                    clear t0cap_off;
                    clear t0cap_On;
                 
                   
                    
%                   
                 end
            
             end
            
        end
    end
end











