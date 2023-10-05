clc
clear all
close all

%% To organise the output folder

DatafolderPath = 'F:\StrokeData\NewData';
NewDatafolder = 'E:\EMGDATA\';
 addpath '    D:\EMG detectors\library'
 
contents = dir(DatafolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

for l = 1:length(subfolders)
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(DatafolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
    for m = 1:length(sessionfolders)           
          %%
          sourceFolder = fullfile(DatafolderPath,  PatientfolderName, sessionfolders(m).name );
          files = dir(fullfile(sourceFolder, '*.mat')); 
          destinationFolder = fullfile(NewDatafolder,  PatientfolderName, sessionfolders(m).name);
          
           if exist( destinationFolder, 'dir') == 7
            % If the folder exists, open it
                fprintf('Folder "%s" already exists.\n', sessionfolders(m).name);
            else
            % If the folder doesn't exist, create it and then open it
                mkdir(destinationFolder);
                fprintf('Folder "%s" created\n', sessionfolders(m).name);
            end
          % Get a list of all files in the source folder
          % Loop through the files and copy each one to the destination folder
          for i = 1:length(files)
            sourceFile = fullfile(sourceFolder, files(i).name);
            destinationFile = fullfile(destinationFolder, files(i).name);
    
            try
                copyfile(sourceFile, destinationFile);
%                 disp(['Copied: ', sourceFile, ' to ', destinationFile]);
            catch
                disp(['Error copying: ', sourceFile, ' to ', destinationFile]);
            end
          end

        disp('All files copied successfully.');
    end
end
