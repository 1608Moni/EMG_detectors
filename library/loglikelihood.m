function S_j = loglikelihood(j,k,sigma1_sqr,sigma0_sqr,y)
    
    
% S_j = 0.5*sum((sigma0_sqr(j:k).^-2 - sigma1_sqr(j:k).^-2).*y(j:k) + log(sigma0_sqr(j:k).^2/sigma1_sqr(j:k).^2));
   for i =j:k
        s(i) =  sum((sigma0_sqr(i)^-2 - sigma1_sqr(i)^-2)*y(i) + log(sigma0_sqr(i)^2/sigma1_sqr(i)^2));
   end
     S_j = 0.5*sum(s);

end

%  S_j =  sum((sigma0_sqr(j:k).^-2 - sigma1_sqr(j:k).^-2).*y(j:k) + log(sigma0_sqr(j:k).^2/sigma1_sqr(j:k).^2));
