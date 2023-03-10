function plotfunc(Output,j,detector)
%% Function to plot internal variables of the detector

%% Initialise parameters
fs           = Output.dataparams.fs;
t            = (1/fs):(1/fs):Output.dataparams.dur;



figure(j)
if detector == "hodges" || detector == "lidierth" 
plot(t,Output.emgrect,'Color', [0.8 0.85 1]);
hold on
    if detector == "hodges"
    plot(t,Output.emglpf, 'Color', [0.6 0 0.2], 'LineWidth',1);
    hold on
    else
    plot(t,Output.movAvg, 'Color', [0.6 0 0.2], 'LineWidth',1);
    hold on    
    end
plot(t,Output.testfunc,'m','LineWidth',1.5)
hold on
plot(t,Output.binop,'Color', [0 0 0], 'LineWidth',1)
hold on
yline(Output.thresh,'r--')
hold on
xline(Output.t0cap,'r','LineWidth',1)
hold on
xline(Output.dataparams.t0,'g','LineWidth',1)
legend('emg_{rect}','emg_{lpf}','testfunc','binop','thrshold','Onset_{est}','Onset_{act}')
xlabel('Time (sec)')
ylabel('Amplitude')
title(detector)

    if detector == "lidierth"
        figure
        subplot(3,1,1)
        plot(t,Output.testfunc,'m','LineWidth',1.5)
        hold on
        stairs(t,Output.binop,'Color', [0 0 0], 'LineWidth',1)
        hold on
        yline(Output.thresh,'r--')
        legend('testfunc','binop','threshold')
        subplot(3,1,2)
        plot(t,Output.bin1,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])
        subplot(3,1,3)
        plot(t,Output.bin2,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])
    end
end

if detector == "modifiedhodges" || detector == "modifiedLidierth"
plot(t,Output.emgrect,'Color', [0.8 0.85 1]);
hold on
plot(t,Output.testfunc, 'Color', [0.6 0 0.2], 'LineWidth',1);
hold on
plot(t,Output.binop,'Color', [0 0 0], 'LineWidth',1)
hold on
yline(Output.h,'r--')
hold on
xline(Output.t0cap,'r','LineWidth',1)
hold on
xline(Output.dataparams.t0,'g','LineWidth',1)
legend('emg_{rect}','emg_{lpf}','binop','thrshold','Onset_{est}','Onset_{act}')
xlabel('Time (sec)')
ylabel('Amplitude')
title(detector)

 if detector == "modifiedLidierth"
        figure
        subplot(3,1,1)
        plot(t,Output.testfunc,'m','LineWidth',1.5)
        hold on
        stairs(t,Output.binop,'Color', [0 0 0], 'LineWidth',1)
        hold on
        yline(Output.h,'r--')
        legend('testfunc','binop','threshold')
        subplot(3,1,2)
        plot(t,Output.bin1,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])
        subplot(3,1,3)
        plot(t,Output.bin2,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])
    end
end

if detector == "AGLRstep" || detector == "AGLRstepLaplace"
plot(t,Output.signcond,'Color', [0.8 0.85 1]);
hold on
plot(t,Output.testfunc, 'Color', [0.6 0 0.2], 'LineWidth',1);
hold on
plot(t,Output.binop,'Color', [0 0 0], 'LineWidth',1)
hold on
yline(Output.h,'r--')
hold on
xline(Output.t0cap,'r','LineWidth',1)
hold on
xline(Output.dataparams.t0,'g','LineWidth',1)
legend('emg_{whitened}','testfunc','binop','thrshold','Onset_{est}','Onset_{act}')
xlabel('Time (sec)')
ylabel('Amplitude')
title(detector)

end

if detector == "FuzzyEnt" || detector == "SampEnt" || detector == "CWT"
subplot(2,1,1)
plot(t,Output.testfunc,'Color', [0.6 0 0.2]);
hold on
yline(Output.h,'r--')
subplot(2,1,2)
plot(t,Output.binop,'Color', [0 0 0], 'LineWidth',0.5)
hold on
xline(Output.t0cap,'r','LineWidth',1)
ylim([-0.1 1.1])
hold on
xline(Output.dataparams.t0,'g','LineWidth',1)
legend('testfunc','binop','thrshold','Onset_{est}','Onset_{act}')
xlabel('Time (sec)')
ylabel('Amplitude')
title(detector)

end


if detector == "TKEO" 
plot(t,Output.EMGhpf,'Color', [0.8 0.85 1])
hold on    
plot(t,Output.TKEO,'m');
hold on
plot(t,Output.testfunc,'Color', [0.6 0 0.2], 'LineWidth',1);
hold on
plot(t,Output.binop,'Color', [0 0 0], 'LineWidth',0.5)
hold on
yline(Output.h,'r--')
hold on
xline(Output.t0cap,'r','LineWidth',1)
hold on
xline(Output.dataparams.t0,'g','LineWidth',1)
legend('EMGhpf','TKEO','testfunc','binop','thrshold','Onset_{est}','Onset_{act}')
xlabel('Time (sec)')
ylabel('Amplitude')
title(detector)

figure
        subplot(3,1,1)
        plot(t,Output.testfunc,'m','LineWidth',1.5)
        hold on
        stairs(t,Output.binop,'Color', [0 0 0], 'LineWidth',1)
        hold on
        yline(Output.h,'r--')
        legend('testfunc','binop','threshold')
        subplot(3,1,2)
        plot(t,Output.bin1,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])
        subplot(3,1,3)
        plot(t,Output.bin2,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])

end

if detector ==  "bonato"
    
t1           = (2/fs):(2/fs):Output.dataparams.dur;    
plot(t,Output.signcond,'Color', [0.8 0.85 1]);
hold on
plot(t1,Output.testfunc, 'y');
hold on
stairs(t1,Output.binop,'Color', [0 0 0], 'LineWidth',1)
hold on
yline(Output.h,'r--')
hold on
xline(Output.t0cap,'r','LineWidth',1)
hold on
xline(Output.dataparams.t0,'g','LineWidth',1)
legend('emg_{whitened}','testfunc','binop','thrshold','Onset_{est}','Onset_{act}')
xlabel('Time (sec)')
ylabel('Amplitude')
title(detector)
        
        figure
        subplot(3,1,1)
        plot(t1,Output.testfunc,'m','LineWidth',1.5)
        hold on
        stairs(t1,Output.binop,'Color', [0 0 0], 'LineWidth',1)
        hold on
        yline(Output.h,'r--')
        legend('testfunc','binop','threshold')
        subplot(3,1,2)
        plot(t1,Output.bin1,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])
        subplot(3,1,3)
        plot(t1,Output.bin2,'Color', [0 0 0], 'LineWidth',1)
        ylim([-0.1 1.1])


end

if detector == "SSA"
subplot(2,1,1)
plot(Output.Dn)
hold on
xline(Output.t0cap,'r--')
hold on
xline(Output.dataparams.t0)
title('Dn statistics')
subplot(2,1,2)
plot(Output.cumStats)
hold on
plot(Output.peaks,Output.cumStats(Output.peaks),'*')
hold on
xline(Output.t0cap*1000,'r--');
hold on
xline(Output.dataparams.t0*1000)
legend('cumsum stats','peaks in move phase','estimated onset','original onset')
xlabel('Time (ms)')
title('CUMSUM statistics')
end

if detector == "Detector2018"
 p = Output.paramcombo(3);
 subplot(2,1,1)
 plot(t,Output.emgbpf,'Color',[0.8 0.85 1]);
 hold on
 plot(t(1:p:end),Output.testfunc(1:p:end),'Color',[0 0 1 0.4]);
 hold on;
 yline(Output.h);
 hold on
 stem(t(1:p:end),(Output.bin1)/2,'LineWidth',1.25,'Color',[0 0 0]);
 ylim([-0.1 1.1])
 subplot(2,1,2)
 stem(t(1:p:end),(Output.binop),'LineWidth',1.25);
 hold on
 xline(Output.t0cap)
 ylim([-0.1 1.1])


end

end