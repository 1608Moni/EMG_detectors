clc
clear all
close all

folderPath = 'F:\StrokeData\Data\';
addpath('..\library\');
Detectors = ["EMGdetector","hodges","modifiedhodges","AGLRstep","AGLRstepLaplace","FuzzyEnt","lidierth","modifiedlidierth"];
mode = ["pulse",""];
plotflag = 0;
data = [];
%% 
for m = 1:length(mode)
    for j = 1:length(Detectors)
        finalfilename = fullfile(folderPath , strcat('Output',mode{m},Detectors{j},'.mat'));
        EMGdata = load(finalfilename);
        %%
        fs = str2num(EMGdata.params.prm.SamplingRate.Value{1});

        tB = 1000;
        %%
        tr = 1;
        for i = 1:size(EMGdata.output,1)
            for k = 1:size(EMGdata.output,2)

                if (isempty(EMGdata.output{i,k}) == 0)  
                    if (string(Detectors{j}) == "EMGdetector")
                        Wshift = EMGdata.output{i,k}.paramcombo(3);
                    else
                        Wshift = 1;   
                    end
                    dur = length(EMGdata.output{i,k}.binop);
                    [Latencyparams] = LatencyBurst2(EMGdata.groundtruth{i,1}(1:Wshift:end,k)',...
                        EMGdata.output{i,k}.binop,(dur/fs),fs,Wshift);  
                    if (string(Detectors{j}) == "EMGdetector")
                         [rFP,rFN]= crosscorrcompute(EMGdata.groundtruth{i,1}(tB:Wshift:end,k)',EMGdata.output{i,k}.binop((tB/Wshift):end-1)); 
                    else
                         [rFP,rFN]= crosscorrcompute(EMGdata.groundtruth{i,1}(tB:Wshift:end,k)',EMGdata.output{i,k}.binop((tB/Wshift):end));    
                    end 


                    %% Compute Cost
                    CF(tr) = max([Latencyparams.f_delT_Off,  Latencyparams.f_delT_ON ,rFP ,rFN]); %min(10*rFP(q,p),1) ,min(10*rFN(q,p),1) Computing the infinity norm     
                    f_delT_off(tr) =  Latencyparams.f_delT_Off;
                    f_delT_ON(tr)  =  Latencyparams.f_delT_ON;
                    Avg_Latency_ON(tr)  = Latencyparams.Avg_Latency_ON;
                    Avg_Latency_off(tr) = Latencyparams.Avg_Latency_Off;


                    %% Plot the results to verfiy
                    if (plotflag == 1)
                        gcf = figure(tr);
                        gcf.Position = [1 121 1.2733e+03 520];
                        p1 = plot(EMGdata.data{i,1}(1:Wshift:end,k), 'Color', [0.8 0.85 1], 'LineWidth',1);
                        hold on
                        p2 = plot(EMGdata.output{i,k}.testfunc(1:Wshift:end), 'Color', [0.6 0 0.2], 'LineWidth',1);
                        hold on
                        p3 = yline(EMGdata.output{i,k}.h,'r--');
                        hold on
                        p4 = stairs(max(EMGdata.output{i,k}.testfunc)*EMGdata.groundtruth{i,1}(1:Wshift:end,k)','k','LineWidth',1.5);
                        hold on
                        p5 = stairs(max(EMGdata.output{i,k}.testfunc)*EMGdata.output{i,k}.binop,'r');
                        if (sum(isnan(Latencyparams.t0cap_On)) == 0) && (isempty(find(Latencyparams.t0cap_On == 0)) == 1)
                            hold on                   
                            p6 = stem(Latencyparams.t0cap_On,EMGdata.output{i,k}.binop(Latencyparams.t0cap_On),'filled','Color',[0 0.6 0.2],'LineWidth',1);
                        end
                        if (sum(isnan(Latencyparams.t0cap_off)) == 0) && (isempty(find(Latencyparams.t0cap_off == 0)) == 1)
                            hold on
                            p7 = stem(Latencyparams.t0cap_off,EMGdata.output{i,k}.binop(Latencyparams.t0cap_off),'filled','b','LineWidth',1);
                        end
                        l1 = legend([p1,p2,p3,p4,p5],'RawEMG','testfunc','threshold','GT','Binop');
                        l1.Box = 'off';
                        l1.Location = 'southeast';
        %                     hold on
        %                     stem(Latencyparams{q,p}.lEdge_GT,groundtruth(p,Latencyparams{q,p}.lEdge_GT),'k');
        %                     hold on
        %                     stem(Latencyparams{q,p}.tEdge_GT,groundtruth(p,Latencyparams{q,p}.tEdge_GT),'c');
        %                     ylim([-0.1 0.1])  
                            txt = {strcat('rFP = ',num2str(round(rFP,3)))};
                            text(4.5,double(max(EMGdata.data{i,1}(1:Wshift:end,k))/1),txt,'FontSize',12) 
                            txt1 = {strcat('rFN = ',num2str(round(rFN,3)))};
                            text(dur/2,double(max(EMGdata.data{i,1}(1:Wshift:end,k))/1),txt1,'FontSize',12) 
                            txt = {strcat('AvgLatencyOn = ',num2str(round(Latencyparams.f_delT_ON,3)))};
                            text(4.5,double(max(EMGdata.data{i,1}(1:Wshift:end,k))/1.2),txt,'FontSize',12) 
                            txt1 = {strcat('AvgLatencyOff = ',num2str(round(Latencyparams.f_delT_Off,3)))};
                            text(dur/2,double(max(EMGdata.data{i,1}(1:Wshift:end,k))/1.2),txt1,'FontSize',12)
                            txt1 = {strcat('Cost = ',num2str(CF(tr)))};
                            text(4.5,double(max(EMGdata.data{i,1}(1:Wshift:end,k))/4),txt1,'FontSize',12)   
                            title(strcat(Detectors{j},'_','Trial',num2str(tr),mode{m}),'Interpreter','none');
                            export_fig(char(strcat(Detectors{1},'_',mode{m})),'-pdf','-append',figure(tr));
                            close all
                    end

                        tr = tr+1;
                end
            end
        end

    %      %% Compute the median and IQR of the cost distribution of each parameter combination
    %              [Avg_CF, range_CF] =  medIqr(CF);
    %              mu = mean(CF);
    Cost(:,j) = CF;
    clear CF
    end
    data = [data Cost]; % Cost_SNR0, f_delToff_SNR0,  f_delTOn_SNR0,
% ylim([0 1])
end
    algorname = repmat(Detectors,1,2);
    costfactors = [repmat({'pulse'},1,length(Detectors)),repmat({'step'},1,length(Detectors))]; %repmat({'cost'},1,length(algoname)),repmat({'Off'},1,length(algoname)),repmat({'On'},1,length(algoname)),...
    boxplot(data,{algorname,costfactors},'colors',repmat('km',1,2),'factorgap',[7 1],'labelverbosity','minor');
% figure
% boxplot(Cost,'Label',Detectors);
% title(mode)