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
processdir  = 'D:\Phd_july-nov sem\Review paper\emg_detectors\detectors_review_paper\process\';
outputfiles = ["OutputDetector2018Newtrail20paramcombo1gaussianSNR0.mat"];%,"Outputhodgestrail5paramcombo1laplacianSNR0.mat"];
outputfile1 = processdir + outputfiles(1);
output     = load(outputfile1);
type       = ["gaussian"];

% outputfile2 = processdir + outputfiles(2);
% output2     = load(outputfile2);

% outputfile3 = processdir + outputfiles(3);
% output3     = load(outputfile3);

%% figure
t0 = output.dataparams.t0*output.dataparams.fs;
fs = output.dataparams.fs;
t  = (1/fs):(1/fs):output.dataparams.dur;
% t  = ((1/fs)+output.paramcombo(1)):(1/fs):output.dataparams.dur;
groundtruth = GroundTruth(output.dataparams.dur*output.dataparams.fs,t0,type);
 Wsize = (output.paramcombo(1)*fs);
Wshift = output.paramcombo(3);
fs1          = fs/Wshift ;
t1           = (1/fs1):(1/fs1):output.dataparams.dur;
% output.binop = [zeros(1, round(Wsize/Wshift)) output.binop];
% binop        = output.binop(1:end-round(Wsize/Wshift));
% t0cap        = t2(output.dataparams.t0*output.dataparams.fs/Wshift-1 + min(find(binop(output.dataparams.t0*output.dataparams.fs/Wshift:end) == 1)));
[CF,Latency,f_delT,rFP,rFN] = costfunc_eachtrial(output.binop,output.t0cap,...
                               groundtruth(1,:),t0,3000,fs,Wshift); 
 
 
% figure
% % subplot(2,2,1)
% plot(t,data.data(1,:));
% xlim([0, 13]);
% 
% output.testfunc = [zeros(1, (output.paramcombo(1)*fs)) output.testfunc(1:(end-Wsize))];
% output.bin1 = [zeros(1, (output.paramcombo(1)*fs)) output.bin1(1:(end-Wsize))];
% output.binop = [zeros(1, (output.paramcombo(1)*fs)) output.binop(1:(end-Wsize))];





fig1 = figure;
rectangle('Position', [0,-3,3,7], 'FaceColor',[1 1 0.9],'EdgeColor',[0.9 0.9 0.9])
rectangle('Position', [3,-3,8,7], 'FaceColor',[1 0.93 0.9], 'EdgeColor',[0.9 0.9 0.9])
rectangle('Position', [8,-3,13,7], 'FaceColor',[0.90 1 0.9], 'EdgeColor',[0.9 0.9 0.9])
set(gca, "Layer", "top")
hold on;  
% subplot(2,1,1)
% plot(t,output.emgrect,'y')
% hold on
lh = plot(t,output.emgbpf);
lh.Color = [0, 0, 1, 0.15];

hold on
p1=plot(t(1:Wshift:end),output.testfunc(1:Wshift:end), 'Color', [0.8, 0, 0], 'LineWidth', 1.25);
hold on;
p2=plot(t(1:3000),repmat(output.mean_baseline,1,3000),'Color',[0.5 0.17 0.5],'LineWidth', 1);
%  yline(output.mean_baseline,'Color',[0.5 0.17 0.5],'LineWidth', 1);
hold on
p3=yline(output.h,'LineWidth', 1,'Color',[0 0.6 0]);
hold on
p4=xline(output.t0cap,'LineWidth', 1);
hold on
p5=xline(output.dataparams.t0,'Color', [1, 0, 0],'LineWidth', 1);
hold on
p6=stairs(t(1:Wshift:end),output.binop,'Color',[0 0 0],'LineWidth', 0.75);
% hold on
% p7 = stairs(t,output.bin1(Wsize+1:end),'r','LineWidth', 0.75)
xlim([0, 13]);
ylim([-0.1, 3.5]);
l= legend([lh,p1,p2,p3,p6],'Rectfied EMG ($|x[n]|$)','Low pass filtered EMG ($g[n]$)','$Mean_{baseline}$ ($\mu_{g}$)','Threshold (h)','Output(y[n])')
set(legend,'Position',[0.23 0.943149041196467 0.577300633986791 0.0414029670424614],'Orientation','horizontal',...
    'Interpreter','latex','FontSize',13.2,'EdgeColor',[1 1 1]);
xlabel('Time (s)');
ylabel('Amplitude')
set(gca,"FontSize",15)
set(gca, "LineWidth",1.1)
annotation(fig1,'textbox',...
    [0.131458365271729 0.86 0.474000000000002 0.068],...
    'String','                                                            REST',...
    'LineWidth',1,...
    'LineStyle','--',...
    'FontWeight','bold',...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor',[0.150 0.150 0.150]);
annotation(fig1,'textbox',...
    [0.606304215833795 0.86 0.299162904886355 0.068],...
    'String','                                        MOVE',...
    'LineWidth',1,...
    'LineStyle','--',...
    'FontWeight','bold',...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor',[0.150 0.150 0.150]);

set(gcf,'Position',[1 218.3333 1.2627e+03 421.3333]);
annotation('doublearrow',[0.133007284079084 0.307492195629552],[0.83 0.83]);
% annotation(fig1,'doublearrow',[0.1296875 0.309375],...
%     [0.76 0.76]);
% annotation(fig1,'doublearrow',[0.130729166666667 0.60625],...
%     [0.857908341915551 0.857908341915551]);
% annotation(fig1,'doublearrow',[0.6125 0.904166666666667],...
%     [0.857908341915551 0.857908341915551]);
%% text for the plots
txt = {strcat('r_{FP} = ',num2str(rFP))};
text(4.5,2.5,txt,'FontSize',18)
txt1 = {strcat('r_{FN} = ',num2str(rFN))};
text(10,2.5,txt1,'FontSize',18)
text(1,2.8,'Baseline','FontSize',18)
% text(4,2.85,'Rest','FontSize',15)
% text(10,2.85,'Move','FontSize',15)
text(8,2,'\rightarrow','HorizontalAlignment','right','FontSize',18)
text(output.t0cap,2,'\leftarrow','FontSize',18)
text(8.1,2.1,strcat('${\nabla}t = $',num2str((output.t0cap-(t0/fs)))),'Interpreter','Latex','FontSize',15)
text(8.1,2.4,strcat('$f_{{\nabla}t} = $',num2str(f_delT)),'Interpreter','Latex','FontSize',15)
%%

% set(gca,'Color',[1 0.9 1])
% subplot(2,1,2)
% plot(t,output2.testfunc)
% hold on
% yline(output2.mean_baseline)
% hold on
% yline(output2.mean_baseline+output.stdv_baseline,'r')
% hold on
% yline(output2.thresh,'m--')
% hold on
% xline(output2.t0cap)
% hold on
% xline(output2.dataparams.t0,'r--')
% xlim([0, 13]);
% % legend('EMG_lpf','mean','mean+stdv','threshold','t0cap','t0')
% % % subplot(3,1,3)
% % figure
% % plot(t,output3.emglpf)
% % hold on
% % yline(output3.mean_baseline)
% % % hold on
% % % yline(output3.mean_baseline+output.stdv_baseline,'r')
% hold on
% yline(output3.h,'m--')
% hold on
% xline(output3.t0cap)
% hold on
% xline(output3.dataparams.t0,'r--')
% xlim([0, 13]);
% legend('EMG_lpf','mean','mean+stdv','threshold','t0cap','t0')
% yline(output.mean_baseline)
% hold on
% plot(t,output.movAvg)
% hold on
% plot(t,output.testfunc,'m')
% xlim([0, 13]);
% legend('mean','movAvg','testfunc')
% figure
% subplot(2,1,1)
% plot(t,output.binop,'b')
% xlim([0, 13]);
% hold on
% xline(output.t0cap)
% hold on
% xline(output.dataparams.t0,'r--')
% % legend('binop','t0cap','Actual Onset');
% ylim([-0.1, 1.1])
% xlim([0, 13]);
% subplot(2,1,2)
% plot(t,groundtruth-output.binop)
% xlim([0, 13]);
% %legend('EMG_rect','EMG_lpf','mean','mean+stdv','threshold','movAvg','testfunc','binop','t0cap','Actual Onset')

                                  
                                  