clc
clear all
close all

c = [0 1 0; 0 0 1;1 0 1; 0 0 0; 0 1 1; 1 1 0 ;1 0 0; 0.5 0.5 0.5; 0.6 0 1; 0 0.4 0.7; 0.8 0.3 0.09; 0.6 0.07 0.18 ; 0.3 0.75 0.9];

algoname   = {'Detector2018','hodges','modifiedhodges','AGLRstepLaplace','AGLRstep','FuzzyEnt','SampEnt','lidierth','modifiedLidierth','bonato','TKEO','CWT','SSA'};
a1 = [0.43,0.45,0.89,0.76,0.72,0.78,0,0.36,0.67,0.23,0.43,0,0];
a2 = [0.24,0.26,0.43,0.44,0.4,0.33,0,0.17,0.25,0.01,0.01,0,0];

for i = 1:length(a1)
figure(1)
hold on
s(i) = scatter(a1(i),1,[],c(i,:),'filled');
hold on
scatter(a2(i),3,[],c(i,:),'filled');
legend([s],algoname)
ylim([0,4])
end
% h = gca; 
% h.XTickLabel = algoname';
% h.XTick = [1:1:13];
% h.XTickLabelRotation = 20;
