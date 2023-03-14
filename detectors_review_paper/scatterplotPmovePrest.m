function[]=scatterplotPmovePrest(q,a,prest1,pmove1,name)

if q <=25
    figure(1)
    subplot(5,5,q)
    scatter(prest1(q,:),pmove1(q,:))
    xlabel('P_d (rest)')
    ylabel('P_d (move)')
    xlim([0 1])
    ylim([0 1])
    title(name,'Interpreter','none','Fontsize',6)
else 
    figure(2)
    subplot(5,5,q-25)
    scatter(prest1(q,:),pmove1(q,:))
    xlabel('P_d (rest)')
    ylabel('P_d (move)')
    xlim([0 1])
    ylim([0 1])
    title(name,'Interpreter','none')

end