function [CFoutput] = Computingcrosscorrelation(output,algoname,type,lamda_on,lamda_off)
%% Function to compute the cost function: maximum of latency, FPR and FNR and choose the
%% paramter corresponding to minimum cost in terms of median and IQR (minimum Euclidean distance)
% Input  : The binary output of the detector
% Output : Cost function distribution of all trials and Optimum index (kopt)

%% Initialise parameters
      datadir            = '..\data\';
      figuredir          = 'D:\EMG detectors\detectors_review_paper\Figures\';
      fs                 = output.dataparams.fs;
      t0                 = (output.dataparams.t0*output.dataparams.fs);      % Actual Onset time
      tB                 = 3*fs;
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
            t1 = (Wshift/fs):(Wshift/fs):13000/fs; 
            t = (1/fs):(1/fs):13;
            for p = 1:Ntrial
                
                    binop(find(binop == 0)) = -1;
                    groundtruth(find(groundtruth == 0)) = -1;
                    binary1 = binop(p,(tB/Wshift):end);
                    t0cap1  = t0cap(p);                                  
                    GT      = groundtruth(p,tB:Wshift:end);
%                     if isempty(GT(GT>0)) == 1 && isempty(binary1(binary1>0)) == 1 
%                         cohenCoeff(q,p) = 0;     
%                     elseif isempty(GT(GT>0)) == 1 && isempty(binary1(binary1>0)) ~= 1 
%                         cohenCoeff(q,p) = -1; 
%                     else
           
                        CorrCoeff(q,p) = crosscorrcompute(groundtruth(p,tB:Wshift:end),binary1);               
% %                     end
             
             figure(p)
% %              subplot(5,10,p)
             stairs(t,groundtruth(p,:),'Linewidth',1.5)
             hold on
             stairs(t1,binop(p,:),'r--','Linewidth',1.5)
             sgtitle(algoname)
             txt = {strcat(num2str(round( CorrCoeff(q,p),5)))};
             text(1.5,0.8,txt,'FontSize',8)    
             name = char(figuredir + string(strcat('Constant','ON_',num2str(lamda_off),'OFF_',num2str(lamda_on),algoname)));
%              export_fig(name,'-pdf','-append',figure(p)); 
%              print(figure(p), '-append', '-dpsc2', strcat('ON_',num2str(lamda_off),'OFF_',num2str(lamda_on),algoname,'.ps'));
            
%              pause(2)
            end 
        close all         
%             savefig(strcat('ON_4500','OFF_500',algoname,'.fig'));
                        
            %% Compute the median and IQR of the cost distribution of each parameter combination
%             [Avg_CF(q), range_CF(q)] =  medIqr(cohenCoeff(q,:));
             mu(q) = mean(CorrCoeff(q,:));
            
             
        end   
   %% Compute the optimum parameter   
   %% To find the closest point from origin to choose the best parameter.
    index    = find(mu == max(mu));%bestparam(Avg_CF, range_CF);
  
  
 %%   Saving all internal variables in a structure
     CFoutput.CF          = CorrCoeff;
%      CFoutput.Avg_CF      = Avg_CF;
%      CFoutput.range_CF    = range_CF;
     CFoutput.Optindex    = index;
     CFoutput.mean    = mu;
     
     if  plotflag == 1
      %% Plot the cost function and factors plots
        name = strcat(algoname,'_','SNR',num2str(SNR),'_',char(type),'_',char(output.dataparams.mode));
        plotcostfunc(CFoutput,name);
     end
end