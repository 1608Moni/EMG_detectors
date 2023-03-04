%% Script to plot the boxplot of RMS detector with parameters use in Balasubranian et.al 2018 paper

clc
clear all
close all

mode   = "Test";
opt    = "Cuboid";
costdir = strcat('costfunction\',mode,'\',opt,'\');
type       = {'gaussian','laplacian','biophy'};
algoname   = {'Detector2018'};
SNRdB      = [0,-3];
model      = {'gaussian','laplacian','biophysical'};

%% formating to plot the boxplot
for i = 1:length(SNRdB)
    for k = 1:length(algoname)
        for j = 1:length(type)
             text= strcat('Param2','Optcost',char(mode),type(j),algoname{k},'SNR',num2str(SNRdB(i)),'.mat'); 
             datafile = string(text);
             outputfile = costdir + datafile;
             costoutput = load(outputfile);
             
             p(:,j) = costoutput.CF';            
        end
    end
    P{i} = p;
end

MatA  = P{1};
MatB  = P{2};
MatA1 = reshape(MatA,[],1);
MatB1 = reshape(MatB,[],1);

b = [MatA1;MatB1];

for l =1:length(type)
    algo((50*(l-1)+1):50*l) =  repmat({type{l}},50,1);
end

[snrgroup{1:150}] = deal('0 dB');
[snrgroup{151:300}] = deal('-3 dB');
tbl = table(snrgroup',[algo';algo'],b);
tbl.Var2 = categorical(tbl.Var2,type);
  
figure
fig = gcf;
box1 = boxchart(tbl.Var2,tbl.b,'GroupByColor',tbl.Var1,'Notch','on');
hold on
yline(0.2,'r--','LineWidth',1);
set(gca, "LineWidth",1.1);
set(gca, "FontSize",12)
set(gca, "FontName",'Times New Roman')
gcf.Position = [4.3333 206.3333 1.2467e+03 432.6667];
xlabel('Signal Models')
ylabel('Cost')
title('RMS Detector')
legend