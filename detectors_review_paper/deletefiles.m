clc
clear all
close all
%% function to delete files in

NewDatafolder = 'E:\outputData\';

contents = dir(NewDatafolder);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));


for l = 1:length(subfolders)
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(NewDatafolder,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
    for m = 1:length(sessionfolders)  
        folderPath = fullfile(NewDatafolder,  PatientfolderName, sessionfolders(m).name, 'output ');
        files = dir(fullfile(folderPath, '*.mat')); 
       

        % Sort the file list by name to keep the first four files
        [~, idx] = sort({files.name});
        fileList = files(idx);
        
        if size(fileList,1) > 2
            % Keep the first four files and delete the rest
            for i = 5:numel(fileList)
                if ~fileList(i).isdir % Ensure it's not a directory
                    fileToDelete = fullfile(folderPath, fileList(i).name);
                    delete(fileToDelete); % Delete the file
                    disp(['Deleted file: ' fileList(i).name]);
                end
            end
        end
    end
end
