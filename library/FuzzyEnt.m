function  fuzzEntOutput = FuzzyEnt(x, variable, params, Dataparams)
%% Function to run the Lidierth algorithm for each trial.
%
%

%% Initialise and define parameters
fuzzEntOutput   = struct(); 
Wsize          = variable(1);
weight         = variable(2);
fs             = Dataparams.fs;
t              = (1/fs):(1/fs):Dataparams.dur;
binop          = zeros(1,length(t));


%% Computing the test function over sliding window 
for k = 1:length(t) 
    if k > Wsize 
        seg     = x(k-Wsize:k);
        N       = length(seg);
        correl  = zeros(1,2);
        dataMat = zeros(params.dim+1,N-params.dim);
        for i = 1:params.dim+1
            dataMat(i,:) = seg(i:N-params.dim+i-1);
        end
        for m = params.dim:params.dim+1
            count = zeros(1,N-params.dim);
            tempMat = dataMat(1:m,:);
            for i = 1:N-m
                % calculate Chebyshev distance, excluding self-matching case
                dist = max(abs(tempMat(:,i+1:N-params.dim) - repmat(tempMat(:,i),1,N-params.dim-i)));
                % calculate fuzzy function of the distance
                D = exp(-((dist).^(params.n))./(params.r));
                count(i) = sum(D)/(N-params.dim);
            end
            correl(m-params.dim+1) = sum(count)/(N-params.dim);
        end
        fuzzen(k) = log(correl(1)/correl(2));
    end
    
    if t(k) > (params.tB/fs)
%       %% threshold
         mean_baseline = mean(fuzzen(params.tB-params.M+1:params.tB));
         stdv_baseline = std(fuzzen(params.tB-params.M+1:params.tB));
         h             = mean_baseline + weight*stdv_baseline;
        %% Decision rule
           if fuzzen(k) > h
               binop(k) = 1;
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
fuzzEntOutput.testfunc   = fuzzen;
fuzzEntOutput.binop      = binop;
fuzzEntOutput.t0cap      = NaN;
fuzzEntOutput.paramcombo = variable;
fuzzEntOutput.h          = h; 
fuzzEntOutput.mean_baseline  = mean_baseline;
fuzzEntOutput.stdv_baseline  = stdv_baseline;
fuzzEntOutput.dataparams     = Dataparams;
end