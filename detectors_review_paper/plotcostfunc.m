function [] = plotcostfunc(CF,name)      
%% plot the latency for each trial

%%
               Bw = 0.02;
      
               fig=figure;
               subplot(1,3,1)
               for q = 1:size(CF.CF,1)
                    [u,v]=ksdensity(CF.CF(q,:),'Bandwidth',Bw);
                    hold on
                    p1 = plot(v,u, 'Color', [0.8 0.85 1]);
%                     p1 = histogram(CF.CF(q,:),'BinWidth',0.2,'EdgeColor','b','EdgeAlpha',0.2);%'Displaystyle','stairs'
%                     p1.Visible = 'off';
%                     hold on
%                    for i = 1:length(p1.BinEdges)-1 
%                        Bincentre(i) = (p1.BinEdges(i) + p1.BinEdges(i+1))/2;
%                    end
%                    plot(Bincentre,p1.Values,'Color',[0.8 0.85 1],'LineWidth',1);
%                    clear Bincentre
                   xlim([0 1])   
               end
               hold on
               [uopt,vopt]=ksdensity(CF.CF(CF.Optindex,:),'Bandwidth',Bw);
               p2 = plot(vopt,uopt, 'Color', [0.8 0 0],'Linewidth',1.5);
%                p2 = histogram(CF.CF(CF.Optindex,:),'Displaystyle','stairs','BinWidth',0.2,'EdgeColor',[0.8, 0, 0],'EdgeAlpha',1);%'Displaystyle','stairs'
%                   p2.Visible = 'off';  
%                    for j = 1:length(p2.BinEdges)-1 
%                        Bincentre1(j) = (p2.BinEdges(j) + p2.BinEdges(j+1))/2;
%                    end
%                    plot(Bincentre1,p2.Values,'Color',[0.6 0 0.2],'LineWidth',1);
                   xlim([0 1])                   
               
               
               ylabel('PDF (No of trials)');
               xlabel('Cost (C)')
               set(gca,"FontSize",12)
               set(gca,"LineWidth",1.1)
               set(gca,"Layer","Top")
               legend([p2],'Best paramter')
               set(legend, 'Box','off','Position',[0.144014636696289 0.826510721247563 0.111082070047046 0.0643274853801169])
               ylim([0 20])
               xlim([0 1])             
               hold on
%% PLot the median vs IQR scatter plot


%       figure(1)
      subplot(1,3,2)
      sz = 30;
      scatter(CF.Avg_CF,CF.range_CF,sz,'filled')    
      hold on
      plot(CF.Avg_CF(CF.Optindex),CF.range_CF(CF.Optindex),'o','Color',[0.6 0 0.2],'MarkerFaceColor',[0.8 0 0],'MarkerSize',6);
      xlabel('Median (C_{med})')
      ylabel('Inter-quartile range (C_{irq})')
      set(gca, "LineWidth",1.1)
      set(gca,"FontSize",12);

%% Plot the factors of cost function
 hold on
% figure(1)
subplot(1,3,3)
[u1,v1] = ksdensity(CF.CF(CF.Optindex,:),'Bandwidth',Bw);
[u2,v2] = ksdensity(CF.f_delT(CF.Optindex,:),'Bandwidth',Bw);
[u3,v3] = ksdensity(CF.rFP(CF.Optindex,:),'Bandwidth',Bw);
[u4,v4] = ksdensity(CF.rFN(CF.Optindex,:),'Bandwidth',Bw);
p = area(v1,u1,'EdgeColor',[0.8, 0, 0],'FaceColor',[1 0.9 0.9],'LineWidth', 1.25);
hold on
plot(v2,u2,'Color','b','LineWidth', 1.25)
hold on
plot(v3,u3,'LineWidth', 1.25)
hold on
plot(v4,u4,'LineWidth', 1.25)
% histogram(CF.CF(CF.Optindex,:),'BinWidth',0.1,'EdgeColor',[0.8, 0, 0],'FaceColor',[0.8, 0, 0],'FaceAlpha',0.2,'LineWidth',1.5);%'Displaystyle','stairs'
% hold on
% histogram(CF.f_delT(CF.Optindex,:),'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[1 0.7 0.3],'LineWidth',1.5);%,'Displaystyle','stairs'
% hold on
% histogram(CF.rFP(CF.Optindex,:),'BinWidth',0.1,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4],'LineWidth',1.5);
% hold on
% histogram(CF.rFN(CF.Optindex,:),'BinWidth',0.1,'EdgeColor',[0 0 1],'FaceColor',[0 0 1],'FaceAlpha',0.2,'LineWidth',1.5);

ylabel('PDF (No of trials)');
xlabel('C, f({\Delta}t), r_{FP}, r_{FN}')
set(gca,"FontSize",12)
set(gca, "LineWidth",1.1)
set(gca, 'Box', 'off')
xlim([0 0.4])
l=legend('C','f({{\Delta}t})','r_{FP}','r_{FN}');
set(legend, 'Box','off','Orientation','horizontal','NumColumns',2);

set(gcf,'Position', [-1 296.3333 1.2753e+03 342.0000]);
%  sgtitle(name,'Interpreter','none')
end