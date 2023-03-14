%% Script to compute the Likelihood ratio (Pmove/Prest)
%
%

clc
clear all
close all

%% Defining parameters in the script
mode       = "Train";                                   % 1. Test :  To compare the detectors ,  2. Train : To identify the best parameter 
opt        = "Cuboid";
Optparamsdir  = 'Optparams\';                    
Outdir     = strcat('output\',mode,'\');
savedir    = strcat('costfunction\',mode,'\');
%%
type       = {'biophy'};
algoname   = {'modifiedhodges','AGLRstep','AGLRstepLaplace','FuzzyEnt',...
     'modifiedLidierth','hodges','lidierth','TKEO','Detector2018','bonato'};
N          = 50;               % Number of trials
force      = 300;              % forcelevel for biophy model : filename
dur        = 13;               % Duration of EMG signal in each trail (s)
SNRdB      = [0];              % Testing for SNR 0 dB
CF         = struct();         % 
saveflag   = 1;                % 1 to enable saving the file
plotflag   = 1;
method     = {'NoisePmove', 'Pmove'};

 for a = 1:length(algoname)
      
     %% Load the output file for the corresponding model,SNR and detector
     field      = strcat(algoname{a},'trail',num2str(N),type,'dur',...
     num2str(dur),'SNR',num2str(SNRdB),'force',num2str(force));
     datafile1   = strcat(char(method(1)),char(mode),'Output',field,'.mat');
     datafile2   = strcat(char(method(2)),char(mode),'Output',field,'.mat');

     % output corresponding to Noise
     outputfile1 = Outdir + datafile1;       
     output1     =  load(outputfile1);

     % output corresponding to signa+noise
     outputfile2 = Outdir + datafile2;       
     output2     =  load(outputfile2);
     %%
     params             = output1.params.combo;
     No_of_combo_params = numel(params); 
     fs                 = output1.dataparams.fs;
     t0                 = (output1.dataparams.t0*output1.dataparams.fs);  
     Bw                 = 1; 

     for q = 1:No_of_combo_params  
        binopNoise    =  output1.binop{q};
        binopEMG      =  output2.binop{q}; 
        if string(algoname{a}) == "Detector2018" 
            params = output2.params.combo{q};              
            Wshift = params(3);
        elseif string(algoname{a}) == "bonato"
            Wshift = 2;
        else
            Wshift = 1;
        end
        
        for p = 1:size(binopNoise,1)
                [LR0(q,p),pmove0(q,p),prest0(q,p)] = likeihoodratio(binopNoise(p,:),t0,Wshift);        
                [LR1(q,p),pmove1(q,p),prest1(q,p)] = likeihoodratio(binopEMG(p,:),t0,Wshift);
        end           
          
          %Compute the 95th percentile of H0 condition
             h(q) = prctile(LR0(q,:),95);
             b = LR1(q,:) > h(q);
             area(q,a)  = (1/N)*sum(b);     
       
          if plotflag ==1   
             name = strcat(mode,"_",algoname{a},"_",'Paramcombo',num2str(q)); 
%               plotlikelihoodratois(q,a,LR0,LR1,name,h,area(q,a),mode);
%               scatterplotPmovePrest(q,a,prest1,pmove1,name)
          end    
     end

      if mode == "Train"
        index = find(area(:,a) == max(area(:,a)));
        Optindex = DecideBestparam(index,LR1);
        if length(Optindex) > 1
            Optindex = Optindex(randi([1 length(Optindex)],1));
        end
        % find the Optindex
        d = ['The optimum parameters for','are : ',num2str( output2.params.combo{Optindex})];
        disp(d);
        param = output2.params.combo{Optindex};    
     
        disp('saving parameter')  
        %% save the optimum paramters for each detector in .mat file
        pathname   = fileparts(Optparamsdir);
        name = fullfile(pathname,strcat(method{2},type,algoname{a},num2str(SNRdB),'.mat'));
        if saveflag == 1 
            save(string(name),'param');
        end
      end 
      
      performance.LR0 = LR0;
      performance.LR1 = LR1;
      performance.pmove0 = pmove0;
      performance.pmove1 = pmove1;
      performance.prest0 = prest0;
      performance.prest1 = prest1;
      performance.area   = area;
      performance.Optindex = Optindex;

      pathname       = fileparts(savedir);
      text           = strcat('Pmove',char(mode),type,algoname{a},'SNR',num2str(SNRdB));    
      name           = fullfile(pathname, text{1});
      if saveflag == 1            
        save(name,'-struct','performance','-v7.3')  
      end      
      clear output2
      clear output1
end
            
            
          