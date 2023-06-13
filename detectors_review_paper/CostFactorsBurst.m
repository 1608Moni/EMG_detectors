function [CFoutput] = CostFactorsBurst(output,algoname,a,type,lamda_on,lamda_off)
%% Function to compute the cost function: maximum of latency, FPR and FNR and choose the
%% paramter corresponding to minimum cost in terms of median and IQR (minimum Euclidean distance)
% Input  : The binary output of the detector
% Output : Cost function distribution of all trials and Optimum index (kopt)

%% Initialise parameters
      datadir            = '..\data\';
      figuredir          = 'D:\EMG detectors\detectors_review_paper\Figures\';
      fs                 = output.dataparams.fs;
      t0                 = (output.dataparams.t0*output.dataparams.fs);      % Actual Onset time
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
%         if output.dataparams.mode == "Test" 
            datafile   =  strcat('Pmove',char(output.dataparams.mode),...
                'SNR',num2str(SNR),'trail',num2str(Ntrial),'dur',num2str(dur),char(type));  
%         else
%            datafile   =  strcat('EMGDataSNR',num2str(SNR),'trail',num2str(Ntrial),'dur',num2str(dur),char(type));
%         end
        GTfile     = datadir + string(datafile);
        data       = load(GTfile);
        groundtruth = data.groundtruth;
      end
%
%%    %For each parameter combination compute cost function      
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
            t = (1/fs):(1/fs):dur;
            for p = 1:Ntrial
                 binop(find(binop == 0)) = -1;
                 groundtruth(find(groundtruth == 0)) = -1;
                
                [Latencyparams{q,p}] = LatencyBurst1(groundtruth(p,:), binop(p,:),dur,fs,Wshift);                 
               
                %% To compute the rFP and rFN
                [rFP(q,p),rFN(q,p)]= crosscorrcompute(groundtruth(p,tB:Wshift:end),binop(p,(tB/Wshift):end)); 
                 
                 %% compute cost 
                CF(q,p) = max([Latencyparams{q,p}.f_delT_Off,  Latencyparams{q,p}.f_delT_ON ,rFP(q,p) ,rFN(q,p)]); % Computing the infinity norm     
                f_delT_off(q,p) =  Latencyparams{q,p}.f_delT_Off;
                f_delT_ON(q,p)  =  Latencyparams{q,p}.f_delT_ON;
                Avg_Latency_ON(q,p)  = Latencyparams{q,p}.Avg_Latency_ON;
                Avg_Latency_off(q,p) = Latencyparams{q,p}.Avg_Latency_Off;
                    
                    
                    
% %                 
                    figure(p)
                   
                    stairs(groundtruth(p,:),'LineWidth',1.5);
                    hold on
                    stairs(binop(p,:),'r');
                    if (sum(isnan(Latencyparams{q,p}.t0cap_On)) == 0) && (isempty(find(Latencyparams{q,p}.t0cap_On == 0)) == 1)
                        hold on                   
                        stem(Latencyparams{q,p}.t0cap_On,binop(p,Latencyparams{q,p}.t0cap_On),'m','LineWidth',1);
                    end
                    if (sum(isnan(Latencyparams{q,p}.t0cap_off)) == 0) && (isempty(find(Latencyparams{q,p}.t0cap_off == 0)) == 1)
                        hold on
                        stem(Latencyparams{q,p}.t0cap_off,-binop(p,Latencyparams{q,p}.t0cap_off),'g','LineWidth',1);
                    end
                    hold on
                    stem(Latencyparams{q,p}.lEdge_GT,groundtruth(p,Latencyparams{q,p}.lEdge_GT),'k');
                    hold on
                    stem(Latencyparams{q,p}.tEdge_GT,groundtruth(p,Latencyparams{q,p}.tEdge_GT),'c');
                    ylim([-1.1 1.1])  
                    txt = {strcat('rFP = ',num2str(round(rFP(q,p),3)))};
                    text(4.5,0.8,txt,'FontSize',12) 
                    txt1 = {strcat('rFN = ',num2str(round(rFN(q,p),3)))};
                    text(4.5,0.6,txt1,'FontSize',12) 
                    txt = {strcat('AvgLatencyOn = ',num2str(round(Latencyparams{q,p}.f_delT_ON,3)))};
                    text(4.5,0.4,txt,'FontSize',12) 
                    txt1 = {strcat('AvgLatencyOff = ',num2str(round(Latencyparams{q,p}.f_delT_Off,3)))};
                    text(4.5,0.3,txt1,'FontSize',12) 
%                     pause(2)
%                     close all
                    
                    
                    
                    name = strcat(algoname,'Lamda_ON',num2str(lamda_on),'Lamda_OFF',num2str(lamda_off));
                    title(name)
                    export_fig(char(name),'-pdf','-append',figure(p)); 
                   
                 
            end 
%         close all         
%             savefig(strcat('ON_4500','OFF_500',algoname,'.fig'));
                        
            %% Compute the median and IQR of the cost distribution of each parameter combination
%             [Avg_CF(q), range_CF(q)] =  medIqr(cohenCoeff(q,:));
             mu(q) = mean( CF(q,:));
            
             
        end
%       
%         figure(a)
%         subplot(2,1,1)
%         boxplot(rFP')
%         ylim([-0.1 0.4])
%         ylabel('False positive rate')
%         %ylim([0 0.2])
%         subplot(2,1,2)
%         boxplot(rFN')
%         ylim([-0.1 0.4])
%         %ylim([0 0.2])
%         xlabel('False negative rate')
%         sgtitle(algoname)
    % Compute the optimum parameter
   %% To find the closest point from origin to choose the best parameter.
    index    = find(mu == max(mu));%bestparam(Avg_CF, range_CF);
  
  
 %%   Saving all internal variables in a structure
     CFoutput.CF          = CF;
     CFoutput.rFP         = rFP;
     CFoutput.rFN         = rFN;
     CFoutput.fdelT_ON   = f_delT_ON;
     CFoutput.fdetT_Off  = f_delT_off;
     CFoutput.Avg_Latency_ON = Avg_Latency_ON;
     CFoutput.Avg_Latency_off = Avg_Latency_off;
    % CFoutput.Optindex    = index;
     CFoutput.mean    = mu;
     
     if  plotflag == 1
      %% Plot the cost function and factors plots
      figure(1)
      subplot(1,5,1)
      [u,v]=ksdensity(CFoutput.CF(q,:),'Bandwidth',0.02);
      hold on
      p1 = plot(v,u, 'Color', [0.8 0.85 1]);
        
     end
end