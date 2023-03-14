clc
clear all
close all

data = load('C:\Users\Monisha\Desktop\EMG detectors\data\PmoveTestSNR0trail50dur13biophy.mat');
output = load('C:\Users\Monisha\Desktop\EMG detectors\detectors_review_paper\output\Test\PmoveTestOutputmodifiedhodgestrail50BioPhydur13SNR0force300.mat');
binop = output.binop{1};
for i = 1:50
     figure(i)
     subplot(2,1,1)
     stairs(data.groundtruth(i,:),'Linewidth',1.5)
     title('Groundtruth')
     subplot(2,1,2)
     stairs(binop(i,:),'Linewidth',1.5)
     title('Binary output')
end