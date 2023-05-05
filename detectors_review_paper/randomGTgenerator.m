function output = randomGTgenerator(ProbON,lamda_on,lamda_off,t0,t,NoTrials)  
 
    for i = 1:NoTrials
    %% Generate step profile with ramp duration of tou
        k=1;
        while k <= length(t)
             if t(k) < t0
                 u(k) = 0;
                 k = k+1;
             elseif t(k) >= t0
                 if rand <= ProbON
                     l_on = poissrnd(lamda_on);
                     u(k:k+l_on-1) = 1;
                     k = k+l_on;
                 else
                     l_off = poissrnd(lamda_off);
                     u(k:k+l_off-1) = 0;
                     k = k+l_off;
                 end
             end
        end
        output(i,:) = u(1:length(t));
        figure(1)
        subplot(2,5,i)
        stairs(output(i,:),'Linewidth',1);
        ylim([-0.1 1.1])
    end
end
