%% Function to perfor
function[] = testAnova(output,type)

% clc
% clear all
% 
% 
Outdir     = 'Results\';

% 
% datafile   = strcat('BioPhy_stepDetector13new.mat');
% datafile   = string(datafile);
% outputfile = Outdir + datafile;
% 
% output =  load(outputfile);
alname = {'RMS.Detector','Hodges','Mod.Hodges','Lidierth','Mod.Lidierth',...
         'Bonato','TKEO','AGLR-G','AGLR-L','Fuzz.Ent','Samp.Ent','CWT','SSA'};
algoname = [];
n = 13;
for i = 1:length(alname)
     algo((50*(i-1)+1):50*i) =  repmat({alname{i}},50,1);
 end


%% rearrange the matrix
%A = [output.cost{3};output.cost{4};output.cost{6};output.cost{7}];
 A = [output.cost{1};output.cost{2};output.cost{3};output.cost{4};...
     output.cost{5};output.cost{6};output.cost{7};output.cost{8};output.cost{9};output.cost{10};output.cost{11};output.cost{12};output.cost{13}];
filename  = strcat('Anovaresutls',type,'Detector',num2str(4),'.xls'); 
filename = Outdir + string(filename);  


[p,tbl,stats] = anova2(A,50,'on');
figure
c1 = multcompare(stats);

writecell(tbl,filename,'Sheet',1);

tbl1 = array2table(c1,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
writetable(tbl1,filename,'Sheet',2);
figure
[c2,m2,h2,nms] = multcompare(stats,"Estimate","row");
tbl2 = array2table(c2,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
writetable(tbl2,filename,'Sheet',3);
title(type)
xlabel('cost')
ylabel('Detectors')
h = gca;
set(gca, "LineWidth",1);
set(gca, "FontSize",11);
set(gca, "FontName",'Times New Roman');
set(gca,"Box",'off');
for i = 1:length(alname) ylab(i) = alname(length(alname)+1-i);end
h.YTickLabel = ylab';
 
end