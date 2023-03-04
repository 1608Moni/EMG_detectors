function u = ramp(i,tou,t0)

    
            if i < t0
                u = 0;
            elseif i >= t0&& i <= (t0+tou)
                u = (i-t0)/tou;
            elseif i > t0 + tou
                u=1;
            end
    

end