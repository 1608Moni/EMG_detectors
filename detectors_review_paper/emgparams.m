function [emg_param] = emgparams()
%% Funtion to define the parameters to generate EMG
    
    emg_param           = struct();
    emg_param.fs        = 1000;                                                % Sampling freq
    emg_param.dur       = 13;                                                  % Duration of signal in each trail
    emg_param.t0        = 8;                                                   % Onset Time
    emg_param.tou       = 0;                                                   % Ramp duration
    emg_param.notrials  = 50;                                                  % No of trails
    emg_param.Pnoise    = 1;                                                   % Noise Power
    emg_param.Psignal   = [2 1 1/2];                                                 % Signal Power
    emg_param.SNRs      = 10*log10(emg_param.Psignal / emg_param.Pnoise);    % SNR in dB
    emg_param.type      = ["gaussian"];                                        % Data type (gaussian/laplacian)
    emg_param.p         = 8;                                                   % Order of filter
    emg_param.fl        = 10;                                                  % Cutoff freqlower bpf
    emg_param.fh        = 450;                                                 % Cutoff freqhigher bpf
    emg_param.Prob0     = 0.2;                                                 % prob that it should toggle when previous state is '0'
    emg_param.Prob1     = 0.2;                                                 % prob that it should toggle when previous state is '1'
    emg_param.Window    = 200;                                                 % State upto which it has to be constant
end