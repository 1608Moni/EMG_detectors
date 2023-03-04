function FPR = falsePositveRate(groundtruth,binop,t0,tB,p)
%% Function to compute the false positive rate : FP / (FP+TN)
% INPUT  : groudtruth, Binary o/p, Actual Onset, Start of relax phase
% leaving baseline.
% OUTPUT : False positive rate for each trial 

%%
 
  if length(binop) == length(groundtruth)/p   
    del = groundtruth(1:p:end)-binop;
    FP  = abs(sum(del(tB/p:t0/p-1)));
    FPR = FP/length(groundtruth(tB:p:t0-1));
  end
end