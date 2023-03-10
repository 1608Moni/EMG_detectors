function [index] = bestparam(Avg_CF, range_CF)
%% Function to identify the best parameter combination
% INPUT  : mean and IQR of cost func distribution
% OUTPUT : index of the parameter combo with minimum euclidean distance from origin
    distance       = sqrt(Avg_CF.^2 + range_CF.^2);
    [value, index] = min(distance);      
end