function [rFP,rFN] = crosscorrcompute(GT, binop)

    %[value, lags]= xcorr(GT, binop);
    %c = value(find(lags == 0))/length(GT); 
    FP  = length(find((GT-binop) == -1));
    FN = length(find((GT-binop) == 1));
    rFP = length(find((GT-binop) == -1))/length(find(GT == 0));
    rFN = length(find((GT-binop) == 1))/length(find(GT == 1));
    
    

end