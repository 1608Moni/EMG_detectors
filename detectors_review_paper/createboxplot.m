function [] = createboxplot(A, type)
%% Function to plot the group boxplot of the optimised cost (C_val) of 2 different SNR
%% for the three different model


%% Defining paramters used in the script
trails = 50;
alname = {'1','Modified\newlineHodges','2','AGLR-G','3','AGLR-L','4','Fuzzy\newlineEntropy','5','Modified\newlineLidierth','6','Hodges','7','RMS','8','Lidierth','9',...
    'TKEO','10','Bonato','11','Sample\newlineEntropy','12','CWT','13','SSA'};

%% Formating the data to plot the boxplot
MatA = A.Optcost{1};
MatB = A.Optcost{2};
newMatA =[];
newMatB =[];

for i = 1:size(MatA,2)
    newMatA = [newMatA nan(size(MatA,1),1) MatA(:,i)];  
    newMatB = [newMatB nan(size(MatB,1),1) MatB(:,i)];      
end

MatA1 = reshape( newMatA,[],1);
MatB1 = reshape( newMatB,[],1);
b = [MatA1;MatB1];

for p =1:length(alname)
    algo((50*(p-1)+1):50*p) =  repmat({alname{p}},50,1);
end
[snrgroup{1:(trails*size(newMatA,2))}] = deal('0 dB');
[snrgroup{((trails*size(newMatA,2))+1):((trails*size(newMatA,2))*2)}] = deal('-3 dB');
tbl = table(snrgroup',[algo';algo'],b);
tbl.Var2 = categorical(tbl.Var2,alname);
fig = figure;
box1 = boxchart(tbl.Var2,tbl.b,'GroupByColor',tbl.Var1,'Notch','on');
box1(1).BoxWidth = 0.8;
box1(2).BoxWidth = 0.8;
box1(1).MarkerStyle = '+';
box1(1).MarkerSize = 4;
box1(2).MarkerStyle = '+';
box1(2).MarkerSize = 4;
hold on
x=yline(0.2,'r--','LineWidth',1);
hold on
set(gca, "LineWidth",1.1);
set(gca, "FontSize",12)
xlabel('DETECTORS')
ylabel('Cost')
title(char(type))
h = gca;
h.XTick = h.XTick(2:2:end);
h.FontName = 'Helvetica';
l = legend;
set(l,'Box','off');
end