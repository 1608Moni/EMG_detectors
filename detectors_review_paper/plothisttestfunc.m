clc
clear all
close all

data = load('testfuncH1alpha3.mat');
dataH0 = load('testfuncH0alpha3.mat');
%%
%H0 = cell2mat(dataH0.testfuncNoise(:,1:1898));
%H1 = cell2mat(data.testfuncEMG(:,1:1898));
cutoff  = 1.5:1:9.5;
% RestdataH0 = cellfun(@(x) x(1:2001),dataH0.testfuncNoise  ,'UniformOutput',false);
% RestdataH1 = cellfun(@(x) x(1:2001),data.testfuncEMG  ,'UniformOutput',false);
% dataH0 = cellfun(@(x) x(1:end),dataH0.testfuncNoise  ,'UniformOutput',false);
% dataH1 = cellfun(@(x) x(1:end),data.testfuncEMG  ,'UniformOutput',false);
DATAH0 = cell2mat(dataH0.testfuncNoise(:,27));
DATAH1 = cell2mat(data.testfuncEMG(:,27));



for j = 1:size(dataH0.testfuncNoise,1)

    restH0(j,:) = DATAH0(j,1:2001);
    restH1(j,:) = DATAH1(j,1:2001);
    
    moveH0(j,:) = DATAH0(j,2002:end);
    moveH1(j,:) = DATAH1(j,2002:end);
    
%     H0 = [];
%     for i = 1:1898
%         H0 = [H0 dataH0.testfuncNoise{j,i}];
%     end
%   
%      figure(1);
%     hold on; 
%     histogram(H1(j,:),'BinWidth',0.5,'Displaystyle','stairs')
%     title('H1')
%     xlim([0 50])

%     H0stats(j,1) = mean(H0(j,:),2);
%     H0stats(j,2) = std(H0(j,:),'',2);
%     H0stats(j,3) = H0stats(j,1) + 2*H0stats(j,2);
%     
%      H1stats(j,1) = mean(H1(j,:),2);
%     H1stats(j,2) = std(H1(j,:),'',2);
%     H1stats(j,3) = H1stats(j,1) + 2*H1stats(j,2);
    figure(j);
    hold on; 
    histogram(moveH0(j,:),'BinWidth',0.05,'Displaystyle','stairs')
    hold on
    xline(mean(restH0(j,:) + 2*std(restH0(j,:))),'r--')
%     xline(H0stats(j,3),'r--')
     hold on; 
    histogram(moveH1(j,:),'BinWidth',0.05,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4])
    hold on
   xline(mean(restH1(j,:)+ 2*std(restH1(j,:))),'k--')
    title(strcat('H0',num2str(cutoff(j))))
    legend('H0','h_H0','H1','h_H1');
     xlim([0 50])
%     export_fig(char('filterCharalpha2H0&H1Trial26'),'-pdf','-append',figure(j));
    
end
%%
H0stats(:,1) = mean(H0,2);
H0stats(:,2) = std(H0,'',2);
H0stats(:,3) = H0stats(:,1) + 2*H0stats(:,2);
H1stats(:,1) = mean(H1,2);
H1stats(:,2) = std(H1,'',2);
H1stats(:,3) = H1stats(:,1) + 2*H1stats(:,2);
