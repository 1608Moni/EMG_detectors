clc
clear all
close all

data = load('C:\Users\Monisha\Desktop\EMG detectors\data\PmoveTestSNR0trail50dur13biophy.mat');
output = load('C:\Users\Monisha\Desktop\EMG detectors\detectors_review_paper\output\Train\PmoveTrainOutputDetector2018trail50BioPhydur13SNR0force300.mat');
cost = load('C:\Users\Monisha\Desktop\EMG detectors\detectors_review_paper\costfunction\Test\Cuboid\kappaTestbiophyDetector2018SNR0.mat');
params = output.params.combo{1};
wshift = params(3);
binop = output.binop{1};
fs = 1000;
t1 = (wshift/fs):(wshift/fs):13000/fs; 
t = (1/fs):(1/fs):13;
for i = 1:50
     
     kappa = cohensKappa(data.groundtruth(i,8000:wshift:end),binop(i,(8000/wshift):end))
     figure(i)
     subplot(2,1,1)
     stairs(t,data.groundtruth(i,:),'Linewidth',1.5)
     title('Groundtruth')
     subplot(2,1,2)
     stairs(t1,binop(i,:),'Linewidth',1.5)
     title('Binary output')
     txt = {strcat('cohen coeff = ',num2str(round(kappa,5)))};
     text(1.5,0.8,txt,'FontSize',12)
     pause(2)
     close all
end