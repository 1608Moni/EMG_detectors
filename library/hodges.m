function hodgesOutput = hodges(x, variable, params, Dataparams)
%% Function to run the hodges algorithim over single trial for one of the parameter combination
%
%

%% Initialise and define parameters
hodgesOutput = struct(); 
Wsize        = variable(1);
weight       = variable(2);  %% Scaling factor for stdv / threshold for test func
fc           = variable(3);
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
threshold     = weight;


%% Computing the test function over sliding window 
for i = 1:length(t)
    if t(i) > (params.tB/fs)-Wsize
       % Moving Avereage filter 
       
       y_mean(i) = (1/(Wsize*fs))*sum(EMG_lpf(round(i-(Wsize*fs)+1):i));
       
       % Test function
       g(i) = (y_mean(i)-mean_baseline)/stdv_baseline;
       
       % Decision rule
       if g(i) > threshold
           binop(i) = 1;
       end
    end
end


%% If the decision rule not satisfied
if isempty(binop(binop(Dataparams.t0*Dataparams.fs:end) > 0 )) == 1
    t0cap = NaN;
    disp('Onset not found')
else
    t0cap = t(Dataparams.t0*Dataparams.fs-1 + min(find(binop(Dataparams.t0*Dataparams.fs:end) == 1)));
end


%% Saving internal variable in structure
hodgesOutput.emgrect    = EMG_rect;
hodgesOutput.emglpf     = EMG_lpf;
hodgesOutput.movAvg     = y_mean;
hodgesOutput.testfunc   = g;
hodgesOutput.binop      = binop;
hodgesOutput.t0cap      = NaN;
hodgesOutput.paramcombo = variable;
hodgesOutput.h          = h;
hodgesOutput.thresh     = threshold; 
hodgesOutput.mean_baseline  = mean_baseline;
hodgesOutput.stdv_baseline  = stdv_baseline;
hodgesOutput.dataparams     = Dataparams;

end