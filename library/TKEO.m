function  TKEOOutput = TKEO(x, variable, params, Dataparams)
%% Function to run the Teiger kaiser energy opertator algorithm for each trial.
%
%

%% Initialise and define parameters
TKEOOutput   = struct(); 
fc_h         = variable(1);
Wsize        = variable(2);
weight       = variable(3);
T1           = variable(4);
fs           = Dataparams.fs;
t            = (1/fs):(1/fs):Dataparams.dur;
bin1         = zeros(1,length(t));
bin2         = zeros(1,length(t));
binop        = zeros(1,length(t));

%% Signal Conditioning
%butterworth hpf with order = 6 and cutoff = 20Hz
[b,a]   = butter(6,fc_h/(fs/2),'high');
EMG_hpf = filter(b,a,x);

for i = 1:length(t)
    if  i > 3
        %% Teiger kaiser Operator
        f(i) = EMG_hpf(i-1)^2 - (EMG_hpf(i-2)*EMG_hpf(i));
        if i > Wsize*fs   
            %% smoothening
            y_mean(i) = (1/(Wsize*fs))*sum(f((i-round(Wsize*fs)+1):i));
            if t(i) > (params.tB/fs)
                %% threshold
                mean_baseline = mean(y_mean(params.tB-params.M+1:params.tB));
                stdv_baseline = std(y_mean(params.tB-params.M+1:params.tB));
                h             =  mean_baseline + weight*stdv_baseline;
                %% Decision rule
                if y_mean(i) > h
                    bin1(i) = 1;
                end

                 %% double threshold (No condition on n out of m samples. n = 1 and m = 1)
                [bin2, binop] = doublethreshold(t, i, 1, T1, bin1, bin2, binop); 
            end      
        end
    end    
end

%% If the decision rule not satisfied
if isempty(binop(binop(Dataparams.t0*Dataparams.fs:end)>0)) == 1
    t0cap = NaN;
    disp('Onset not found')
else
    t0cap = t(Dataparams.t0*Dataparams.fs-1 + min(find(binop(Dataparams.t0*Dataparams.fs:end) == 1)));
end


%% Save internal variables in a struct
TKEOOutput.EMGhpf     = EMG_hpf;
TKEOOutput.TKEO       = f;
TKEOOutput.testfunc   = y_mean;
TKEOOutput.binop      = binop;
TKEOOutput.bin1       = bin1;
TKEOOutput.bin2       = bin2;
TKEOOutput.t0cap      = t0cap;
TKEOOutput.paramcombo = variable;
TKEOOutput.h          = h;
TKEOOutput.mean_baseline  = mean_baseline;
TKEOOutput.stdv_baseline  = stdv_baseline;
TKEOOutput.dataparams     = Dataparams;
