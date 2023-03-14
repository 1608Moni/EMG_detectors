function [optindex] = DecideBestparam(index,LR1)
%%Script to decide the best parameter
    for j = 1:length(index)
        med(j) = median(LR1(index(j),:));
    end
    
    tempInd = find(med == max(med));
    optindex     = index(tempInd);     
end