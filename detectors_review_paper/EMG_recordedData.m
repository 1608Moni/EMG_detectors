%% Script to generate the EMG data from the biophysical model. 
%

clc 
clear all
close all


%% Define parameters for the script
savedir    = 'EMG_BiophymodelData\';
p   = 8;
fl  = 10;
fh  = 450;
fs  = 1000;
t0  = 8*fs;

%% Read the simulated data and seperate it as individual trials
EMG = importdata('D:\Phd_july-nov sem\papers\Rviewpaper_EMGonsetdetection\code\Simulator data\EMG_model_simulation\EMGmodel_execs\Physiol2019_EMGmodel_EMGdata_testDataHighforce.txt');
% plot(abs(EMG(:,2)));

%% sample the data
EMG = EMG(1:8:end,2);

%%
G = zeros(1,length(EMG));
dur_move      = 5000;
errordur_move = 4000;
index = 1;
i=1;
while index <= length(EMG)-dur_move+1
   if (abs(EMG(index)) > 0.05)
       if mod(i,5) ~=0
            G(index:index+dur_move-1) = 1;
            a(i) = index;
            index = index + dur_move ;
            i=i+1;
       elseif mod(i,5) == 0
            G(index:index+errordur_move-1) = 1;
            a(i) = index;
            index = index + errordur_move ;
            i=i+1;
       end
   end
   index = index + 1;
end

% %% to generate ground truth for low force levels
% for i = 1:length(EMG)
%      if (abs(EMG(i)) > 0.002)
%         G(i) = 1;
%      end
% end
%  figure
% %  subplot(2,1,1)
% %  plot(G(1:13000))
% %  ylim([-0.05, 1.05])
% %% To remove the short pulses
% b = 1-G;
% index1 = find(diff(b) == 1);
% index2 = find(diff(b) == -1);
% 
% 
% IN = index1 - index2;
% 
% K = find((IN) <=20 );
% 
% for i = 1:length(K)
%     j = index1(K(i));
%     G(j : j+ abs(IN(K(i)))) = 1;
% end
% 
% %%
% 
% plot(EMG(1:13000))
% hold on
% % subplot(2,1,2)
% plot(G(1:13000))
% ylim([-0.05, 1.05])
     
%% to divide it into trials.
IN = find(diff(G));
IN = [(a(1)-8000)-1 IN];
l=1;
for j = 1:2:length(IN)-2
    if j ~= (9+0:10:length(IN))
        k = 13000 - length(IN(j):IN(j+2))
        if k <=0
            EMGdata(l,:) = EMG(IN(j)-k+1 : IN(j+2)+1);
            groundtruth(l,:) = G(IN(j)-k+1 : IN(j+2)+1);
%             figure
%             plot(EMGdata(l,:))
%             hold on
%             plot(groundtruth(l,:))
%             length(EMGdata(l,:))
%             length(groundtruth(l,:))
            l=l+1;
        elseif k > 0
            EMGdata(l,:) = [zeros(k,1);EMG(IN(j)+1 : IN(j+2)+1)];
            groundtruth(l,:) = [zeros(1,k),G(IN(j)+1 : IN(j+2)+1)];
%             figure
%             plot(EMGdata(l,:))
%             hold on
%             plot(groundtruth(l,:))
%             length(EMGdata(l,:))
%             length(groundtruth(l,:))
            l=l+1;
        end
%         pause(2);
%         close all
    end
end

rawemg.data         = EMGdata(1:50,:);
rawemg.groundtruth  = groundtruth;
pathname            = fileparts(savedir);
name                = fullfile(pathname, 'TestDataRawEMGforce300');
save(name,'-struct','rawemg','-v7.3') 
 

for i = 1:size(EMGdata(1:50,:),1)
    
    signal_power = var(EMGdata(i,t0:end));

    noise_power = 2*(signal_power);
    
%     %% To regenerate the data, seed is saved
%     rng('default')
%     s(i) = rng;

    %% generating white noise to be added to signal

    w = sqrt(noise_power)*randn(size(EMGdata(i,:)));

    %% generating the noisy EMG signal

    x(i,:) = EMGdata(i,:) + w;
    
    %% BPF the data
    
    y(i,:) = BPF(p, fl, fh, fs, x(i,:)); 
    
end

% figure
% subplot(3,1,1)
% plot(EMGdata(1,:))
% subplot(3,1,2)
% plot(x(2,:))
% subplot(3,1,3)
% plot(y(2,:))

 emg.data           = y;
 emg.force          = 300;
 emg.groundtruth    = groundtruth;
 emg.SNR            = -3;
 emg.param.fs       = fs;
 emg.param.t0       = 8;
 emg.param.dur      = 13;
 emg.param.notrials = 50;
 emg.param.type     = "BioPhy";
 emg.method         = "Pmove";
 emg.mode           = "Train";

 field      = strcat(char(emg.method),char(emg.mode),'SNR',num2str(round(emg.SNR)),...
                  'trail',num2str(emg.param.notrials),...
                  'dur',num2str(emg.param.dur),emg.param.type);
     name       = fullfile(datadir, strcat(field));
     save(name,'-struct','emg')
