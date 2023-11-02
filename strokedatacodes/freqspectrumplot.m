function [] = freqspectrumplot(rawdata,filteredData,Fs)   
    Nsamps = length(rawdata);
    

    %Do Fourier Transform
    y_fft = abs(fft(rawdata));            %Retain Magnitude
    y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
    f = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for ploto9
    
     %Do Fourier Transform
    y_fft1 = abs(fft(filteredData));            %Retain Magnitude
    y_fft1 = y_fft1(1:Nsamps/2);      %Discard Half of Points
    f1 = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for ploto9
    
    figure
    subplot(1,2,1)
    plot(f, y_fft)
    xlim([0 500])
    xlabel('Frequency (Hz)')
     subplot(1,2,2)
    plot(f1, y_fft1)
    xlim([0 500])
    xlabel('Frequency (Hz)')
end