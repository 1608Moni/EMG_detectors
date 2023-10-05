% clc
% clear all
% close all

combo = 1:25;
Params = string(combo);

paramcombo = repmat(Params,1,2);
costfactors = [repmat({'E'},1,length(Params)),repmat({'N'},1,length(Params))];
MaxSepAllcombo = load('D:\EMG detectors\detectors_review_paper\AGLRstepPdALLcombo.mat');
PmoveEMG = MaxSepAllcombo.MaxSepAllcombo(:,1:2:end);
PmoveNoise = MaxSepAllcombo.MaxSepAllcombo(:,2:2:end);
ActiveTrials = PmoveEMG > PmoveNoise;
Zscores_ = [];
grp = [];
%% Computing Z score for all trials in each parameter
for i = 1:5
    
    %% 
  
    index = find(ActiveTrials(:,i) == 1);
    Pdactive =  PmoveEMG(index,i);
    Pdnoise = PmoveNoise(index,i);
    PmoveLogNoise_ = log(Pdnoise);
    PmoveLogEMG_ = log(Pdactive); 
    indfin = isfinite(PmoveLogNoise_);
    InfIgnorePmove = PmoveLogNoise_(indfin);
    InfIgnorePemg =  log(Pdactive(indfin));
    meanLog = mean(InfIgnorePmove);
    stdr = std(InfIgnorePmove);
    
    pdN = Pdnoise/sum(Pdnoise);
    pdE = Pdactive/sum(Pdactive);
   
    kldistance(i) = nansum(pdE .* log(pdE ./  pdN));
    zNoise = InfIgnorePmove - meanLog./stdr; 
    z = (InfIgnorePemg  - meanLog)./stdr;
    kldistZscore(i) = sum(z .* log(z ./   zNoise ));
    b = InfIgnorePemg .* log(InfIgnorePemg ./   InfIgnorePmove );
    kldistlog(i) = sum(b(isfinite(b)));
    grp = [grp; (i+1)*ones(size(z))];
    Zscores_ = [Zscores_; z];
    
%     figure(i)
%     hold on
%     histogram((pdN),'Displaystyle','stairs','LineWidth',1.5);
%     hold on
%     histogram(pdE,'Displaystyle','stairs','LineWidth',1.5);
%     xlim([0 0.005])
%     txt = {strcat('kldistance = ',num2str(kldistance(i)))};
%     text(100,1,txt,'FontSize',12)
%     legend('H0','H1')
%     legend
end
Zscores_ = [randn(2755,1); Zscores_];
grp = [1*ones(2755,1);grp];
figure
 boxplot(Zscores_,grp)
 ylabel('zscores')
 xlabel('parametercombination')

figure(1);hold on; histogram(randn(1,2755),'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
Bw = 0.002;
[u1,v1] = ksdensity(log(PmoveNoise(:,4)),'Bandwidth',Bw);

%pdf_values = (1 / (stdr * sqrt(2*pi))) * exp(-0.5 * ((PmoveLogNoise_- meanLog) / stdr).^2);
w = meanLog + (stdr)*randn(1,length(PmoveLogNoise_));
figure(1)
histogram(PmoveLogNoise_,'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
% hold on
% histogram(w,'BinWidth',0.1,'Displaystyle','stairs','LineWidth',1.5)
figure
histogram((PmoveNoise(:,4)),'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
% figure
% plot(v1,u1);
likelihoodratio = PmoveEMG./PmoveNoise;
% indexNaN = find(isnan(likelihoodratio));
% indexInf = find(isinf(likelihoodratio));
% likelihoodratio(indxNaN) = 0;
% likelihoodratio(indxNaN) = 0;

DelP = PmoveEMG - PmoveNoise;
figure
BoxplotData = [PmoveEMG PmoveNoise];
boxplot(BoxplotData,{paramcombo,costfactors},'colors',repmat('km',1,2),'factorgap',[7 1],'labelverbosity','minor','BoxStyle','filled');
ylabel('ProbDetection')
title('ModifiedHodges')  
figure
boxplot(likelihoodratio);
ylabel('Likelihood ratio')
xlabel('Parameter Combination')
title('ModifiedHodges')  
figure
boxplot(DelP)
title('ModifiedHodges')
