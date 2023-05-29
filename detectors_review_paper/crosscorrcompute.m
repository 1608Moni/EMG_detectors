function [c,rFP,rFN] = crosscorrcompute(GT, binop)

    [value, lags]= xcorr(GT, binop);
    c = value(find(lags == 0))/length(GT); 
    rFP = length(find((GT-binop) == -2))/length(GT);
    rFN = length(find((GT-binop) == 2))/length(GT);
    
    

end