function [new] = bootsraptest(output,j,Sample,Caccept,new)
% clc
% clear all
% close all
% 
% 
% Outdir     = 'costfunction\';
% 
% datafile   = ["gaussian_stepDetector13train.mat","laplacian_stepDetector13new.mat","BioPhy_stepDetector13new.mat"];%,"BioPhy_steplatest.mat"];
%% Naming the table
% alname = {'Detector2018','Hodges','Mod.Hodges','AGLR-G','AGLR-L','Fuzz.Ent','Samp.Ent','Lidierth','Mod.Lidierth'...
%         'Bonato','TKEO','CWT','SSA'};  


%%
  
%%
% for j = 1:length(datafile)
% 
%     outputfile = Outdir + datafile(j);
% 
%     output =  load(outputfile);

    %% rearrange the matrix
    % A = [output.cost{1};output.cost{2};output.cost{3};output.cost{4};...
    %     output.cost{5};output.cost{6};output.cost{7};output.cost{8};output.cost{9};output.cost{10};output.cost{11};output.cost{12}];

    for i = 1:size(output.cost,2)
    A = output.cost{i};

    A_snr0 = A(:,1);
    A_snr3 = A(:,2);
    
    %% To find the percentage of number of trails with cost less than 0.2     
    OptTrailSNR0 = find(A_snr0 < 0.2);
    Prob_OptTrail(i,1) = length(  OptTrailSNR0 )/length(A_snr0);
    
    OptTrailSNR3 = find(A_snr3 < 0.2);
    Prob_OptTrail(i,2) = length(  OptTrailSNR3 )/length(A_snr3);
    
    
    %%
%     [a0,b0]= bootstrp(Sample,@percentile99,A_snr0);
%     [a1,b1]= bootstrp(Sample,@percentile99,A_snr3);
%        
%     h1(i,1)= length(find(a0 < Caccept))/Sample;
%     h1(i,2)= length(find(a1 < Caccept))/Sample;
    
%     for j = 1:size(b0,2)
%         for k = 1:size(b0,1)
%         samp_data0(k,j) = A_snr0(b0(k,j));
%         samp_data3(k,j) = A_snr3(b1(k,j));
%         end
%     end
%      t = 1:1:100;
%      boxplot(samp_data0,'PlotStyle','compact');
%      hold on
%      yline(0.22,'r--','LineWidth',1);
%      hold on
%      plot(t,a0,'r*')
%      figure
%      boxplot(samp_data3,'PlotStyle','compact');
%      hold on
%      yline(0.22,'r--','LineWidth',1);
%      hold on
%      plot(t,a1,'r*')
        
    
    end
%     if j > 1
%        finalmatrix = [finalmatrix h1]; 
%     end
    
%      new(:,((2*j)-1):2*j)= h1;
    new(:,((2*j)-1):2*j)=Prob_OptTrail;
%       new = [new h1];
    
end   
    
 
   
%     xlswrite(alname,'bootstrapresults6.xls','Range','A3:A14');


