function [output,Datatype] = detectorsmain(Data, detectorName)
%% Function to call the detectors indiviually for each trial and plot the outputs
% Input params : emg          - Structure which contains emg parameters used for 
%                               generating data and the corresponding raw emg data
%                detectorName - Name of the detector to call
%%
folderPath = 'F:\StrokeData\Data\';
mode = "Train";
method = "";
type = "";
SNR = [];
Datatype = "Restdata";
%% Define the parameters
Dataparams.fs = 500;
fieldList = fieldnames(Data);    
% Data = EMG';
% GT = groundtruth';

%% Call the function to get the parameters of corresponding detector
   paramfuncname = strcat(detectorName, '_param');
   paramfunc =  str2func(paramfuncname);
   params = paramfunc(mode,type,SNR,detectorName,method);
%     for j = 1:size(EMGdata.data,1)
% %             %% Add trials of both channels into single cell array
% %             EMGdata.data{j,1} = [EMGdata.data{j,1} EMGdata.data{j,2}];  
% %             EMGdata.groundtruth{j,1} = [EMGdata.groundtruth{j,1} EMGdata.groundtruth{j,2}];  
%         for i = 1:size(EMGdata.data{j,2},2)
for l = 1:numel(params.combo) 
     params.combo{l}
    for k = 1:size(Data.(fieldList{1}).finalEMGdata,2)
                    if isfield(Data.(fieldList{1}).finalEMGdata{1,k}, 'filteredData') 
                        Data.(fieldList{1}).finalEMGdata{1,k}.filterdata = Data.(fieldList{1}).finalEMGdata{1,k}.filteredData;
                    end  
            %% Call the detector
            Dataparams.dur = (length(Data.(fieldList{1}).finalEMGdata{1,k}.(Datatype))/Dataparams.fs);
            detectorfunc = str2func(detectorName);
            output{l,k} = detectorfunc(Data.(fieldList{1}).finalEMGdata{1,k}.(Datatype)',params.combo{l}, params, Dataparams);
            
%                         %% plot function
%             plotfunc(output{l,k},k,detectorName,[]);  
% % %             pause(2);
%             close all;
    end
end
%             EMGtrial{j,i} = output;
%             %% plot function
%                 histogram(output.testfunc(2001:end),'BinWidth',0.05,'Displaystyle','stairs')
%                 xline(output.thresh,'r--')
%              plotfunc(output,i,detectorName,EMGdata.groundtruth{j,1}(:,i)');   
%              pause(2)
%              close all
%         end
%     end
%      EMGdata.output = EMGtrial;
%      finalfilename = fullfile(folderPath , strcat('output',method,detectorName,'.mat'));
%      save(finalfilename,'-struct','EMGdata','-v7.3');    
%      disp('filesaved')
end