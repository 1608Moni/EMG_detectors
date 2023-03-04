%% script to plot freq spectrum, PDF and Time series of EMG data
%
%
clc
clear all
close all

%% define variables in the script
BioPhydatadir   = 'EMG_BiophymodelData\';
datadir         = '..\data\data\';
datafiles = ["EMGDataSNR0trail50dur13biophy.mat","EMGDataSNR0trail50dur13gaussian.mat","EMGDataSNR0trail50dur13laplacian.mat"]; %"RawEMGforce300",
datafile2 = ["RawEMGforce300"];
model = {'Biophysical','Gaussian','Laplacian'};
t0 = 8000;
j=1;
%%
datafiles2 = datadir + datafile2(1); 
x = load(datafiles2);
x = x.data;
x = x(1,:);
for i=1:length(datafiles)
    if i ==1 
        datafile = datadir + datafiles(i); 
        EMG = load(datafile);
        EMG = EMG.data;
        y(i,:) = EMG(1,:);%BPF(8, 10, 450, 1000, EMG(1,:)); 
     else
        datafile = datadir + datafiles(i);
        EMG = load(datafile);
        dyn_var = EMG.dynVar;
        EMG = EMG.data;
        y(i,:) = EMG(1,:);
    end


  
    %% 
    Fs = 1000;
    Nsamps = length(y(i,:));
    t = (1/Fs)*(1:Nsamps);          %Prepare time data for plot
    
%%     %Do Fourier Transform
    Nsamps = length(y(i,t0:end));
%     t = (1/Fs)*(1:Nsamps);   
    y_fft = abs(fft(y(i,t0:end)));  %Retain Magnitude
    y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
    x_fft = abs(fft(x(1,t0:end)));  
    x_fft = x_fft(1:Nsamps/2);         
    f = Fs*(0:(Nsamps-2)/2)/Nsamps; %Prepare freq data for plot
    
    %%
     y_fft1 = abs(fft(abs(y(i,t0:end)))); 
     y_fft1 = y_fft1(1:Nsamps/2);  
     x_fft1 = abs(fft(abs(x(1,t0:end)))); 
     x_fft1 = x_fft1(1:Nsamps/2);  
     figure(2) 
     subplot(3,1,i)
     plot(f, y_fft1,'Color', [0.43, 0.58, 0.85])  
     xlim([1 500])
%%     Plot raw signal
    figure1 = figure(1);
    subplot(3,3,(3*(i-1)+1))
    plot(t, y(i,:),'Color',  [0.43, 0.58, 0.85]);
    hold on
    xline(t0/1000,'Color', [0.8, 0, 0]);
    xlim([0 13])
        if i == 1
            title('Time Series')
            ylim([-0.3 0.3])
        elseif i == 3
            ylim([-8 8])
        else
            ylim([-6 6])
        end
        if i == 3
            xlabel('Time (s)')
        end
        ylabel('Amplitude')     
        xlim([0 13])
        set(gca,"FontSize",12)
        set(gca, "LineWidth",1.5)
        set(gca, 'Box', 'off')
        set(gca, "Layer", "top")
         
%% Plot signal in Frequency Domain
    figure(1)
    if i==1
    subplot(3,3,(3*(i-1)+2))
    plot(f, y_fft,'Color', [0.43, 0.58, 0.85])  
    hold on
    plot(f,x_fft,'Color',  [0.8, 0, 0, 0.3]); 
    legend('EMG + 0dB noise','Raw EMG','FontSize',8)
    set(legend, 'Box','off')
    xlim([0 500])
    ylabel('Amplitude')
    title('Frequency spectrum')
    ax = gca;
    set(gca,"FontSize",12)
    set(gca, "LineWidth",1.5) 
    set(gca, 'Box', 'off')
    set(gca, "Layer", "top")    
    else
    subplot(3,3,(3*(i-1)+2))
    plot(f, y_fft,'Color',[0.43, 0.58, 0.85])    
    xlim([0 500])
    if i == 3
        xlabel('Frequency (Hz)')
    end
    ylabel('Amplitude')
    set(gca,"FontSize",12)
    set(gca, "LineWidth",1.5)
    set(gca, 'Box', 'off')   
    set(gca, "Layer", "top")
    end   
      figure(1)
      subplot(3,3,(3*(i-1)+3))
      h = histogram(y(i,t0:end));
      h.FaceColor = [0.43, 0.58, 0.85];
      if i == 3
        xlabel('EMG amplitude')
      end
      ylabel('Frequency')
      if i == 1
        title('Histogram')
        xlim([-0.5 0.5])
      else
        xlim([-5 5])
      end   
set(gca,"FontSize",12)
set(gca, "LineWidth",1.5)
set(gca, 'Box', 'off')
set(gca, "Layer", "top")
        

end