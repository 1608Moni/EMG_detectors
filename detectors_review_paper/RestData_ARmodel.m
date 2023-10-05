clc
clear all
close all

% addpath 'F:'
DatafolderPath = '..\StrokeData\NewData\';
% NewDatafolder = 'F:\StrokeData\filterddatanew\';
% addpath 'D:\EMG detectors\detectors_review_paper'

contents = dir(DatafolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

tr = 1;
for l = 1:length(subfolders)
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(DatafolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
    for m = 1:length(sessionfolders)           
         folderPath = fullfile(DatafolderPath,  PatientfolderName, sessionfolders(m).name );
%          files = dir(fullfile(folderPath, '*.mat')); 
%          if isempty(files) == 0 && numel(files) < 2
             filePath = fullfile(folderPath, files(1).name);
                EMGdata = load(filePath);
                fieldList = fieldnames(EMGdata);
                EMGdata.finalEMGdata = EMGdata.(fieldList{1});
                for k = 1:size(EMGdata.finalEMGdata,2)
                    
                end
%          end
    end
end