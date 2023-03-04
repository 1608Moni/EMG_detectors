function [hodgesOutput] = hodges_opt(EMG)
%% Function to run the hodges algorithm for different parameter combination over N trials
%
%

%% Define parameters for hodeges detector
params      = hodges_param(); 
hodgeOutput = struct();
t           = (1/emg_param.fs):(1/emg_param.fs):emg_param.dur;



for p=1:numel(params.combo)
                   
        % Initial the parameters
        temp_var = parmas.combo{p};
        W        = temp_var(2);
        W_size   = temp_var(1);
        fc       = temp_var(3);     
        bin_op   = zeros(size(EMG.data,1),length(t));
        
        % designing the LPF based on the parameter
        [b,a] = butter(2,fc/(EMG.param.fs/2));
    
        for q = 1:(size(EMG.data,1))
                  
            y_mean   = zeros(1,length(t));
            k=1;
            for i=1:length(t)               

                if i >=tB
            
                    if i == tB
                
                    % signal conditioning (getting y) 
                    EMG_rectb = abs(x(q,i-M+1:i));      


                    %butterworth lpf with order = 6 

                    EMG_lpfb = filter(b,a,EMG_rectb);      

                     % Threshold


                    muo_0 = mean(EMG_lpfb);
                    stdv_0 = std(EMG_lpfb);             


                    h=muo_0 + W*stdv_0; 
                end  
                
                j=1;
                if i-W_size >= tB
                    
                     EMG_rect = abs(x(q,i-W_size+1:i));
                     
                     EMG_lpf = filter(b,a,EMG_rect);  
                     
                     
                     % Moving Avereage filter
                    
                        y_mean(i) = (1/W_size)*sum(EMG_lpf);
%                         
%                         close all
                          figure
                          hold on
                          plot()
%                         figure
%                         subplot(3,1,1)
%                         plot(x(1,1:i))
%                         title('Raw Signal (till current time)')
%                         
%                         subplot(3,1,2)
%                         plot(EMG_rectb)
%                         title('Rectified signal (Baseline)')
%                         subplot(3,1,3)
%                         plot(EMG_lpfb)
%                          title('low pass filter (Baseline)')
%                         hold on
%                         yline(muo_0,'r')
%                         hold on
%                        yline(muo_0+stdv_0,'r--')
%                         hold on
%                         yline(h,'b')
%                         legend('lpf','mean','stdv','threshold')
%                         
%                         figure
%                         subplot(2,1,1)
%                         plot(EMG_rect)
%                         title('Rectified signal (current window)')
%                         subplot(2,1,2)
%                         plot(EMG_lpf)
%                         title('lpf signal (current window)')
%                         hold on
%                         yline(muo_0,'r')
%                         hold on
%                         yline(muo_0+stdv_0,'r--')
%                         hold on
%                         yline(h,'b')
%                         legend('lpf','mean','stdv','threshold')
%                         
                 
                     % Test function 
                
                        g(i) = (y_mean(i)-muo_0)/stdv_0;
                

                        if g(i) > h
                            t_a(k)=i;
                            bin_op(q,i) = 1;
                            k=k+1;
                        else
                            t_a(k) = 0;
                            k=k+1;
                        end
                
                end
           
         end 
        end

         
        % To determine onset for each trail
        flag=1;
        ta=min(t_a(t_a > 0));
         if  (isempty( find(ta,1) ) == 1)
                t0_cap(q) = NaN; 
                flag = 0;
                d=['t0 not estimated for paraeters:',num2str(combo{p})];
                disp(d);

         else
                t0_cap(q) = ta;
         end
      

%             figure
% %             subplot(3,1,1)
%             subplot(2,2,1)
%             plot (EMG_rectb);
%             legend('rectified EMG')
%             subplot(2,2,2)
%             plot (EMG_lpfb);
%             hold on
%             xline(t0)
%             hold on
%             xline(t0_cap(q),'r--')
%             title('hodges method')
%             legend('LPF EMG signal','Actual Onset','Estimated Onset')
%            
            figure
            subplot(3,1,1)
            plot(t,x(p,:))
            hold on
            xline(t0)
            hold on
            xline(t0_cap(q),'r--')
             hold on
            yline(muo_0,'r')
            hold on
            yline(muo_0+stdv_0,'g')
            hold on
            yline(h,'r--')
            legend('Raw Emg','Actual Onset','Estimated Onset','mean','stdv','threshold')
            subplot(3,1,2)
            plot(t,y_mean)
            yline(muo_0,'r')
            hold on
            yline(muo_0+stdv_0,'g')
            hold on
            yline(h,'r--')
            legend('Moving Avg','mean','stdv','threshold')
            subplot(3,1,3)
            plot(t,g)
            hold on
            xline(t0)
            hold on
            xline(t0_cap(q),'r--')
            hold on
            yline(muo_0,'r')
            hold on
            yline(muo_0+stdv_0,'g')
            hold on
            yline(h,'r--')
            legend('test func','Actual Onset','Estimated Onset','mean','stdv','threshold')
           
            figure
            stem(bin_op(q,:))
            hold on
            xline(t0)
            hold on
            xline(t0_cap(q),'r--')
            legend('binary output')
% %            
            
            

    end    
    
    binaryop{p} = bin_op;
    Onset{p} = t0_cap;
    
    num2str(combo{p})
   
end
        
        output.binop = binaryop;
        output.t0cap = Onset;
    
end