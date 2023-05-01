function [CFoutput] = costfunc(output,algoname,type,a)
%% Function to compute the cost function: maximum of latency, FPR and FNR and choose the
%% paramter corresponding to minimum cost in terms of median and IQR (minimum Euclidean distance)
% Input  : The binary output of the detector
% Output : Cost function distribution of all trials and Optimum index (kopt)

%% Initialise parameters
      datadir            = '..\data\';
      fs                 = output.dataparams.fs;
      t0                 = (output.dataparams.t0*output.dataparams.fs);      % Actual Onset time
      tdur               = output.dataparams.pulsedur;
      params             = output.params.combo;
      No_of_combo_params = numel(params); 
      Ntrial             = output.dataparams.notrials;
      SNR                = output.dataparams.SNR;
      dur                = output.dataparams.dur;
      CF                 = zeros(length(output.binop),output.dataparams.notrials);
      Avg_CF             = zeros(1,length(output.binop));
      range_CF           = zeros(1,length(output.binop));
      tB                 = output.params.tB;
      CFoutput           = struct();
      plotflag           = 0;   % 1 to enable plotting 0 otherwise
         
      %% Generating Groundtruth   
      if type  == "gaussian" || type == "laplacian"
        groundtruth = GroundTruth(output.dataparams.dur*output.dataparams.fs,t0,type);
      elseif type == "biophy"
        if output.dataparams.mode == "Test" 
            datafile   =  strcat(char(output.dataparams.mode),...
                'SNR',num2str(SNR),'trail',num2str(Ntrial),'dur',num2str(dur),char(type));  
        else
           datafile   =  strcat(char(output.dataparams.mode),'SNR',num2str(SNR),'trail',num2str(Ntrial),'dur',num2str(dur),char(type));
        end
        GTfile     = datadir + string(datafile);
        data       = load(GTfile);
        groundtruth = data.groundtruth;
      end
%
l=1;
%%    %For each parameter combination compute cost function      
        for q = 1:No_of_combo_params      
            binop    =  output.binop{q};
            t0capon    =  output.t0capON{q};
            t0capoff    =  output.t0capOFF{q};
%             output.params.combo{q}

            
            
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
            for p = 1:Ntrial
                    binary1    = binop(p,:);
                    t0capon1   = t0capon(p);  
                    t0capoff1  = t0capoff(p);
%                      stairs(binary1);
%                      hold on
%                      xline(8000,'g','Linewidth',1)
%                      hold on
%                      xline(t0capoff1*fs,'r--','Linewidth',1)
%                      hold on
%                      xline(8500,'m','Linewidth',1)
%                      hold on
%                      xline(t0capon1*fs,'k--','Linewidth',1)
%                      ylim([-0.1 1.1])
                     
                [CF(q,p),Latency_on(q,p),f_delT_on(q,p),...
                Latency_off(q,p),f_delT_off(q,p),rFP(q,p),rFN(q,p)] = costfuncInfinityNorm_eachtrial(binary1,t0capon1,t0capoff1...
                                                              ,groundtruth,t0,tB,fs,Wshift,tdur);                 
            end   
                        
            %% Compute the median and IQR of the cost distribution of each parameter combination
            [Avg_CF(q), range_CF(q)] = medIqr(CF(q,:));
            
            
%             %% To plot the ensemble average of the binary output
%             name = strcat(algoname,'_','SNR',num2str(SNR),'_',char(type),'_');
%             figure(1)
%             subplot(9,1,l)
%             plot(sum(binop,1)/50);
%             hold on
%             plot(groundtruth)
%             hold on
% %             xline(8000 + prctile(Latency_on,80))
%             ylim([-0.1 1.1])
%             l=l+1;
%             xlim([7800 9200])
%             
% %             hold on
% %             xline(t0, 'r')
% %             hold on
% %             xline(t0+500, 'r')
% %             ylim([-0.1 1.1])
%             title(name,'Interpreter','none')
            
        end   
   %% Compute the optimum parameter   
   %% To find the closest point from origin to choose the best parameter.
    index    = bestparam(Avg_CF, range_CF);
  
    
 %%   Saving all internal variables in a structure
     CFoutput.CF          = CF;
     CFoutput.Avg_CF      = Avg_CF;
     CFoutput.range_CF    = range_CF;
     CFoutput.f_delT_off  = f_delT_off;
     CFoutput.f_delT_on   = f_delT_on;
     CFoutput.rFP         = rFP;
     CFoutput.rFN         = rFN;
     CFoutput.Latency_off = Latency_off;
     CFoutput.Latency_on = Latency_on;
     CFoutput.Optindex    = index;
 %% Save the cost function and factors of the optimal parameters
     if output.dataparams.mode == "Test"
        CFoutput.mean = mean(CF);
        CFoutput.stdv = std(CF);      
     end
     
     if  plotflag == 1
      %% Plot the cost function and factors plots
        name = strcat(algoname,'_','SNR',num2str(SNR),'_',char(type),'_',char(output.dataparams.mode));
        plotcostfunc(CFoutput,name);
     end
     
%      for i =1:5
%          figure(i)
%       subplot(4,1,1)
%       boxplot(Latency_on(i:5:end,:)','Labels',{})
%       xlabel('Windowsize')
%       ylabel('Latency_on (ms)')
%       
%       subplot(4,1,2)
%       boxplot(Latency_off(i:5:end,:)','Labels',{})
%       xlabel('Windowsize')
%       ylabel('Latency_off (ms)')
%     
%       subplot(4,1,3)
%       boxplot(rFP(i:5:end,:)','Labels',{})
%       xlabel('Windowsize')
%       ylabel('False postivie rate')
%      
%       
%       subplot(4,1,4)
%       boxplot(rFN(i:5:end,:)','Labels',{})
%       xlabel('Windowsize')
%       ylabel('False negative rate')
%       sgtitle(strcat(name,'weight = ',num2str(i)),'Interpreter','none')
%      
%      end
end