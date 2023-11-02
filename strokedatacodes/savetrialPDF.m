clc
clear all
close all

parentFolderPath = 'F:\StrokeData\Data\';
addpath 'D:\EMG detectors\detectors_review_paper'
 addpath 'F:'
DatafolderPath = 'F:\StrokeData\NewData\';
NewDatafolder = 'F:\StrokeData\NewData\';
% Get the list of contents in the parent folder
contents = dir(parentFolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

  %% Notch filter
% fs = 500;
% fo = 50/(fs/2);  
% bw = fo/35;
% [b1,a1] = iirnotch(fo,bw);

fs = 500;
fo = 50;
q = 35;
bw = (fo/(fs/2))/q;
[b1,a1] = iircomb(fs/fo,bw,'notch'); % Note type flag 'notch'

%   %% High Pass filter
%     fc = 10;
%     [b2,a2]   = butter(2,fc/(fs/2),'high');
   


                %%

result = yaml.loadFile("subjects_data_v200504.yaml");
subjectname = getname(result);
for l = 4:length(subfolders)
    b=1;
    %% To know the lession location 
    index = find(string(subfolders(l).name) == subjectname);
    lesionloc = result.subjects{index}.lesion.location;
    if lesionloc == "L"
        plotindex1 = 1; %choose_no_randomly(0.5,1,2);       
    else
        plotindex1 = 5; %choose_no_randomly(0.5,5,6); 
    end
    disp(strcat("lesion location : ", lesionloc))
    %%
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(parentFolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));
    
    
    %%
    for m = 1:length(sessionfolders)   
         %% skip the session if not suitable
%          while true             key1 = waitforbuttonpress;  % Wait for a keypress
%             if key1 == 1
%                 char = get(gcf, 'CurrentCharacter'); 
%              
%                 if double(char) == 115  
%                     continue;
%                 end
%             end
        
        
        trial = 1;     
         %% Create a folder to save the trials
        fullFolderPath = fullfile(DatafolderPath,PatientfolderName,sessionfolders(m).name);
        NewFolderPath = fullfile(NewDatafolder,PatientfolderName,sessionfolders(m).name);
        % Check if the folder exists
        if exist( NewFolderPath, 'dir') == 7
        % If the folder exists, open it
            fprintf('Folder "%s" already exists.\n', sessionfolders(m).name);
        else
        % If the folder doesn't exist, create it and then open it
            mkdir( NewFolderPath);
            fprintf('Folder "%s" created\n', sessionfolders(m).name);
        end
        files2 = dir(fullfile(fullFolderPath, '*.mat')); 
         if isempty(files2) == 1
            %% Reading the DAT file
            folderPath = fullfile(parentFolderPath,  PatientfolderName, sessionfolders(m).name );
            files = dir(fullfile(folderPath, '*.mat'));   
            usedRuns = zeros(1,numel(files));
            RepetedRuns_ = zeros(1,numel(files));
           
             %for j = 1:numel(files)
             while trial <= 5 && any(usedRuns == 0)
                Run_ = randi([1 numel(files)]);
                RepetedRuns_(Run_) =  RepetedRuns_(Run_) + 1;
                filePath = fullfile(folderPath, files(Run_).name);
                [~, Run_ID,~] = fileparts(filePath);
                EMGdata = load(filePath);
                
                %% Merge two channel into one cell
                EMGdata.data{1,1} = [EMGdata.data{1,1} EMGdata.data{1,2}];
                EMGdata.data{1,5} = [EMGdata.data{1,5} EMGdata.data{1,6}];
                %%
                rawdata = EMGdata.data;
                %%

    %             while any(usedRuns == 0)
                     % Specify the range of random numbers
                        rangeStart = 1;
                        rangeEnd = size(rawdata{1,plotindex1},2) ;
                        % Calculate the total number of possible values
                        totalValues = rangeEnd - rangeStart + 1;
                    if any(RepetedRuns_(Run_) > 1)
                       if any(usedNumbers{1,Run_} == 0)
                        [usedNumbers{1,Run_}, Tr_] =  RandNumWRep(rangeStart,rangeEnd,usedNumbers{1,Run_});
                       else
                        usedRuns(Run_) = 1;  
                        disp(strcat('All trials in the run',num2str(Run_),'are screened'));
                       end

                    else
                        % Initialize an array to keep track of used numbers
                        usedNumbers{1,Run_} = zeros(1, totalValues);
                         if any(usedNumbers{1,Run_} == 0)
                            [usedNumbers{1,Run_}, Tr_] =  RandNumWRep(rangeStart,rangeEnd,usedNumbers{1,Run_});
                         else
                             usedRuns(Run_) = 1;
                             disp(strcat('All trials in the run',num2str(Run_),'are screened'));
                         end
                    end          
    %             end
                %%
              
                EMGfilterdata = filter(b1,a1,rawdata{1,plotindex1}(:,Tr_));
%                 EMGfilterdata = filter(b2,a2,EMGnotch);
                %% plot the freqspectrum 
                freqspectrumplot(rawdata{1,plotindex1}(:,Tr_),EMGfilterdata,fs);
%                 pause(2)
%                 close all
                
                %%
                    %for i = 1:size(rawdata{1,plotindex1},2)                       
                             gcf = figure;
                             gcf.Position = [9.6667 173 1272 466.6667];
                             subplot(2,1,1)
                             plot(EMGfilterdata );
                             title('notch filtered')
                             subplot(2,1,2)
                             plot(rawdata{1,plotindex1}(:,Tr_))
                             title('rawdata')
                             hold on
                             xline(2001)
                             hold on
                             xline(3002,'r--')
                             hold on
                             xline(length(rawdata{1,plotindex1}(:,Tr_)),'r')
                             disp(strcat('Run number : ', num2str(Run_),'TrialNum: ', num2str(Tr_)))
                             Name_ = strcat('Session', num2str(m),'_',Run_ID,'_Trial',num2str(Tr_));
                             title(Name_,'Interpreter','none');
                             xlabel('Sample Number')

                             %% Identify Channel
                             if lesionloc == "L"
                                if Tr_ > 10
                                    ChannelNo = 2;
                                else
                                    ChannelNo = 1;
                                end
                             else
                                 if Tr_ > 10
                                    ChannelNo = 6;
                                else
                                    ChannelNo = 5;
                                 end
                             end

                             %% Choose the trial
                             disp('Press the space bar to choose the trial...');
                             pause;
                             key = get(gcf, 'CurrentCharacter');
                             if double(key) == 32          
                                finalEMGdata{1,trial}.data = rawdata{1,plotindex1}(:,Tr_);
                                finalEMGdata{1,trial}.filteredData = EMGfilterdata;
                                finalEMGdata{1,trial}.channel = ChannelNo;
                                finalEMGdata{1,trial}.trial = Tr_;
                                finalEMGdata{1,trial}.Run = Run_;
                                finalEMGdata{1,trial}.file = Run_ID;
                                finalEMGdata{1,trial}.lessionloc = lesionloc;
                                finalEMGdata{1,trial}.session = m;
                                finalEMGdata{1,trial}.Orgparms = EMGdata.OrgParams;
                                finalEMGdata{2,1}.usedRuns = usedRuns;
                                finalEMGdata{3,1}.usedNumbers = usedNumbers;
                                finalfilename = fullfile( NewFolderPath , strcat(sessionfolders(m).name,'.mat'));
                                save(finalfilename,'finalEMGdata');  
                                trial = trial + 1;
%                                 b = b + 1;
                                close all
                                clear EMGfilterdata;
                             else
%                                  b = b+1;
                                 close all                                                 
                             end
                            
    %                         grid on
    %                         grid minor
    %                         xlabel('Time (ms)')
    %                         title('Channel 1')
    %                         subplot(2,1,2)
    %                         plot(rawdata{1,plotindex2}(:,i) );
    %                         hold on
    %                         xline(EMGdata.OrgParams.trial_rest_start(i)-EMGdata.OrgParams.trial_rest_start(i))
    %                         hold on
    %                         xline(EMGdata.OrgParams.trial_rest_end(i)-EMGdata.OrgParams.trial_rest_start(i))
    %                         hold on
    %                         xline(EMGdata.OrgParams.trial_mov_start(i)-EMGdata.OrgParams.trial_rest_start(i),'r--')
    %                         hold on
    %                         xline(EMGdata.OrgParams.trial_mov_end(i)-EMGdata.OrgParams.trial_rest_start(i),'r--')
    %                         grid on
    %                         grid minor
    %                         xlabel('Time (ms)')
    %                         title('Channel 2') 
    %                         sgtitle(strcat('Session',num2str(1),'_',files(j).name,'_','Trial',num2str(i)),'Interpreter','none');
    %                         
    %                         %% Mark the trials
    %                         disp('Press the space bar to choose the trial...');
    %                         pause;
    %                       
    %     
    %                         % Check if the pressed key is the space bar (ASCII code: 32)
    %                         key = get(gcf, 'CurrentCharacter');
    %                         if double(key) == 32
    % %                              subplot(2, 1, 1)
    % %                             [x_markedChanel1, y_markedChannel1] = ginput;
    % %                             GTchannel1 = GetGT(x_markedChanel1, length(rawdata{1,plotindex1}(:,i)));
    % %                             hold on;
    % %                             stairs(max(rawdata{1,plotindex1}(:,i))*GTchannel1, 'r','LineWidth',1.5); 
    % %                            
    % %                             subplot(2, 1, 2); % Switch to Subplot 2
    % %                             [x_markedChan2, y_markedChan2] = ginput;
    % %                             GTchannel2 = GetGT(x_markedChan2, length(rawdata{1,plotindex2}(:,i)));
    % %                             hold on;
    % %                             stairs(max(rawdata{1,plotindex2}(:,i))*GTchannel2, 'r','LineWidth',1.5); 
    %                             
    %                             %% Saving the datafile as PDF
    %                             name = 'EMGdata';
    %                             export_fig(char(name),'-pdf','-append',figure(b));
    %                             b=b+1;
    %                             close all
    %                              GT{l,1}(:,tr) = GTchannel1;
    %                              GT{l,2}(:,tr) = GTchannel2;
    %                             
    %                             %% Saving the data as matfile
    %                             emg_Data{l,1}(:,tr) = rawdata{1,plotindex1}(:,i);
    %                             emg_Data{l,2}(:,tr) = rawdata{1,plotindex1}(:,i);
    %                             finalEMGdata.groundtruth = GT;
    %                             finalEMGdata.data = emg_Data;
    %                             finalEMGdata.params  = EMGdata.OrgParams;
    %                             finalEMGdata.trialdetail.trialnum = i;
    %                             finalEMGdata.trialdetail.run = j;
    %                             finalEMGdata.trialdetail.session = m;
    %                             finalEMGdata.trialdetail.patient =  PatientfolderName;
    %                             finalEMGdata.trialdetail.lesionloc = lesionloc;
    %                             finalfilename = fullfile(parentFolderPath , strcat('Finaldata.mat'));
    %                            % save(finalfilename,'-struct','finalEMGdata','-v7.3'); 

                               % trial = trial+1;
    %                         else
    %                          b=b+1;
    %                          close all
    %                         end

    %                         save(filePath,'-struct','EMG','-v7.3'); 
    %                     end
    %                     clear EMGtrials;
                    %end
    %                 clear ChannelData;
    %             end
    %             clear EMGdata;
             end  
            clear finalEMGdata
%             end 
        end
    end
end