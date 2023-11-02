clc
clear all
close all

parentFolderPath = 'F:\StrokeData\Data\';
addpath 'D:\EMG detectors\detectors_review_paper'
% Get the list of contents in the parent folder
Filename = ["StrokeEMGdataLeft","StrokeEMGdata"];
filePath = fullfile(parentFolderPath, Filename(1));
EMGdata = load(filePath);
b=1;

EMGdata.data{2,1}(:,1:24) = EMGdata.data{1,1};
EMGdata.data{2,2}(:,1:24) = EMGdata.data{1,2};

for i = 17:size(EMGdata.data{2,1},2)

                        GTchannel1 = zeros(length(EMGdata.data{2,1}(:,i)),1);
                        GTchannel2 = zeros(length(EMGdata.data{2,2}(:,i)),1);
                        gcf = figure(b);
                        gcf.Position = [9.6667 173 1272 466.6667];
                        subplot(2,1,1)
                        plot(EMGdata.data{2,1}(:,i) );
                        hold on
                        xline(2001)
                        hold on
                        xline(3002,'r--')
                        hold on
                        xline(5501,'r--')
                        grid on
                        grid minor
                        subplot(2,1,2)
                        plot(EMGdata.data{2,2}(:,i) );
                       hold on
                        xline(2001)
                        hold on
                        xline(3002,'r--')
                        hold on
                        xline(5501,'r--')
                        grid on
                        grid minor
                       
                        
                        disp('Press the space bar to mark the trials...');
                        pause;
                        
    
                        % Check if the pressed key is the space bar (ASCII code: 32)
                        key = get(gcf, 'CurrentCharacter');
                        if double(key) == 32
                             subplot(2, 1, 1)
                            [x_markedChanel1, y_markedChannel1] = ginput;
                            for markind = 1:2:length(x_markedChanel1)
                                GTchannel1(x_markedChanel1(markind):x_markedChanel1(markind+1)) = 1;
                            end
                            hold on;
                            stairs(max(EMGdata.data{2,1}(:,i))*GTchannel1, 'r'); 
                            subplot(2, 1, 2); % Switch to Subplot 2
                            [x_markedChan2, y_markedChan2] = ginput;
                            for markind2 = 1:2:length(x_markedChan2)
                                GTchannel2(x_markedChan2(markind2):x_markedChan2(markind2+1)) = 1;
                            end
                            hold on;
                            stairs(max(EMGdata.data{2,2}(:,i))*GTchannel2, 'r'); 
                            name = 'FinalEMGdataGT';
                            export_fig(char(name),'-pdf','-append',figure(b));
                            b=b+1;
                            close all
                            GT{2,1}(:,i) = GTchannel1;
                            GT{2,2}(:,i) = GTchannel2;
           
                            EMGdata.groundtruth = GT;
                            finalfilename = fullfile(parentFolderPath , strcat('EMGdataGT1.mat'));
                            save(finalfilename,'-struct','EMGdata','-v7.3'); 
                      
                        else
                         b=b+1;
                         close all
                        end
                       
%                         save(filePath,'-struct','EMG','-v7.3'); 
%                     end
%                     clear EMGtrials;
end
%         