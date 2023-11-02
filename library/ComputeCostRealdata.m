clc
clear all
close all
%% Script to compute the cost of detection for real data for each patient

addpath 'E:\EMG_detectors\detectors_review_paper'
addpath 'E:\EMG_detectors\strokedatacodes'
NewDatafolder = 'D:\Strokedata\NewData';

% Get the list of contents in the parent folder
contents = dir(NewDatafolder);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));
Detectors = ["modifiedhodges"];
%%
result = yaml.loadFile("subjects_data_v200504.yaml");
subjectname = getname(result);
l = 1;
% for l = 1:2%length(subfolders)
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
    Foldcontents = dir(fullfile(NewDatafolder,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));
    
    tr = 1;
    %%
    for m = 1:length(sessionfolders)   
  
        % files2 = dir(fullfile(fullFolderPath, '*.mat'));
            %% Reading the DAT file
            folderPath = fullfile(NewDatafolder,  PatientfolderName, sessionfolders(m).name );
            % OutputFolderPath = fullfile(outputfolder,  PatientfolderName, sessionfolders(m).name, 'output');
            files = dir(fullfile(folderPath, '*.mat'));     
            if isempty(files) == 0
             % for j = 1:numel(files)
             % while trial <= 5 && any(usedRuns == 0)
                % Run_ = randi([1 numel(files)]);
                % RepetedRuns_(Run_) =  RepetedRuns_(Run_) + 1;
                filename = strcat('OutputTestdata',Detectors(1),'.mat');
                filePath = fullfile(folderPath, filename);
                [~, Run_ID,~] = fileparts(filePath);
                EMGdata = load(filePath);

                tb = 1000;
                
                    for i = 1:size(EMGdata.Data.filteredData,2)                   
                        %  %% Compute the latency
                        % [Latencyparams] = LatencyBurst3(EMGdata.Data.groundTruth(:,i)',...
                        % EMGdata.Data.Output{1, 1}.binop(i,:),(dur/fs),fs,Wshift);  
                        % 
                        %  %% Compute the false positive and false negative rate
                        %  [rFP(tr),rFN(tr)]= crosscorrcompute(EMGdata.Data.groundTruth(tb:end,i)',EMGdata.Data.Output{1, 1}.binop(i,tb:end));
                        % 
                        %  %% Compute the cost

                        
                        
                         
                        
                        
                         
                         %% plot the individual trials
                         figure
                         plot(EMGdata.Data.filteredData(:,i),'Color', [0.8 0.85 1])
                         hold on
                         plot(EMGdata.Data.Output{1, 1}.testfunc(i,:),'Color',[0.6 0 0.2])
                         hold on
                         yline(EMGdata.Data.Output{1, 1}.h(i),'r--')
                         stairs(max(EMGdata.Data.filteredData(:,i)).*EMGdata.Data.groundTruth(:,i),'k','LineWidth',1.5 )
                         hold on
                         stairs(max(EMGdata.Data.filteredData(:,i)).*EMGdata.Data.Output{1, 1}.binop(i,:),'r' )
                         pause(2)
                         close all
                         tr = tr + 1;
                    end
            end  
    end
    
% end
