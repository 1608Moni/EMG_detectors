%% script to plot comprehensive of all intermediate variable.

clc
clear all
close all


%%
% datadir    = 'D:\Phd_july-nov sem\Review paper\emg_detectors\data\';
% datafiles  = ["TestEMGDataTouSNR-3trail50dur13gaussian.mat"];
% datafile   = datadir + datafiles(1);
% data       = load(datafile);

%% 
mode = "Test";
method= "Pmove";
datadir            = '..\data\';
detector = {'modifiedhodges'};
processdir  =  strcat('process\',mode,'\');
trail = 6;
paramcombo = 1;
SNR        = 0;
type       = {'biophy'};
filename = strcat(mode,'Pmove.xls');
probm = xlsread(char(filename));

field      = strcat("Pmove",mode,detector(1),'trail',num2str(trail),...
                        'paramcombo',num2str(paramcombo),type,'SNR',num2str(round(SNR)));                    
outputfiles = strcat('Output',field,'.mat');%["Outputmodifiedhodgestrail6paramcombo1gaussianSNR-3.mat"];%,"Outputhodgestrail5paramcombo1laplacianSNR0.mat"];
outputfile1 = processdir + outputfiles(1);
output     = load(outputfile1);

field      = strcat("NoisePmove",mode,detector(1),'trail',num2str(trail),...
                        'paramcombo',num2str(paramcombo),type,'SNR',num2str(round(SNR)));                    
outputfiles = strcat('Output',field,'.mat');%["Outputmodifiedhodgestrail6paramcombo1gaussianSNR-3.mat"];%,"Outputhodgestrail5paramcombo1laplacianSNR0.mat"];
outputfile2 = processdir + outputfiles(1);
outputNoise     = load(outputfile2);


%% figure
t0 = output.dataparams.t0*output.dataparams.fs;
fs = output.dataparams.fs;
t  = (1/fs):(1/fs):output.dataparams.dur;
   
         datafile = strcat(method,mode,"SNR",num2str(SNR),"trail",num2str(50),"dur",num2str(13),"biophy");
        if mode == "Test"
%             datafile = strcat("Test",datafile);
            disp("Running the validation set")
        end
        GTfile     = datadir + string(datafile);
        data       = load(GTfile);
        groundtruth = data.groundtruth;
   

 

  [LR0,pmove0,prest0] = likeihoodratio(outputNoise.binop,t0,1);        
  [LR1,pmove1,prest1] = likeihoodratio(output.binop,t0,1);
                          
% figure
% % subplot(2,2,1)
% plot(t,data.data(1,:));
% xlim([0, 13]);

fig1 = figure;
rectangle('Position', [0,-3,3,7], 'FaceColor',[1 1 0.9],'EdgeColor',[0.9 0.9 0.9])
rectangle('Position', [3,-3,8,7], 'FaceColor',[1 0.93 0.9], 'EdgeColor',[0.9 0.9 0.9])
rectangle('Position', [8,-3,13,7], 'FaceColor',[0.90 1 0.9], 'EdgeColor',[0.9 0.9 0.9])
set(gca, "Layer", "top")
hold on;  
% subplot(2,1,1)
% plot(t,output.emgrect,'y')
% hold on
lh = plot(t,output.emgrect);
lh.Color = [0, 0, 1, 0.15];

hold on
p1=plot(t,output.testfunc, 'Color', [0.8, 0, 0], 'LineWidth', 1.25);
hold on;
p2=plot(t(1:3000),repmat(output.mean_baseline,1,3000),'Color',[0.5 0.17 0.5],'LineWidth', 1);
%  yline(output.mean_baseline,'Color',[0.5 0.17 0.5],'LineWidth', 1);
hold on
p3=yline(output.h,'LineWidth', 1,'Color',[0 0.6 0]);
hold on
p5 = stairs(t,groundtruth(trail,:)/2,'r','LineWidth', 0.75);
hold on
p6=stairs(t,output.binop/2,'Color',[0 0 0],'LineWidth', 0.75);

xlim([0, 13]);
ylim([-0.1, 1]);
l= legend([lh,p1,p3,p5,p6],'Rectified EMG (|x[n]|)','Filtered EMG (g[n])','Threshold (h)','groundtruth','Output (y[n])')
set(legend,'Orientation','vertical',...
    'Interpreter','tex','FontSize',12,'EdgeColor',[1 1 1], 'Box', 'off','FontName','Helvetica');
xlabel('Time (s)');
ylabel('Amplitude')
set(gca,"FontSize",15)
set(gca, "LineWidth",1.1)
annotation(fig1,'textbox',...
    [0.131458365271729 0.86 0.474000000000002 0.068],...
    'String','                                                            REST',...
    'FontWeight','bold',...
    'LineStyle','none',...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],'Color',[1 1 1],'BackgroundColor',[0.8 0.8 0.8]);
annotation(fig1,'textbox',...
    [0.606304215833795 0.86 0.299162904886355 0.068],...
    'String','                               MOVE',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1], 'Color', [1 1 1],'BackgroundColor',[0.150 0.150 0.150]);



%% text for the plots
txt = {strcat('Prest = ',num2str(round(prest1,3)))};
text(4.5,0.8,txt,'FontSize',15)
txt1 = {strcat('Pmove = ',num2str(round(pmove1,3)))};
text(10,0.8,txt1,'FontSize',15)
txt2 = {strcat('Pemg = ',num2str(round(probm(trail),3)))};
text(10,0.6,txt2,'FontSize',15)
% text(4,2.85,'Rest','FontSize',15)
% text(10,2.85,'Move','FontSize',15)probm
%%
title(strcat(mode,"ModifiedHodges"))

fig2 = figure;
rectangle('Position', [0,-3,3,7], 'FaceColor',[1 1 0.9],'EdgeColor',[0.9 0.9 0.9])
rectangle('Position', [3,-3,8,7], 'FaceColor',[1 0.93 0.9], 'EdgeColor',[0.9 0.9 0.9])
rectangle('Position', [8,-3,13,7], 'FaceColor',[0.90 1 0.9], 'EdgeColor',[0.9 0.9 0.9])
set(gca, "Layer", "top")
hold on;  
% subplot(2,1,1)
% plot(t,output.emgrect,'y')
% hold on
lh = plot(t,outputNoise.emgrect);
lh.Color = [0, 0, 1, 0.15];

hold on
p1=plot(t,outputNoise.testfunc, 'Color', [0.8, 0, 0], 'LineWidth', 1.25);
hold on;
p2=plot(t(1:3000),repmat(outputNoise.mean_baseline,1,3000),'Color',[0.5 0.17 0.5],'LineWidth', 1);
%  yline(output.mean_baseline,'Color',[0.5 0.17 0.5],'LineWidth', 1);
hold on
p3=yline(outputNoise.h,'LineWidth', 1,'Color',[0 0.6 0]);
hold on
p6=stairs(t,outputNoise.binop/2,'Color',[0 0 0],'LineWidth', 0.75);

xlim([0, 13]);
ylim([-0.1, 1]);
l= legend([lh,p1,p3,p6],'Rectified EMG (|x[n]|)','Filtered EMG (g[n])','Threshold (h)','Output (y[n])')
set(legend,'Orientation','vertical',...
    'Interpreter','tex','FontSize',12,'EdgeColor',[1 1 1], 'Box', 'off','FontName','Helvetica');
xlabel('Time (s)');
ylabel('Amplitude')
set(gca,"FontSize",15)
set(gca, "LineWidth",1.1)
annotation(fig2,'textbox',...
    [0.131458365271729 0.86 0.474000000000002 0.068],...
    'String','                                                            REST',...
    'FontWeight','bold',...
    'LineStyle','none',...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1],'Color',[1 1 1],'BackgroundColor',[0.8 0.8 0.8]);
annotation(fig2,'textbox',...
    [0.606304215833795 0.86 0.299162904886355 0.068],...
    'String','                               MOVE',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1], 'Color', [1 1 1],'BackgroundColor',[0.150 0.150 0.150]);



%% text for the plots
txt = {strcat('Prest = ',num2str(round(prest0,3)))};
text(4.5,0.8,txt,'FontSize',15)
txt1 = {strcat('Pmove = ',num2str(round(pmove0,3)))};
text(10,0.8,txt1,'FontSize',15)
title(strcat(mode,"Noise","ModifiedHodges"))

                                  
                                  