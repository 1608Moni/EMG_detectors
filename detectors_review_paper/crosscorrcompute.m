function [c] = crosscorrcompute(GT, binop)

    [value, lags]= xcorr(GT, binop);
    c = value(find(lags == 0))/length(GT); 

end