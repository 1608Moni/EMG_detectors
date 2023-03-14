function detectorOutput = EMGdetector(x, variable, params, Dataparams)
%% Function to run the hodges algorithim over single trial for one of the parameter combination
%
%

%% Initialise and define parameters
detectorOutput = struct(); 
Wsize        = variable(1);
weight       = variable(2);  %% Scaling factor for stdv / threshold for test func
p            = variable(3);  %% incremente the sliding window by p samples;
T1           = variable(4);  %% double threshold paramter in ms
T1           = T1/p;         %% Temporal threshold in samples
fl           = params.fl;
fh           = params.fh;
fs           = Dataparams.fs;
t            = (1/fs):(1/fs):Dataparams.dur;
fs1          = fs/p ;
t1           = ((1/fs1)):(1/fs1):Dataparams.dur;
% g            = zeros(1,length(t1)+((Wsize/p)*fs));
 bin1         = zeros(1,length(t));
% bin2         = zeros(1,length(t1)+((Wsize/p)*fs));
% binop        = zeros(1,length(t1)+((Wsize/p)*fs));

%% Signal Conditioning

%band Pass filter
[b,a]   = butter(2,[fl/(Dataparams.fs/2) fh/(Dataparams.fs/2)],'bandpass');
EMG_bpf = filter(b,a,x);

% %% Computing the threshold from baseline (2s of data) leaving the initial 1s
% mean_baseline = mean(EMG_lpf(params.tB-params.M+1:params.tB));
% stdv_baseline = std(EMG_lpf(params.tB-params.M+1:params.tB));
% h             = mean_baseline + weight*stdv_baseline;
% threshold     = weight;

% l=round(((Wsize/p)*fs));
%% Computing the test function over sliding window 
for i = 1:p:length(t)
    if i > (Wsize*fs)-1
        
        %% test function -  compute the root mean square  
        g(i) = sqrt((1/(Wsize*fs)*sum(EMG_bpf((i-(Wsize*fs)+1):i).^2)));
        
        if  i > params.tB
            %% To compute threshold
            g_downsampled =[zeros(1,round((Wsize*fs)/p)) g(1:p:i)];
            g_downsampled = g_downsampled(1:end-round((Wsize*fs)/p));
            
            mean_base = mean(g_downsampled(1:((params.tB)-round(Wsize*fs))/p));
            stdv_base = std(g_downsampled(1:((params.tB)-round(Wsize*fs))/p));
            h         = mean_base + weight*stdv_base;
            if g(i) > h
                bin1(i) = 1;
            end
               
                
%             bin1 = bin1(1:p:i);            
        end          
    end
end

bin1 = bin1(1:p:end);
% %% double threshold
% %if last T1 samples were 1

    binop(1) = 0;
     for j = 2:length(bin1)
        if j > T1
            f2(j) = (1/T1)*sum(bin1(j-T1+1:j)); 
            if f2(j) == 1
                binop(j)=1;
            elseif f2(j) > 0
                binop(j) = binop(j-1);  
            elseif f2(j) == 0
                binop(j) = 0;                    
            end
        end
     end

%             
%             if i > T1*p                  
%                 f2(l) = (1/T1)*sum( bin1_downsampled(i-T1+1:i));
%                 if f2(l) == 1
%                     binop(l)=1;
%                 elseif f2(l) > 0
%                     binop(l) = binop(l-1);  
%                 elseif f2(l) == 0
%                     binop(l) = 0;                    
%                 end
%             end






%% If the decision rule not satisfied
if isempty(binop(binop(Dataparams.t0*Dataparams.fs/p:end)>0)) == 1
    t0cap = NaN;
    disp('Onset not found')
else
    t0cap = t1(Dataparams.t0*Dataparams.fs/p-1 + min(find(binop(Dataparams.t0*Dataparams.fs/p:end) == 1))-1);
end
% 
% subplot(2,1,1)
% plot(t(1:p:end),g(1:p:end),'Color',[0 0 1 0.4]);hold on; yline(h);
% hold on
% stem(t(1:p:end),bin1,'LineWidth',1.25);
% ylim([-0.1 1.1])
% subplot(2,1,2)
% stem(t(1:p:end),binop,'LineWidth',1.25);
% hold on
% xline(t0cap)
% ylim([-0.1 1.1])
% %%





% %% Saving internal variable in structure
detectorOutput.emgbpf     = EMG_bpf;
detectorOutput.testfunc   = g;
detectorOutput.binop      = binop;
detectorOutput.bin1       = bin1;
detectorOutput.t0cap      = NaN;
detectorOutput.paramcombo = variable;
detectorOutput.h          = h;
detectorOutput.mean_baseline  = mean_base;
detectorOutput.stdv_baseline  = stdv_base;
detectorOutput.dataparams     = Dataparams;

end