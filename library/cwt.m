 function cwtOutput = cwt(x, variable, params, Dataparams)
%% Function to run the hodges algorithim over single trial for one of the parameter combination
%
%

%% Initialise and define parameters
cwtOutput    = struct(); 
gamma        = variable(1);
fs           = Dataparams.fs;
N            = Dataparams.dur*Dataparams.fs;
t            = (1/fs):(1/fs):Dataparams.dur;
binop        = zeros(1,length(t));

%% computing the continous wavelet transform for different shapes of MUAP

for j =1:length(params.a)
    w = wavelet(params.lamda(j),params.a(j),params.tou); 
    [r(j,:),lags(j,:)] = xcorr(x,w);
    [ temp(j), index(j)] = max(r(j,:));
end

%% filter to optain only the required duration signal of the correlated
[maximum,ind] = max(temp);
for i = 1:length(r(ind,:))
    if i < (N/2+length(t)-params.tou) && i > (N/2)-1-params.tou
        filt(i) = 1 ;
    else
        filt(i) = 0;
    end
end
g = (r(ind,:)).*filt;
g(g==0) = [];
% figure
% subplot(3,1,1)
% plot(x)
% subplot(3,1,2)
% plot(w)
% subplot(3,1,3)
% plot(r(ind,:))
% hold on
% plot(filt,'r--','LineWidth',2)

%% Deciding the threshold

th = max(g(params.tB-params.M+1:params.tB));
h  = gamma*th;

%% decision rule
for i = 1:length(g)
    if g(i) > h
        binop(i) = 1;
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
cwtOutput.testfunc    = g;
cwtOutput.binop      = binop;
cwtOutput.t0cap      = t0cap;
cwtOutput.paramcombo = variable;
cwtOutput.h  = h;
cwtOutput.dataparams = Dataparams;
% figure
% plot(t,g)
% hold on
% yline(h)

end