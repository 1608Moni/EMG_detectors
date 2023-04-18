 function hodgesOutput = modifiedhodges(x, variable, params, Dataparams)
%% Function to run the hodges algorithim over single trial for one of the parameter combination
%
%

%% Initialise and define parameters
hodgesOutput = struct(); 
weight       = variable(1);
fc           = variable(2);
fs           = Dataparams.fs;
t            = (1/fs):(1/fs):Dataparams.dur;
binop        = zeros(1,length(t));

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


%%
for i = 1:length(t)
    if t(i) >= (params.tB/fs)
       % Decision rule
       if EMG_lpf(i) > h
           binop(i) = 1;
       end
    end
end

%% If the decision rule not satisfied
if isempty(binop(binop(Dataparams.t0*Dataparams.fs:end) > 0 )) == 1
    t0capon = NaN;
    t0capoff = NaN;
    disp('Onset not found')
else
    t0capon = t(Dataparams.t0*Dataparams.fs-1 + min(find(binop(Dataparams.t0*Dataparams.fs:end) == 1)));
    t0capoff = t(Dataparams.t0*Dataparams.fs+Dataparams.pulsedur-1 + min(find(binop(Dataparams.t0*Dataparams.fs+Dataparams.pulsedur:end) == 0)));
end


%% Saving internal variable in structure
hodgesOutput.emgrect    = EMG_rect;
hodgesOutput.testfunc   = EMG_lpf;
hodgesOutput.binop      = binop;
hodgesOutput.t0capon    = t0capon;
hodgesOutput.t0capoff   = t0capoff;
hodgesOutput.paramcombo = variable;
hodgesOutput.h  = h;
hodgesOutput.mean_baseline  = mean_baseline;
hodgesOutput.stdv_baseline  = stdv_baseline;
hodgesOutput.dataparams = Dataparams;

end