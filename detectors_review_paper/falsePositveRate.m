function FPR = falsePositveRate(groundtruth,binop,t0,tB,p,tdur)
%% Function to compute the false positive rate : FP / (FP+TN)
% INPUT  : groudtruth, Binary o/p, Actual Onset, Start of relax phase
% leaving baseline.
% OUTPUT : False positive rate for each trial 

%%
 
  if length(binop) == length(groundtruth)/p   
    del = groundtruth(1:p:end)-binop;
    FP_on  = abs(sum(del(tB/p:t0/p-1)));
    FPR_on = FP_on/length(groundtruth(tB:p:t0-1));
    FP_off = abs(sum(del((t0+tdur)/p:end)));
    FPR_off = FP_off/length(groundtruth((t0+tdur):p:end-1));
    FPR = FPR_on + FPR_off;
  end
end