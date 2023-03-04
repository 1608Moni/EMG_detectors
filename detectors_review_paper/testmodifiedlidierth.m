%% script to plot comprehensive of all intermediate variable.

clc

%%
datadir    = '..\data\';
datafiles  = ["EMGDataSNR0trail50dur13gaussian.mat"];
datafile   = datadir + datafiles(1);
data       = load(datafile);

%% 
processdir  = 'D:\Phd_july-nov sem\Review paper\emg_detectors\detectors_review_paper\process\';
outputfiles = ["OutputmodifiedLidierthtrail25paramcombo83gaussianSNR0.mat"];
outputfile = processdir + outputfiles(1);
output     = load(outputfile);

%% figure
t0 = output.dataparams.t0*output.dataparams.fs;
fs = output.dataparams.fs;
t  = (1/fs):(1/fs):output.dataparams.dur;
groundtruth = GroundTruth(output.dataparams.dur*output.dataparams.fs,t0);

[CF,Latency,f_delT,rFP,rFN] = costfunc_eachtrial(output.binop,output.t0cap,...
                              groundtruth,t0,3000,fs); 
                          
figure
% subplot(2,2,1)
plot(t,data.data(1,:));
xlim([0, 13]);

figure
% subplot(2,2,2)
plot(t,output.emgrect,'y')
hold on
plot(t,output.emglpf,'r')
hold on
yline(output.mean_baseline)
hold on
yline(output.mean_baseline+output.stdv_baseline,'r')
hold on
yline(output.h,'m--')
hold on
xline(output.t0cap)
hold on
xline(output.dataparams.t0,'r--')
xlim([0, 13]);
legend('EMG_rect','EMG_lpf','mean','mean+stdv','threshold','t0cap','t0')
% figure
% % subplot(2,2,3)
% yline(output.mean_baseline)
% hold on
% plot(t,output.movAvg)
% hold on
% plot(t,output.testfunc,'m')
% xlim([0, 13]);
% legend('mean','movAvg','testfunc')
figure
subplot(4,1,1)
plot(t,output.bin1)
xlim([0, 13]);
ylim([-0.1, 1.1])
subplot(4,1,2)
plot(t, output.bin2)
xlim([0, 13]);
ylim([-0.1, 1.1])
subplot(4,1,3)
plot(t,output.binop,'b')
hold on
xline(output.dataparams.t0,'r--')
legend('binop','t0cap','Actual Onset');
ylim([-0.1, 1.1])
xlim([0, 13]);
subplot(4,1,4)
plot(t,groundtruth-output.binop)
ylim([-0.1, 1.1])
xlim([0, 13]);
%legend('EMG_rect','EMG_lpf','mean','mean+stdv','threshold','movAvg','testfunc','binop','t0cap','Actual Onset')

                                  
                                  