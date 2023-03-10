function FNR = falseNegativeRate(groundtruth,binop,t0,p)
%% Function to compute the false negative rate : FN / (FN+TP)
% INPUT  : groudtruth, Binary o/p, Actual Onset, Start of relax phase
% leaving baseline.
% OUTPUT : False negative rate for each trial 


%%
 if length(binop) == length(groundtruth)/p 
    del = groundtruth(1:p:end)-binop;
    FNR = sum(del(t0/p:end))/length(groundtruth(t0:p:end));
 end
  
%  figure
%  plot(groundtruth,'y')
%  hold on
%  stem(binop,'r')
%  hold on
% stem(del)
end