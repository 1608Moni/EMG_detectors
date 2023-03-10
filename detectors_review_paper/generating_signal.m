function [Output] = generating_signal(emg_param)
% Function that generates band pass filtered gaussian/laplacian noise 
% using dynamic variance profile 
% x         - Generated Raw EMG data
% emg_param - Parameters to generate EMG data   

    %% Initialising   
    t = (1/emg_param.fs):(1/emg_param.fs):emg_param.dur;
    w = zeros(length(emg_param.SNRs), length(t));
    x = zeros(length(emg_param.SNRs), length(t));

    %% Generating the signal
    [Output] = dynamic_varaince(t, emg_param);

    for i = 1:size(Output.DynVariance,1)
        
        if emg_param.type == "gaussian"
            w(i,:) = sqrt(Output.DynVariance(i,:)).*randn(1,length(t)); 
        elseif emg_param.type == "laplacian"     
            w(i,:) = sqrt(Output.DynVariance(i,:)).*randl(1,length(t)); 
        end       
        %Band-pass filtering
        x(i,:) = BPF(emg_param.p, emg_param.fl, emg_param.fh,...
                 emg_param.fs, w(i,:)); 
             
%         %% plot figure
%         figure(i)
%         subplot(2,1,1)
%         plot(x(i,:),'Color',[0 0 1 0.5])
%         ylim([-5 5])
%         subplot(2,1,2)
%         stairs(Dyn_variance(i,:),'Color',[0.8 0 0 0.1])
%         title(strcat(emg_param.type,"_",'SNR',num2str(round(emg_param.SNRs(i))),"_",'P0', num2str(emg_param.Prob0),...
%             "_",'P1', num2str(emg_param.Prob1)),'Interpreter','none')
    
    end
    Output.data = x;   
end
 

    
    
    
    







