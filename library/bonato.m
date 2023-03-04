function  bonatoOutput = bonato(x, variable, params, Dataparams)
%% Function to run the bonato algorithm for each trial.
%
%

%% Initialise and define parameters
bonatoOutput   = struct(); 
weight         = variable(1);
m              = variable(2);
T1             = variable(3);
fs             = Dataparams.fs;
t              = (1/fs):(1/fs):Dataparams.dur;
t1             = (2/fs):(2/fs):Dataparams.dur;
bin1           = zeros(1,length(t)/2);
bin2           = zeros(1,length(t)/2);
binop          = zeros(1,length(t)/2);

%% Signal Conditioning
%Adaptive whitening filter
y = AR_MODEL(x,length(x),fs);
stdv_baseline = std(y(params.tB-params.M+1:params.tB));

%% Computing the test function over sliding window 
l=1;
for i = 1:2:length(t) 
    
    %% Test function  
        if i == 1 
            g(l) = (y(i)^2)/(stdv_baseline)^2;          
        else
            g(l) = (y(i-1)^2 + y(i)^2)/(stdv_baseline)^2;        
        end
   
   
%% Decision rule
if t(l) > ((params.tB/fs))/2
    %% To compute threshold
    mean_base = mean(g(params.tB/2-params.M/2+1:params.tB/2));
    stdv_base = std(g(params.tB/2-params.M/2+1:params.tB/2));
    h         = mean_base + weight*stdv_base;
    
    if g(l) > h
        bin1(l) = 1;
    end
  
    %% double threshold
     [bin2, binop] = doublethresholdB(t, l, m, T1, bin1, bin2, binop); 
end
                   
  l=l+1;  
end

%% If the decision rule not satisfied
if isempty(binop(binop(Dataparams.t0*Dataparams.fs/2:end)>0)) == 1
    t0cap = NaN;
    disp('Onset not found')
else
    t0cap = t1(Dataparams.t0*Dataparams.fs/2-1 + min(find(binop(Dataparams.t0*Dataparams.fs/2:end) == 1)));
end


%% Save internal variables in a struct
bonatoOutput.signcond   = y;
bonatoOutput.testfunc   = g;
bonatoOutput.binop      = binop;
bonatoOutput.bin1       = bin1;
bonatoOutput.bin2       = bin2;
bonatoOutput.t0cap      = t0cap;
bonatoOutput.paramcombo = variable;
bonatoOutput.h          = h;
bonatoOutput.thresh     = stdv_baseline; 
bonatoOutput.mean_baseline  = mean_base;
bonatoOutput.stdv_baseline  = stdv_base;
bonatoOutput.dataparams     = Dataparams;
