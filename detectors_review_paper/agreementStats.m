function [CFoutput] = agreementStats(output,algoname,type)
%% Function to compute the cost function: maximum of latency, FPR and FNR and choose the
%% paramter corresponding to minimum cost in terms of median and IQR (minimum Euclidean distance)
% Input  : The binary output of the detector
% Output : Cost function distribution of all trials and Optimum index (kopt)

%% Initialise parameters
      datadir            = '..\data\';
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
            for p = 1:Ntrial
                    binary1 = binop(p,(t0/Wshift):end);
                    t0cap1   = t0cap(p);                                  
             cohenCoeff(q,p) = cohensKappa(groundtruth(p,t0:Wshift:end),binary1);               
            end   
                        
            %% Compute the median and IQR of the cost distribution of each parameter combination
            [Avg_CF(q), range_CF(q)] =  medIqr(cohenCoeff(q,:));
            mu(q) = mean(cohenCoeff(q,:));
        end   
   %% Compute the optimum parameter   
   %% To find the closest point from origin to choose the best parameter.
    index    = find(mu == max(mu));%bestparam(Avg_CF, range_CF);
  
    
 %%   Saving all internal variables in a structure
     CFoutput.CF          = cohenCoeff;
     CFoutput.Avg_CF      = Avg_CF;
     CFoutput.range_CF    = range_CF;
     CFoutput.Optindex    = index;
     
     if  plotflag == 1
      %% Plot the cost function and factors plots
        name = strcat(algoname,'_','SNR',num2str(SNR),'_',char(type),'_',char(output.dataparams.mode));
        plotcostfunc(CFoutput,name);
     end
end