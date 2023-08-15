function detectorsmain(EMGdata, detectorName)
%% Function to call the detectors indiviually for each trial and plot the outputs
% Input params : emg          - Structure which contains emg parameters used for 
%                               generating data and the corresponding raw emg data
%                detectorName - Name of the detector to call
%%
folderPath = 'F:\StrokeData\Data\';
mode = "Test";
type = "biophy";
SNR = 0;
%% Define the parameters
Dataparams.fs = 500;
% Data = EMG';
% GT = groundtruth';

%% Call the function to get the parameters of corresponding detector
   paramfuncname = strcat(detectorName, '_param');
   paramfunc =  str2func(paramfuncname);
   params = paramfunc(mode,type,SNR,detectorName);
    for j = 1:size(EMGdata.data,1)
            %% Add trials of both channels into single cell array
            EMGdata.data{j,1} = [EMGdata.data{j,1} EMGdata.data{j,2}];  
            EMGdata.groundtruth{j,1} = [EMGdata.groundtruth{j,1} EMGdata.groundtruth{j,2}];  
        for i = 1:size(EMGdata.data{j,1},2)
            %% Call the detector
            Dataparams.dur = (length(EMGdata.data{j,1}(:,i))/Dataparams.fs);
            detectorfunc = str2func(detectorName);
            output = detectorfunc(EMGdata.data{j,1}(:,i)',params.combo{1}, params, Dataparams);

            EMGtrial{j,i} = output;
%             %% plot function
%              plotfunc(output,i,detectorName,EMGdata.groundtruth{j,1}(:,i)');   
%              pause(2)
%              close all
        end
    end
     EMGdata.output = EMGtrial;
     finalfilename = fullfile(folderPath , strcat('Outputpulse',detectorName,'.mat'));
     save(finalfilename,'-struct','EMGdata','-v7.3');    
     disp('filesaved')
end