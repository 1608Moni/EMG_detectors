function  lidierthOutput = modifiedlidierth(x, variable, params, Dataparams)
%% Function to run the Lidierth algorithm for each trial.
%
%

%% Initialise and define parameters
lidierthOutput = struct(); 
fc             = variable(1);
weight         = variable(2);
m              = variable(3);
T1             = variable(4);
fs             = Dataparams.fs;
t              = (1/fs):(1/fs):Dataparams.dur;
bin1           = zeros(1,length(t));
bin2           = zeros(1,length(t));
binop          = zeros(1,length(t));

%% Signal Conditioning
%Rectifier
EMG_rect = abs(x);

%Low Pass filter
[b,a]   = butter(2,fc/(fs/2));
EMG_lpf = filter(b,a,EMG_rect);


%% Computing the threshold from baseline (2s of data) leaving the initial 1s
mean_baseline = mean(EMG_lpf(params.tB-params.M+1:params.tB));
stdv_baseline = std(EMG_lpf(params.tB-params.M+1:params.tB));
h             = mean_baseline + weight*stdv_baseline;
threshold     = weight;


%% Computing the test function over sliding window 
for i = 1:length(t)
    if t(i) >= (params.tB/fs)
      
       
       %% Decision rule
       if EMG_lpf(i) > h
           bin1(i) = 1;
       end
       
       %% double threshold
       [bin2, binop] = doublethreshold(t, i, m, T1, bin1, bin2, binop); 
       
       %%
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
lidierthOutput.emgrect    = EMG_rect;
lidierthOutput.emglpf     = EMG_lpf;
lidierthOutput.binop      = binop;
lidierthOutput.bin1       = bin1;
lidierthOutput.bin2       = bin2;
lidierthOutput.t0cap      = t0cap;
lidierthOutput.paramcombo = variable;
lidierthOutput.h          = h;
lidierthOutput.mean_baseline  = mean_baseline;
lidierthOutput.stdv_baseline  = stdv_baseline;
lidierthOutput.dataparams     = Dataparams;
