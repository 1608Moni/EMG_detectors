function [x, Dyn_variance] = generating_signal(emg_param)
% Function that generates band pass filtered gaussian/laplacian noise 
% using dynamic variance profile 
% x         - Generated Raw EMG data
% emg_param - Parameters to generate EMG data   

    %% Initialising   
    t = (1/emg_param.fs):(1/emg_param.fs):emg_param.dur;
    w = zeros(length(emg_param.SNRs), length(t));
    x = zeros(length(emg_param.SNRs), length(t));

    %% Generating the signal
    [Dyn_variance] = dynamic_varaince(t, emg_param);

    for i = 1:size(Dyn_variance,1)
        
        if emg_param.type == "gaussian"
            w(i,:) = sqrt(Dyn_variance(i,:)).*randn(1,length(t)); 
        elseif emg_param.type == "laplacian"     
            w(i,:) = sqrt(Dyn_variance(i,:)).*randl(1,length(t)); 
        end       
        %Band-pass filtering
        x(i,:) = BPF(emg_param.p, emg_param.fl, emg_param.fh,...
                 emg_param.fs, w(i,:)); 
    end
end
 

    
    
    
    







