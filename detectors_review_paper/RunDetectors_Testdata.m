clc
clear all
close all

addpath 'E:\EMG_detectors\detectors_review_paper'
addpath 'E:\EMG_detectors\strokedatacodes'
% DatafolderPath = 'F:\StrokeData\NewData\';
NewDatafolder = 'D:\Strokedata\NewData';
% outputfolder = 'E:\outputData\';
% Get the list of contents in the parent folder
contents = dir(NewDatafolder);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));
Detectors = ["modifiedhodges"];
                %%

result = yaml.loadFile("subjects_data_v200504.yaml");
subjectname = getname(result);
l = 2;
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
                name = strcat('NewGroundTruth',  sessionfolders(m).name);
                filePath = fullfile(folderPath, name);
                [~, Run_ID,~] = fileparts(filePath);
                EMGdata = load(filePath);
                
                %%
                    DataMatrix = [];
                    GroundTruth = [];
                    for i = 1:size(EMGdata.EMGdata.EMGdata.finalEMGdata,2)                   
                         
                            fields = {'data','filterdata','Orgparms'};  
                            params{i} = rmfield(EMGdata.EMGdata.EMGdata.finalEMGdata{1,i},fields);
                            DataMatrix = [DataMatrix (EMGdata.EMGdata.EMGdata.finalEMGdata{1,i}.filterdata)];
                            if(isempty(EMGdata.EMGdata.EMGdata.finalEMG{1,i}) == 0)
                                if(isfield(EMGdata.EMGdata.EMGdata.finalEMG{1,i},'newgroundtruth'))
                                    GroundTruth = [GroundTruth EMGdata.EMGdata.EMGdata.finalEMG{1,i}.newgroundtruth];
                                else
                                    GroundTruth = [GroundTruth EMGdata.EMGdata.EMGdata.finalEMG{1,i}.groundtruth];
                                end
                            else
                                GroundTruth = [GroundTruth zeros(size(EMGdata.EMGdata.EMGdata.finalEMGdata{1,i}.filterdata))];
                            end                                               
                    end
                             %% Run the detector for each session
     [output] = detectorsmainTestdata(DataMatrix'  , Detectors(1));  

      % figure
      % plot(DataMatrix(:,1))
      % hold on
      % stairs(GroundTruth(:,1),'k','LineWidth',1.5 )
      % hold on
      % stairs(output{1, 1}.binop(1,:),'r','LineWidth',1.5 )
     
     Data.filteredData = DataMatrix;
     Data.groundTruth = GroundTruth;
     Data.Output = output;
     Data.orgparams = params;
     
     finalfilename = fullfile(folderPath , strcat('OutputTestdata',Detectors(1),'.mat'));
     save(finalfilename,'Data','-v7.3'); 
            end
   
    end
    
% end
