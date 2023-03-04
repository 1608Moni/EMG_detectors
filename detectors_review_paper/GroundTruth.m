function [GT] = GroundTruth(dur,onset,type)
%% function to generate groundtruth for comparison
% Input  : Duration of generated emg signals and Actual onset.
% Output : Ground truth (binary signal). 
%%
GTdir      = 'EMG_BiophymodelData\';

%% Gaussian data
if  type == "gaussian" || type =="laplacian"
    groundtruth  = zeros(1,dur);

    for k=1:length(groundtruth)
        if k >=onset
            gt(k) = 1;    
        end
    end
    GT = repmat(gt,50,1);
end
%% Biophydata
if type == "BioPhy"
GTfile     = GTdir + "NoiseEMGSNRdb0force300.mat";
data       = load(GTfile);
GT         = data.groundtruth;
end
end