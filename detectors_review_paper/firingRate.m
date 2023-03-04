%% function to identify the firing rate of the signals
clc
clear all
close all

%% define variables in the script
BioPhydatadir   = 'EMG_BiophymodelData\';
datadir         = '..\data\';
datafiles = ["RawEMGforce30.mat"];

%%
datafile = BioPhydatadir + datafiles(1); 
EMG = load(datafile);
EMG = EMG.data;

%%

%  figure
%  plot(EMG(:,2))
%  hold on
%  plot(EMG(:,1))
% %  EMG = EMG(147:512143,2);  % force level = 10 
% %  EMG = EMG(1:516688,2);    % force level = 15;
% % EMG = EMG(2248:514244,2);    % force level = 8;
% EMG = EMG(18000:3218000,2);
%  fs = 1;
 


% Actual onset
% t0 = 3000;
% trail= 50;
% output.t0 = t0;
% EMG_sample = EMG(1:8*fs:end-1,1);
% figure
% plot(EMG_sample)
% 
% EMG_new = reshape(EMG_sample,[(length(EMG_sample)/trail),trail])';

figure
plot(EMG(1,:))



% [pks,locs1] = findpeaks(EMG(1,:),'MinPeakHeight',0.08);
% [pks1,locs2] = findpeaks(EMG(1,:),'MinPeakHeight',0.06);
%  
% [value,index] = intersect(locs2,locs1);
% 
% locs2(index)=0;
% locs2 = locs2(locs2>0);
% 
% 
[pks1, locs2] = findpeaks(EMG(1,:),'threshold',0.004);

% pks1(index)=0;
% pks1 = pks1(pks1>0);


 
 
meanCycle = mean(diff(locs2))
AvgFiringRate = (1 / meanCycle)*1000
 
figure
plot(EMG(1,:))
hold on
plot(locs2,pks1,'*')
%  hold on
% plot(locs1,pks,'o')