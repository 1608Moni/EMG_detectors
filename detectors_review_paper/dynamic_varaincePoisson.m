function [Output] = dynamic_varaince(t, emg_param)   
%% Function that generates dynamic varaince.
% Generates unit step funtion with ramp duration of 20ms between 
% move and rest period.
% t           - Duration of signal in seconds (Independent Variable)
% emg_param   - Parameters to generate raw emg
% DynVariance - Variance as a function of time to generate emg data 
   
    %% Initialising
%     Transmatrix   = [ emg_param.ProbTrans1 (1- emg_param.ProbTrans1); (1-emg_param.ProbTrans0) emg_param.ProbTrans0];
%     InitialProb    = [ emg_param.Probmove; (1- emg_param.Probmove)];   

    u = zeros(1, length(t));
    DynVariance = zeros(length(emg_param.Psignal), length(t));
    Output      = struct();
    
    %% Generate random numbers to set 
    x = rand(1,length(t));
    x_trans = rand(1,length(t));
    
        
  
    %% Generate step profile with ramp duration of tou
    k=1;
    while k <= length(t)
         if t(k) < emg_param.t0
             u(k) = 0;
             k = k+1;
%          elseif t(k) == emg_param.t0
%               u(k) = 1;
%               k = k+1;
         elseif t(k) >= emg_param.t0
             if u(k-1) == 0
                if rand <= emg_param.Prob0
                    u(k:k+emg_param.Window-1) = 1-u(k-1);
                else
                    u(k:k+emg_param.Window-1) = u(k-1);
                end   
                k = k+emg_param.Window;
             else
                if rand <= emg_param.Prob1
                    u(k:k+emg_param.Window) = 1-u(k-1);
                else
                    u(k:k+emg_param.Window) = u(k-1);
                end
                k = k+emg_param.Window;
             end
         end
    end
    
    for i = 1:length(emg_param.Psignal)
        DynVariance(i,:) = emg_param.Pnoise + u(1:length(t)).* emg_param.Psignal(i);  
    end
    Output.DynVariance = DynVariance;
    Output.groundtruth = u(1:length(t));
    Output.Pmove       = sum(u(8000:length(t)))/5000;
end