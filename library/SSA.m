function  SSAOutput = SSA(x, variable, params, Dataparams)
%% Function to run the Lidierth algorithm for each trial.
%
%

%% Initialise and define parameters
SSAOutput = struct(); 
m         = variable(1);
M         = m/2;
p         = m-M+1;
q         = m+1;
k         = m-M+1;
fs        = Dataparams.fs;
t         = (1/fs):(1/fs):Dataparams.dur;
binop     = zeros(1,length(t));
W         = zeros(1,length(t)-m-M);

s(1)      = 1;

%% Initialising the trajectory matrix
index = zeros(length(t)-m-M,M);
X     = zeros(length(t)-m-M,m);
Trj   = zeros(M,k);
T     = zeros(length(t)-m-M,((q+M-1)-(p+1)+1)); 
test  = zeros(M,q-p);

%% Computing the test function over sliding window 
for n= 1:length(t)-m-M
    %% segmenting the time series    
    X(n,:) = x(n+1 : n+m);
    
    %% forming the trajectory matrix
    for l = 1:length(X(n,:))-k+1
        Trj(l,:) = X(n,((1:k)+l-1));
    end
    %% Compute the covariance matrix (Rn) for each n
    R = Trj*Trj';
    
    %% Determine the eigen value and eigen vector of Rn
    [V,lamda] = eig(R);
    SumLamda  = trace(lamda);
    a         = (5/100)*SumLamda;
    lamda     = diag(lamda);
    index     = find(lamda' > a);
    I(n)      = length(index);
    L         = I(1);
    [sorted,ind] = sort(lamda,'descend');
    vec        = V(:,ind(1:L));
    
    %% forming the test matrix
    T(n,:) = x(n+p+1 : n+q+M-1);
    
    for j = 1:length(T(n,:))-(q-p)+1
        test(j,:) = T(n,(1:q-p)+j-1);
    end

    for r = 1:q-p
        d(r) = test(r,:)*test(r,:)' -  test(r,:)*vec*vec'*test(r,:)';
    end
    %%
    D(n) = sum(d);
    v(1) = D(1);
    if n >= 2
        if  n <= m/2
            v(n) = D(n);
        else
            M1 = m/2;
            v(n) = D(M1);
        end
        s(n) = D(n) / v(n);
        W(n) = max(0, W(n-1)+s(n)-s(n-1)-(1/(3*sqrt(M*(q-p)))));
    end
    
     Lamda(n) = lamda(1) ;
end

%%  % cumulative sum statistics 
[pks,index] = findpeaks(W(Dataparams.t0*Dataparams.fs : end-1));
index       = index + Dataparams.t0*Dataparams.fs;
%% Find the peaks in the move phase (Do not use thresholding method to compute onset) 
for i = 1:length(index)
    tzero        = find(W(1:index(i)) == 0);
    ta(i)        = max(tzero);
    binop(ta(i)) = 1;
end

%% If the decision rule not satisfied
if isempty(binop(binop(Dataparams.t0*Dataparams.fs:end)>0)) == 1
    t0cap = NaN;
    disp('Onset not found')
else
    t0cap = t(Dataparams.t0*Dataparams.fs-1 + min(find(binop(Dataparams.t0*Dataparams.fs:end) == 1)));
end


%% Save internal variables in a struct
SSAOutput.Dn         = D;
SSAOutput.cumStats   = W;
SSAOutput.peaks      = index;
SSAOutput.binop      = binop;
SSAOutput.t0cap      = t0cap;
SSAOutput.paramcombo = variable;
SSAOutput.dataparams     = Dataparams;
end