function [Avg_CF, range_CF] = medIqr(CF)
%% function to compute median and iqr of the cost function distribution
% INPUT  : cost function distribution of individual parameter combination
% Output : mean and iqr

    Avg_CF   = median(CF);
    range_CF = iqr(CF);
end