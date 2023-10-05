clc
clear all
close all

folderPath = 'F:\StrokeData\Data\';
addpath('F:\StrokeData');

%% Read the real EMG data file
filePath = fullfile(folderPath, 'Finaldata.mat');
EMGdata = load(filePath);


b=1;
 for j = 1:size(EMGdata.data,1)
    %% Add trials of both channels into single cell array
    EMGdata.data{j,1} = [EMGdata.data{j,1} EMGdata.data{j,2}]; 
  tr = 1;  
    for k = 1:size(EMGdata.data{j,1},2)
    
         DATA{j,1}(:,tr) = EMGdata.data{j,1}(:,k);
         gcf = figure(b);
         gcf.Position = [-23 231.6667 746.6667 275.3333];
         plot(EMGdata.data{j,1}(:,k));
         hold on
         xline(2001,'k');
         hold on
         xline(3002,'r');
         hold on
         xline(length(EMGdata.data{j,1}(:,k)),'r--');
         title(strcat('Trial_',num2str(tr)),'Interpreter','none');
         disp('Press the space bar to choose the trial...');
         pause;
         % Check if the pressed key is the space bar (ASCII code: 32)
         key = get(gcf, 'CurrentCharacter');
         if double(key) == 32
            [x_marked, y_marked] = ginput;
            GT{j,1}(:,tr) = GetGT(x_marked, length(EMGdata.data{j,1}(:,k)));           
            hold on;
            stairs(max(EMGdata.data{j,1}(:,k))*GT{j,1}(:,tr), 'r','LineWidth',1.5); 
             %% Save the trials as PDF 
    
             export_fig('EMGdata_v1','-pdf','-append',figure(b));
             close all
             finalEMGdata.data = DATA;
             finalEMGdata.groundtruth = GT;
             finalEMGdata.params = EMGdata.params;
             finalfilename = fullfile(folderPath , strcat('EMGdata_v1'));
             save(finalfilename,'-struct','finalEMGdata','-v7.3'); 
             b = b+1;
             tr = tr + 1;
         else
             b = b + 1;
             close all
         end
         
   
    end 
 end

  %% Save the trials as .mat file
  
    
                       