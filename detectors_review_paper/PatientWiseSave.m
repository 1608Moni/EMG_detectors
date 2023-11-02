clc
clear all
close all

addpath 'E:\EMG_detectors\strokedatacodes'
% DatafolderPath = '..\StrokeData\NewData\';
parentFolderPath = 'E:\AllTrials\';
NewDatafolder = 'E:\StrokeData\NewData\';
% addpath 'D:\EMG detectors\detectors_review_paper'

contents = dir(parentFolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));
plotflag = 0;

%% Notch filter design
fs = 500;
fo = 50;
q = 35;
bw = (fo/(fs/2))/q;
[b1,a1] = iircomb(fs/fo,bw,'notch'); % Note type flag 'notch'

%% High pass filter
fc = 10;
[b2,a2]   = butter(2,fc/(fs/2),'high');

%% To know the lession side
result = yaml.loadFile("subjects_data_v200504.yaml");
subjectname = getname(result);


for l = 1:length(subfolders)
    %%
    % %% To know the lession location 
    index = find(string(subfolders(l).name) == subjectname);
    lesionloc = result.subjects{index}.lesion.location;
    if lesionloc == "L"
        plotindex1 = 9; %choose_no_randomly(0.5,1,2);       
    else
        plotindex1 = 10; %choose_no_randomly(0.5,5,6); 
    end
    disp(strcat("lesion location : ", lesionloc))

    %%
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(parentFolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
    for m = 1:length(sessionfolders)           
          
        %% Create folders to save the trials
        NewFolderPath = fullfile(NewDatafolder,PatientfolderName,sessionfolders(m).name);
        %Check if the folder exists
        if exist( NewFolderPath, 'dir') == 7
        % If the folder exists, open it
            fprintf('Folder "%s" already exists.\n', sessionfolders(m).name);
        else
        % If the folder doesn't exist, create it and then open it
            mkdir( NewFolderPath);
            fprintf('Folder "%s" created\n', sessionfolders(m).name);
        end
       
          %% Reading the DAT file
          folderPath = fullfile(parentFolderPath,  PatientfolderName, sessionfolders(m).name );
          files = dir(fullfile(folderPath, '*.mat')); 
           if isempty(files) == 0
               AllrunH1data =[];
               AllrunH0data= [];
             for j = 1:numel(files)
                %% Load different runs within a session
                filePath = fullfile(folderPath, files(j).name);
                [~, Run_ID,~] = fileparts(filePath);
                EMGdata = load(filePath);
                %%
                index = randperm(10,5);
                %% Choose 5 random trials from each channel for left and right seperately
                EMGdata.data{1,9} = [EMGdata.data{1,1} EMGdata.data{1,2}];
                EMGdata.data{1,10} = [EMGdata.data{1,5} EMGdata.data{1,6}];
                %%
                rawdata = EMGdata.data;
                
                %% filter data
                EMGnotch = filter(b1,a1,rawdata{1,plotindex1});
                EMGfilterdata = filter(b2,a2,EMGnotch);
                % %% plot the freqspectrum 
                % freqspectrumplot(rawdata{1,plotindex1}(:,Tr_),EMGfilterdata,fs);

                %% Generate the rest data model for the chosen trials
               

                for  k = 1:size(EMGfilterdata,2)
                   % choose only the rest phase to model 
                    data_rest = EMGfilterdata(1:2001,k);
                  %% AR_Model
                    %order of AR model
                    p = 5;
                    y(k,:) = AR_MODEL(data_rest',length(data_rest),length(EMGfilterdata(:,k)),p,EMGfilterdata(:,k));  
                
                end  
                AllrunH1data = [AllrunH1data; EMGfilterdata'];
                AllrunH0data = [AllrunH0data; y];
                runParams{j} = EMGdata.OrgParams;
                clear y
                clear EMGfilterdata
             end
             
             % trial = trial + 1;
           end

           %% save session files
             finalEMGdata.filteredData = AllrunH1data;
             finalEMGdata.Restdata = AllrunH0data;
             finalEMGdata.lessionloc = lesionloc;
             finalEMGdata.session = m;
             finalEMGdata.Totalrun = numel(files);
             finalEMGdata.Orgparms = runParams;
             finalfilename = fullfile( NewFolderPath , strcat(sessionfolders(m).name,'.mat'));
             save(finalfilename,'finalEMGdata');  
    end
end