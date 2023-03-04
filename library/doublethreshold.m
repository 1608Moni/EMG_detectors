function[bin2, binop] = doublethreshold(t,i,m,T1,bin1,bin2, binop)
%% function to compute the onset and binary o/p using double threshold.

%% n out of m points crosses the threshold
if i > m
    f1(i) = (1/m)*sum(bin1(i-m+1:i));
    if f1(i) > 0
        bin2(i)=1;
    end
end
%% active state lasts for T1 samples           
if i > T1                  
    f2(i) = (1/T1)*sum(bin2(i-T1+1:i));
    if f2(i) == 1
        binop(i)=1;
    end
end
end