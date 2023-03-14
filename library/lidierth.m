function  lidierthOutput = lidierth(x, variable, params, Dataparams)
%% Function to run the Lidierth algorithm for each trial.
%
%

%% Initialise and define parameters
lidierthOutput = struct(); 
Wsize          = variable(1);
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


%% Computing the threshold from baseline (2s of data) leaving the initial 1s
% mean_baseline = mean(EMG_rect(params.tB-params.M+1:params.tB));
% stdv_baseline = std(EMG_rect(params.tB-params.M+1:params.tB));
% h             = mean_baseline + weight*stdv_baseline;
threshold     = weight;


%% Computing the test function over sliding window 
for i = 1:length(t)    
    
   if i > Wsize*fs   
    %% moving avg
    y_mean(i) = (1/(Wsize*fs))*sum(EMG_rect(round(i-(Wsize*fs)+1):i));
     
        if t(i) > (params.tB/fs)

           %% threshold
           mean_baseline = mean(y_mean(params.tB-params.M+1:params.tB));
           stdv_baseline = std(y_mean(params.tB-params.M+1:params.tB));

           %% Test function
           g(i) = (y_mean(i)-mean_baseline)/stdv_baseline;

           %% Decision rule
           if g(i) > threshold
               bin1(i) = 1;
           end

           %% double threshold
           [bin2, binop] = doublethreshold(t, i, m, T1, bin1, bin2, binop); 

           %%
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
lidierthOutput.emgrect    = EMG_rect;
lidierthOutput.movAvg     = y_mean;
lidierthOutput.testfunc   = g;
lidierthOutput.binop      = binop;
lidierthOutput.bin1       = bin1;
lidierthOutput.bin2       = bin2;
lidierthOutput.t0cap      = NaN;
lidierthOutput.paramcombo = variable;
lidierthOutput.thresh     = threshold; 
lidierthOutput.mean_baseline  = mean_baseline;
lidierthOutput.stdv_baseline  = stdv_baseline;
lidierthOutput.dataparams     = Dataparams;
end