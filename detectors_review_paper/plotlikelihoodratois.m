function [] = plotlikelihoodratois(q,a,LR0,LR1,name,h,area,mode)

bw0 = ((max(LR0(q,:))-min(LR0(q,:)))/20) + 0.001;
bw1 = ((max(LR1(q,:))-min(LR1(q,:)))/20) + 0.001;
figure(q*a)
[u,v]=ksdensity(LR0(q,:),'Bandwidth',bw0,'Support',[-1. 1.5]); 
[u1,v1]=ksdensity(LR1(q,:),'Bandwidth',bw1,'Support',[-1.5 1.5]); 
p1 = plot(v,u, 'Color', [0.8 0 0],'Linewidth',1.5);
hold on
p2 = plot(v1,u1, 'Color', [0 0 1],'Linewidth',1.5);
hold on
xline(h(q),'r--','Linewidth',1)
txt = {strcat('area = ',num2str(area))};
text(0.5,1,txt,'FontSize',12)
% histogram(LR0(q,:),'BinWidth',0.1)
% hold on
% histogram(LR1(q,:),'BinWidth',0.1)
legend('LRNoise','LREMG','95th percentile')
xlabel('Likelihood ratio')
ylabel('Kernel density estimated PDF')
 title(name,'Interpreter','none','Fontsize',6);
 
%  %% plot delP vs pEMG
%  figure(10*q*a)
%  filename = strcat(mode,'Pmove.xls');
%  probm = xlsread(char(filename));
%  
% scatter(probm,LR1(q,:));
% ylabel('\Delta(p)')
% xlabel('Pmove')
% xlim([0 1])
% ylim([0 1])
% hold on
% plot([0,1],[0,1])

%  


q
end