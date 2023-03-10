function [DynVariance] = dynamic_varaince(t, emg_param)   
%% Function that generates dynamic varaince.
% Generates unit step funtion with ramp duration of 20ms between 
% move and rest period.
% t           - Duration of signal in seconds (Independent Variable)
% emg_param   - Parameters to generate raw emg
% DynVariance - Variance as a function of time to generate emg data 
   
    %% Initialising
    Transmatrix   = [ emg_param.ProbTrans1 (1- emg_param.ProbTrans1); (1-emg_param.ProbTrans0) emg_param.ProbTrans0];
    InitialProb    = [ emg_param.Probmove; (1- emg_param.Probmove)];   
    u = zeros(1, length(t));
    DynVariance = zeros(length(emg_param.Psignal), length(t));
    
    %% Generate random numbers to set 
    x = rand(1,length(t));
    x_trans = rand(1,length(t));
    
        

    %% Generate step profile with ramp duration of tou
    for k=1:length(t)
         if t(k) < emg_param.t0
             u(k) = 0;
         elseif t(k) == emg_param.t0
             if x(k) <= emg_param.Probmove
                u(k) = 1;
             else
                u(k) = 0;
             end
         % keep changin the Prob 1 and Prob 0  according to transition matrix    
         TempProb = InitialProb ;
       
         
         elseif t(k) > emg_param.t0
              CurrentProb = TempProb'*Transmatrix;
              if x_trans(k) <= emg_param.ProbTrans1*emg_param.Probmove
                u(k) = 1;
              else
                u(k) = 0;
              end
%              if u(k-1) == 1
%                 if x_trans(k) <= emg_param.ProbTrans1*emg_param.Probmove
%                     u(k) = u(k-1);
%                 elseif x_trans(k) <= (1-emg_param.ProbTrans1)*emg_param.Probmove
%                     u(k) = 1-u(k-1);
%                 end
%              elseif u(k-1) == 0
%                  if x_trans(k) <= emg_param.ProbTrans0*(1-emg_param.Probmove)
%                     u(k) = u(k-1);
%                 elseif x_trans(k) <= (1-emg_param.ProbTrans0)*(1-emg_param.Probmove)
%                     u(k) = 1-u(k-1);
%                 end
%              end
             TempProb = CurrentProb';
         end
    end
        
    for i = 1:length(emg_param.Psignal)
        DynVariance(i,:) = emg_param.Pnoise + u.* emg_param.Psignal(i);  
    end
end