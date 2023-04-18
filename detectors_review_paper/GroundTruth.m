function [GT] = GroundTruth(dur,onset,type)
%% function to generate groundtruth for comparison
% Input  : Duration of generated emg signals and Actual onset.
% Output : Ground truth (binary signal). 
%%


%% Gaussian data

    groundtruth  = zeros(1,dur);

    for k=1:length(groundtruth)
        if k >=onset
            gt(k) = 1;    
        end
    end
    GT = repmat(gt,50,1);

end