clc
clear all
close all

addpath 'D:\EMG detectors\library'
Detectors = ["modifiedhodges"];
%%  Get the parameters
    mode = "Train";
    method = "";
    type = "";
    SNR = [];
   paramfuncname = strcat(Detectors(1), '_param');
   paramfunc =  str2func(paramfuncname);
   params = paramfunc(mode,type,SNR,Detectors(1),method);
   combo = 1:numel(params.combo);
   Params = string(combo);
    cutoff = params.fc;


paramcombo = repmat(Params,1,2);
costfactors = [repmat({'E'},1,length(Params)),repmat({'N'},1,length(Params))];
MaxSepAllcombo = load('D:\EMG detectors\detectors_review_paper\Probdetection\modifiedhodgesPdALLcombo.mat');
PmoveEMG = MaxSepAllcombo.MaxSepAllcombo(:,1:2:end);
PmoveNoise = MaxSepAllcombo.MaxSepAllcombo(:,2:2:end);
% %% Plot boxplot of Pd
figure
BoxplotData = [PmoveEMG PmoveNoise];
boxplot(BoxplotData,{paramcombo,costfactors},'colors',repmat('km',1,2),'factorgap',[7 1],'labelverbosity','minor','BoxStyle','filled');
ylabel('ProbDetection')
title(Detectors(1))  

% Include only the trials for which there is some EMG activity than noise 
 Activetrials = PmoveEMG > PmoveNoise;
 fig1 =1;
 Zscore = [];
 grp = [];
%% plot the probability distribution of null hypothesis H0;
for i=1:length(combo)
    index = find(Activetrials(:,i) == 1);
    Pmovenoise_Log = log(PmoveNoise(index,i));
    Pmoveemg_Log = log(PmoveEMG(index,i));
    
    meanH0 = mean(Pmovenoise_Log(isfinite(Pmovenoise_Log)));
    stdH0 = std(Pmovenoise_Log(isfinite(Pmovenoise_Log)));
    zH0 = (Pmovenoise_Log - meanH0)./stdH0;
    zH1 = (Pmoveemg_Log - meanH0)./stdH0;
    
    %% Cummulate all zscore for each combination in a array to plot boxplot
    grp = [grp; (i)*ones(size(zH1))];
    Zscore = [Zscore; zH1];
    
    medianZH1 = median(zH1);
    rangeZH1 = iqr(zH1);
    
    ratiomeas(i) = medianZH1/rangeZH1;
%     
%     figure
%     histogram(Pmovenoise_Log,'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
%     hold on
%     histogram(Pmoveemg_Log,'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0 0 0.8],'LineWidth',1.5);
%     
%       figure
%     histogram(zH0, 'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
%     hold on
%     histogram(zH1, 'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0 0 0.8],'LineWidth',1.5);
%     
%     close all
    
%% Computing the KL divergence
%     % (a) For only the probabilities    
     kl(i) = kldistance(PmoveNoise(index,i),PmoveEMG(index,i),1);
% %     % (b) For the log of probabilities 
%     kl_log(i) = kldistance(Pmovenoise_Log,Pmoveemg_Log,2);
%     
%     %(c) for the z scores
%     kl_zcore(i) = kldistance(zH0, zH1,2);
%% Computing the median/IQR ratio of the normalise z-scores
    ratiomediqr(i) = median(zH1)/iqr(zH1);

%% Computing the Total variance distance
    variancemeas = abs(PmoveEMG(index,i) - PmoveNoise(index,i));
    TVD(i) = 0.5 * sum(abs(PmoveEMG(index,i) - PmoveNoise(index,i)));
    
    fig = figure(fig1);
    fig.Position = [1 1 1280 647.3333];
    ind = mod(i,5);
    if ind == 0
        ind = 5;
        fig1 = fig1 + 1;
    end
    subplot(2,3,ind)
    histogram(zH0,'BinWidth',0.05,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
    hold on
    xline(mean(zH0(isfinite(zH0))),'k--')
    histogram(zH1,'BinWidth',0.05,'Displaystyle','stairs','EdgeColor',[0 0 0.8],'LineWidth',1.5);
    hold on
    xline(mean(zH1(isfinite(zH1))), 'r--' )
    ylim([0 120])
    %     hold on
%      histogram(variancemeas,'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[1 0 0.8],'LineWidth',1.5);
%     text(0.5,100, strcat('KLD : ' ,num2str(round(kl(i),2))));
%     text(0.5,200, strcat('medIqrRatio : ' ,num2str(round(ratiomediqr(i),2))));
%     text(0.5,400, strcat('TVD : ' ,num2str(round(TVD(i) ,2))));
%     ylim([0 500])
    
%     text(0.5,100, strcat('zscore',num2str(ratiomeas(i)) ))
end

 figure
 boxplot(Zscore,grp)
 ylabel('zscores')
 xlabel('parametercombination')
 title('AGLR-L')
 
 %%
 
