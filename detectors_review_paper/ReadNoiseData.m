clc
clear all
close all



DatafolderPath = 'F:\StrokeData\NewData\';
NewDatafolder = 'E:\outputData\';
 addpath '    D:\EMG detectors\library'

contents = dir(DatafolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));
Detectors = ["modifiedhodges"];

tr = 1;
for l = 1:length(subfolders)
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(DatafolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
    for m = 1:length(sessionfolders)           
          %%
          folderPath = fullfile(DatafolderPath,  PatientfolderName, sessionfolders(m).name );
          files = dir(fullfile(folderPath, '*.mat')); 
          %% Create output folder to save the output .mat files
            OutputFolderPath = fullfile(NewDatafolder,  PatientfolderName, sessionfolders(m).name, 'output');
            % Check if the folder exists
            if exist( OutputFolderPath, 'dir') == 7
            % If the folder exists, open it
                fprintf('Folder "%s" already exists.\n', sessionfolders(m).name);
            else
            % If the folder doesn't exist, create it and then open it
                mkdir(OutputFolderPath);
                fprintf('Folder "%s" created\n', sessionfolders(m).name);
            end
            
            if isempty(files) == 0 
             filePath = fullfile(folderPath, files(2).name);
                EMGdata = load(filePath);      
                 disp(strcat(PatientfolderName,'SessionNo', num2str(m)));
                    for o = 1:length(Detectors)
                        [output, datatype] = detectorsmain(EMGdata, Detectors(o));  
                    end
                    
                    if datatype == "filterdata"
                        name = "EMG";
                    else
                        name = "Noise";
                    end
%                     figure(tr)
%                     subplot(2,1,1)
%                     plot(EMGdata.(fieldList{1}).finalEMGdata{1,k}.filterdata)
%                     title('Data_EMG','Interpreter','none')
%                     subplot(2,1,2)
%                     plot(EMGdata.(fieldList{1}).finalEMGdata{1,k}.Restdata)
%                     title('Data_Noise','Interpreter','none')
%                     sgtitle(strcat('Trail:', num2str(tr)))
% %                     name = 'EMGdata&Restdata';
% %                     export_fig(char(name),'-pdf','-append',figure(tr));
%                      tr = tr+1;
%                     pause(2)
%                     close all
                     
                    %% Save  data
                        finalfilename = fullfile(OutputFolderPath , strcat('Alpha',name,Detectors(o),'.mat'));
                        save(finalfilename,'output','-v7.3');  
                    
          end
    end
end