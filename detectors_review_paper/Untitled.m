clc
clear all
close all


figuredir = '\Figures\';

lamda_on  = 5000:-500:500; 
lamda_off = 500:500:5000; 

  for k = 1:length(lamda_on)
        for i = 1:length(lamda_off) 
        datafile = strcat('ON_',num2str(lamda_off(i)),'OFF_',num2str(lamda_on(k)),algoname,'.ps');
        filename = figuredir + datafile;
        
        
        
        end
  end
 