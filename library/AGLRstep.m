function  AGLRstepOutput = AGLRstep(x, variable, params, Dataparams)
%% Function to run the AGLR-G algorithm for each trial.
%
%

%% Initialise and define parameters
AGLRstepOutput = struct(); 
Wsize          = variable(1);
weight         = variable(2);
fs             = Dataparams.fs;
t              = (1/fs):(1/fs):Dataparams.dur;
binop          = zeros(1,length(t));

%% Signal Conditioning
%Adaptive whitening filter
y     = AR_MODEL(x,length(x),fs);
teta0 = (1/params.M)*sum(y(1:params.M).^2);

%% Computing the test function over sliding window 
for i = 1:length(t) 
    if i > Wsize*fs 
        teta1(i) = (1/(Wsize*fs))* sum(y(i-(Wsize*fs)+1:i).^2);  
        rho(i)   = teta1(i)/teta0;
        S(i)     = ((Wsize*fs)/2)*(rho(i)-log(rho(i))-1);    
    end
    
    if t(i) > (params.tB/fs)
        %% threshold
        mean_baseline = mean(S(params.tB-params.M+1:params.tB));
        stdv_baseline = std(S(params.tB-params.M+1:params.tB));
        h             = mean_baseline + weight*stdv_baseline;
        %% Decision rule
           if S(i) > h
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


%% Save internal variables in a struct
AGLRstepOutput.signcond   = y;
AGLRstepOutput.testfunc   = S;
AGLRstepOutput.binop      = binop;
AGLRstepOutput.t0capon    = t0capon;
AGLRstepOutput.t0capoff   = t0capoff;
AGLRstepOutput.paramcombo = variable;
AGLRstepOutput.h          = h; 
AGLRstepOutput.mean_baseline  = mean_baseline;
AGLRstepOutput.stdv_baseline  = stdv_baseline;
AGLRstepOutput.dataparams     = Dataparams;
end