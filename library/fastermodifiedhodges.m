function hodgesOutput = fastermodifiedhodges(x, variable, params, Dataparams)

weight       = variable(1);
fc           = variable(2);
fs           = Dataparams.fs;
t            = (1/fs):(1/fs):Dataparams.dur;
Binop        = zeros(size(x));

%% Signal Conditioning
%Rectifier
EMG_rect = abs(x);

%Low Pass filter
[b,a]   = butter(2,fc/(fs/2));
EMG_lpf = filter(b,a,EMG_rect,[],2);

%% Computing the threshold from baseline (2s of data) leaving the initial 1s
mean_baseline = mean(EMG_lpf(:,params.tB-params.M+1:params.tB),2);
stdv_baseline = std(EMG_lpf(:,params.tB-params.M+1:params.tB),0,2);
h             = mean_baseline + weight.*stdv_baseline;

%% Binary Output
Binop(:,2002:end) = EMG_lpf(:,2002:end) > h ;


%% Saving internal variable in structure
  hodgesOutput.emgrect    = EMG_rect;
 % hodgesOutput.testfunc     = EMG_lpf;
hodgesOutput.binop      = Binop;
% hodgesOutput.t0cap      = NaN;
hodgesOutput.paramcombo = variable;
hodgesOutput.h  = h;
% hodgesOutput.mean_baseline  = mean_baseline;
% hodgesOutput.stdv_baseline  = stdv_baseline;
% hodgesOutput.dataparams = Dataparams;

%% plot function
for i = 1:size(hodgesOutput.emgrect(1,:),1)
%     plot(t, hodgesOutput.emgrect(i,:),'Color', [0.8 0.85 1]);
%     hold on
%     plot(t, hodgesOutput.testfunc(i,:),'Color',[0.6 0 0.2]);
%     hold on
%     yline(h(i),'r--')
%     hold on
%     plot(t,max( hodgesOutput.testfunc(i,:)).*hodgesOutput.binop(i,:),'Color',  [0 0 0 0.4]);
      histogram((EMG_lpf(i,2002:end)-mean(EMG_lpf(i,2002:end)))/std(EMG_lpf(i,2002:end)),'DisplayStyle','stairs','BinWidth',0.05);
      hold on
      histogram((EMG_lpf(i,1:2001)-mean(EMG_lpf(i,1:2001)))/std(EMG_lpf(i,1:2001)),'DisplayStyle','stairs','EdgeColor',[0.6 0 0.2],'BinWidth',0.05);
      xline(3,'r--')
%     pause(2)
%     close all
end



end