clc
clear all
close all

folderPath = 'F:\StrokeData\Data\output\';
addpath('..\library\');
Detectors = ["modifiedlidierth","modifiedhodges","FuzzyEnt","AGLRstep","AGLRstepLaplace","lidierth","EMGdetector","hodges"];
mode = ["pulse",""];
plotflag = 0;
data = [];

%% 
for j = 1:length(Detectors)
    data1 = [];
    for m = 1:length(mode)
    
        finalfilename = fullfile(folderPath , strcat('Output',mode{m},Detectors{j},'.mat'));
        EMGdata = load(finalfilename);
%         EMGdata.data{3,2} = EMGdata.data{3,2}(:,1:6);
        %%
       
        %%
        fs = str2num(EMGdata.params.prm.SamplingRate.Value{1});

        tB = 1000;
        %%
        tr = 1;
        for i = 1:size(EMGdata.output,1)                
            for k = 1:size(EMGdata.data{i,1},2)-1

                if (isempty(EMGdata.output{i,k}) == 0)  
                    if (string(Detectors{j}) == "EMGdetector")
                        Wshift = EMGdata.output{i,k}.paramcombo(3);
                    else
                        Wshift = 1;   
                    end
                    dur = length(EMGdata.output{i,k}.binop);
                    [Latencyparams] = LatencyBurst3(EMGdata.groundtruth{i,1}(1:Wshift:end,k)',...
                        EMGdata.output{i,k}.binop,(dur/fs),fs,Wshift);  
                    if (string(Detectors{j}) == "EMGdetector")
                         [rFP(tr),rFN(tr)]= crosscorrcompute(EMGdata.groundtruth{i,1}(tB:Wshift:end,k)',EMGdata.output{i,k}.binop((tB/Wshift):end-1)); 
                    else
                         [rFP(tr),rFN(tr)]= crosscorrcompute(EMGdata.groundtruth{i,1}(tB:Wshift:end,k)',EMGdata.output{i,k}.binop((tB/Wshift):end));    
                    end 


                    %% Compute Cost
                    CF(tr) = max([Latencyparams.f_delT_Off,  Latencyparams.f_delT_ON ,rFP(tr) ,rFN(tr)]); %min(10*rFP(q,p),1) ,min(10*rFN(q,p),1) Computing the infinity norm     
                    f_delT_off(tr) =  Latencyparams.f_delT_Off;
                    f_delT_ON(tr)  =  Latencyparams.f_delT_ON;
                    Avg_Latency_ON(tr)  = Latencyparams.Avg_Latency_ON;
                    Avg_Latency_off(tr) = Latencyparams.Avg_Latency_Off;


                    %% Plot the results to verfiy
                    if (plotflag == 1)
                        gcf = figure(tr);
                        gcf.Position = [1 121 1.2733e+03 520];
                        p1 = plot(EMGdata.data{i,2}(1:Wshift:end,k), 'Color', [0.8 0.85 1],'LineWidth',1); %'Color', [0.8 0.85 1]
                        hold on
                        p2 = xline(2001,'k');
                        hold on
                        p3 = xline(3002,'r--');
                        hold on
                        p4 = xline(dur,'r');
                        hold on
                        p2 = plot(EMGdata.output{i,k}.emglpf(1:Wshift:end), 'Color', [0.6 0 0.2], 'LineWidth',1);
                        hold on
                        p3 = yline(EMGdata.output{i,k}.h,'r--');
                         hold on
                         p5 = stairs(max(EMGdata.output{i,k}.emglpf)*EMGdata.groundtruth{i,2}(1:Wshift:end,k)','k','LineWidth',1.5);
                        hold on
                        p5 = stairs(max(EMGdata.output{i,k}.emglpf)*EMGdata.output{i,k}.binop,'r');
                        newlaton  = Latencyparams.t0cap_On(~(Latencyparams.t0cap_On == 0 | isnan(Latencyparams.t0cap_On)));
                        %if (sum(isnan(Latencyparams.t0cap_On)) == 0) && (isempty(find(Latencyparams.t0cap_On == 0)) == 1)
                        hold on                   
                        p6 = stem(newlaton,EMGdata.output{i,k}.binop(newlaton),'filled','Color',[0 0.6 0.2],'LineWidth',1);
                        
                        %end
                        %if (sum(isnan(Latencyparams.t0cap_off)) == 0) && (isempty(find(Latencyparams.t0cap_off == 0)) == 1)
                        newlatoff  = Latencyparams.t0cap_off(~(Latencyparams.t0cap_off == 0 | isnan(Latencyparams.t0cap_off)));
                        hold on
                        p7 = stem(newlatoff ,EMGdata.output{i,k}.binop( newlatoff ),'filled','b','LineWidth',1);
                        %end
                        l1 = legend([p1,p2,p3,p4,p5],'RawEMG','emglpf','threshold','GT','Binop');
                        l1.Box = 'off';
                        l1.Location = 'southeast';
        %                     hold on
        %                     stem(Latencyparams{q,p}.lEdge_GT,groundtruth(p,Latencyparams{q,p}.lEdge_GT),'k');
        %                     hold on
        %                     stem(Latencyparams{q,p}.tEdge_GT,groundtruth(p,Latencyparams{q,p}.tEdge_GT),'c');
        %                     ylim([-0.1 0.1])  
                            txt = {strcat('rFP = ',num2str(round(rFP(tr),3)))};
                            text(4.5,double(max(EMGdata.data{i,2}(1:Wshift:end,k))/1),txt,'FontSize',12) 
                            txt1 = {strcat('rFN = ',num2str(round(rFN(tr),3)))};
                            text(dur/2,double(max(EMGdata.data{i,2}(1:Wshift:end,k))/1),txt1,'FontSize',12) 
                            txt = {strcat('AvgLatencyOn = ',num2str(round(Latencyparams.f_delT_ON,3)))};
                            text(4.5,double(max(EMGdata.data{i,2}(1:Wshift:end,k))/1.2),txt,'FontSize',12) 
                            txt1 = {strcat('AvgLatencyOff = ',num2str(round(Latencyparams.f_delT_Off,3)))};
                            text(dur/2,double(max(EMGdata.data{i,2}(1:Wshift:end,k))/1.2),txt1,'FontSize',12)
                            txt1 = {strcat('Cost = ',num2str(CF(tr)))};
                            text(4.5,double(max(EMGdata.data{i,2}(1:Wshift:end,k))/4),txt1,'FontSize',12)   
                            title(strcat(Detectors{j},'_','Trial',num2str(tr),mode{m}),'Interpreter','none');
                            export_fig(char(strcat('recent',Detectors{1},'_',mode{m})),'-pdf','-append',figure(tr));
                            
%                               export_fig('EMGrawdataGTmarking','-pdf','-append',figure(tr));
%                             pause(2)
                            close all
                    end

                        tr = tr+1;
                end
            end
        end

    %      %% Compute the median and IQR of the cost distribution of each parameter combination
    %              [Avg_CF, range_CF] =  medIqr(CF);
    %              mu = mean(CF);
%     Cost(:,(2*j-1)+(m-1)) = CF;
%     FPR(:,(2*j-1)+(m-1)) = rFP;
%     FNR(:,(2*j-1)+(m-1)) = rFN;
%     lat_off(:,(2*j-1)+(m-1)) = f_delT_off;
%     lat_on(:,(2*j-1)+(m-1)) = f_delT_ON;
      data = [rFP', rFN', f_delT_off',f_delT_ON', CF'];
      data1 = [data1 data];
    %clear CF
    end
%     data = [data Cost]; % Cost_SNR0, f_delToff_SNR0,  f_delTOn_SNR
    %%
   
    
    %%
    figure(1)
    subplot(2,4,j)
    factors = ["FPR","FNR","lat_off","lat_on", "cost"];
%     data1 = [FPR, FNR,  lat_off, lat_on]; % Cost_SNR0, f_delToff_SNR0,  f_delTOn_SNR0,
    algorname = repmat(factors,1,2);
    costfactors = [repmat({'P'},1,length(factors)),repmat({'S'},1,length(factors))]; %repmat({'cost'},1,length(algoname)),repmat({'Off'},1,length(algoname)),repmat({'On'},1,length(algoname)),...
    boxplot(data1,{algorname,costfactors},'colors',repmat('km',1,2),'factorgap',[7 1],'labelverbosity','minor','BoxStyle','filled');
    title(Detectors{j})
    ylim([0 1])
%     clear data
%     clear data1
%     title(mode)
end
%     figure 
%     algorname = repmat(Detectors,1,2);
%     costfactors = [repmat({'pulse'},1,length(Detectors)),repmat({'step'},1,length(Detectors))]; %repmat({'cost'},1,length(algoname)),repmat({'Off'},1,length(algoname)),repmat({'On'},1,length(algoname)),...
%     boxplot(data,{algorname,costfactors},'colors',repmat('km',1,2),'factorgap',[7 1],'labelverbosity','minor');
% 
%   
%     
%     % % ylim([0 1])
%     % figure
%     % boxplot(Cost,'Label',Detectors);
% title(mode)