function [DynVariance] = dynamic_varaince(t, emg_param)   
%% Function that generates dynamic varaince.
% Generates unit step funtion with ramp duration of 20ms between 
% move and rest period.
% t           - Duration of signal in seconds (Independent Variable)
% emg_param   - Parameters to generate raw emg
% DynVariance - Variance as a function of time to generate emg data 

    %% Initialising
    u = zeros(1, length(t));
    DynVariance = zeros(length(emg_param.Psignal), length(t));

    %% Generate step profile with ramp duration of tou
    for k=1:length(t)
            if t(k) < emg_param.t0
                u(k) = 0;
               % % To generate ramp profile
%             elseif t(k) >= emg_param.t0 && t(k) <= emg_param.t0+emg_param.tou
%                 u(k) = (t(k)-emg_param.t0)/emg_param.tou;
            elseif t(k) >= emg_param.t0 + emg_param.tou
                u(k) = 1;
            end
    end
    
    for i = 1:length(emg_param.Psignal)
        DynVariance(i,:) = emg_param.Pnoise + u.* emg_param.Psignal(i);  
    end
end