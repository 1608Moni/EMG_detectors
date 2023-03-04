function  SamEntOutput = SamEnt(x, variable, params, Dataparams)
%% Function to run the Lidierth algorithm for each trial.
%
%

%% Initialise and define parameters
SamEntOutput   = struct(); 
Wsize          = variable(1);
weight         = variable(2);
rho            = variable(3);      % weight for the tolerance level
fs             = Dataparams.fs;
t              = (1/fs):(1/fs):Dataparams.dur;
binop          = zeros(1,length(t));


%% Computing the test function over sliding window 
for k = 1:length(t) 
    if k > Wsize 
        seg     = x((k-Wsize+1):k);
        N       = length(seg);
        stdev          = std(seg);           % 
        r              = rho*stdev;        % tolerance level for the distance
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
                % calculate  function of the distance
                D = (dist < r);
                count(i) = sum(D)/(N-params.dim);
            end
            correl(m-params.dim+1) = sum(count)/(N-params.dim);
        end
        sampen(k) = log(correl(1)/correl(2));
    end
    
    if t(k) > (params.tB/fs)
%       %% threshold
         mean_baseline = mean(sampen(params.tB-params.M+1:params.tB));
         stdv_baseline = std(sampen(params.tB-params.M+1:params.tB));
         h             = mean_baseline + weight*stdv_baseline;
        %% Decision rule
           if sampen(k) > h
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
SamEntOutput.testfunc   = sampen;
SamEntOutput.binop      = binop;
SamEntOutput.t0cap      = t0cap;
SamEntOutput.paramcombo = variable;
SamEntOutput.h          = h; 
% SamEntOutput.mean_baseline  = mean_baseline;
% SamEntOutput.stdv_baseline  = stdv_baseline;
SamEntOutput.dataparams     = Dataparams;
end