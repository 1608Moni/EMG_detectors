clc
clear all
close all

datadir         = '..\data\';
method = "Pmove";
mode   = "Test";
Model  = ["biophy"];
datagen = "";
SNR    = [0];
trial  = 50;                % Total number of trials
dur    = 13;                % Duration in seconds

for j = 1:length(SNR)
 datafile = strcat(method,mode,"SNR",string(SNR(j)),"trail",num2str(trial),"dur",num2str(dur),Model(1),".mat");
 %datafile1 = strcat('EMGData',"SNR",SNR(1),"trail",num2str(trial),"dur",num2str(dur),Model(2),'.mat');
 if mode == "Train"
    datafile1 = "RawEMGHighforce.mat";
 elseif mode == "Test"
    datafile1 = "TestDataRawEMGforce300.mat";
 end
 
  %% Read the data file and carryout analysis.
 datafile1 = datadir + datafile1;
 %% Load the generated EMG_data of the specific SNR
 EMG = load(datafile1);
 x  = EMG.data;
p   = 8;
fl  = 10;
fh  = 450;
fs  = 1000;
t0  = 8;
t   = (1/fs):(1/fs):13; 
 
 %% Generate groundtruth for different values of P_ON , lamda_on and lamda_off
 ProbON = 0.5;
 lamda_on = 500:500:5000;
 lamda_off = 500:500:5000;
 
 for r = 1:length(lamda_on)
     for k = 1:length(lamda_off)
        
        lamda_on(r)
        lamda_off(k)
        Groundtruth = randomGTgenerator(ProbON,lamda_on(r),lamda_off(k),t0,t,50);  

        for i=1:size(EMG.data,1)
            y(i,:) = x(i,:).*Groundtruth(i,:);

            signal_power = var(x(i,t0:end));

            noise_power = round(1/(10^(SNR/10)))*(signal_power);


            %% generating white noise to be added to signal

            w(i,:)= sqrt(noise_power)*randn(size(x(i,:)));

            %% generating the noisy EMG signal

            xraw(i,:) = y(i,:) + w(i,:);

            %% BPF the data
                if datagen == "Noise"
                    EMGdata(i,:) = BPF(p, fl, fh, fs, w(i,:)); 
                else
                    EMGdata(i,:) = BPF(p, fl, fh, fs, xraw(i,:)); 
                end
%       figure(i)
%       plot(Groundtruth(i,:),'r','LineWidth',2)
%       hold on
%       plot(EMGdata(i,:),'b')
%       pause(2)
%       close all                     
                
        end
         
    

      
     emg.data           = EMGdata;
     emg.force          = 300;
     emg.groundtruth    = Groundtruth;
     emg.SNR            = SNR;
     emg.param.fs       = fs;
     emg.param.t0       = 8;
     emg.param.dur      = 13;
     emg.param.notrials = 50;
     emg.param.type     = "BioPhy";
     emg.method         = method;
     emg.mode           = strcat("Test","ON_",num2str(lamda_on(r)),"OFF_",num2str(lamda_off(k)));

 field      = strcat(char(datagen),char(emg.method),char(emg.mode),'SNR',num2str(round(emg.SNR)),...
                  'trail',num2str(emg.param.notrials),...
                  'dur',num2str(emg.param.dur),emg.param.type);
     name       = fullfile(datadir, strcat(field));
     save(name,'-struct','emg')
     end
 end
end 