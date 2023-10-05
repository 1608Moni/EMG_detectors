function [kl] = kldistance(p,q,choise)
    
    PH0 = normalisevalue(p);
    PH1 = normalisevalue(q);
    
    klmeasure_ = PH0 .* log(PH0./PH1);
    if choise == 1
       kl = nansum(klmeasure_);
    elseif choise  == 2
        klmeasure_mag = abs(klmeasure_);
        kl = nansum(klmeasure_mag(isfinite(abs(klmeasure_mag))));

    end
%     
%      figure
%      histogram(klmeasure_mag ,'BinWidth',0.01,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);;
    
end