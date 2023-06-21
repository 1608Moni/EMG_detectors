function [rFP,rFN] = crosscorrcompute(GT, binop)

    %[value, lags]= xcorr(GT, binop);
    %c = value(find(lags == 0))/length(GT); 
    FP  = length(find((GT-binop) == -2));
    FN = length(find((GT-binop) == 2));
    rFP = length(find((GT-binop) == -2))/length(find(GT == -1));
    rFN = length(find((GT-binop) == 2))/length(find(GT == 1));
    
    

end