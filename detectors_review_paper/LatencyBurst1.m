function [LatencyParams] = LatencyBurst1(groundtruth, binop,dur,fs,Wshift)
                  
                    t0cap_off = [];
                    t0cap_On  = [];
                    Compute_latoff = 1;
                    Compute_laton = 1;
                    
                     %% To compute the latency of the burst
                    [lEdge_GT, tEdge_GT] = edge(groundtruth);
                  
                    if isempty(lEdge_GT) == 1
                        disp('No leading edge found')
                        t0cap_On = 0;
                        Latency_On = 0; 
                        Compute_laton = 0;
                    end
                    
                     if isempty(tEdge_GT) == 1
                        disp('No trailing edge found')
                        Compute_latoff = 0; 
                        t0cap_off = 0;
                        Latency_Off = 0; 
                     end                 
                   
                    %% To introduce condition to check till the end of the trial 
                    tEdge_GT = [tEdge_GT dur*fs];
                    
                    
                    for h = 1:length(lEdge_GT)                      %%
                        if Compute_laton == 1
                            if isempty (find(binop(lEdge_GT(h):tEdge_GT(h)) == 1)) ~=1
                                t0cap_On(h) = (lEdge_GT(h)-1)+min(find(binop(lEdge_GT(h):tEdge_GT(h)) == 1));
                                Latency_On(h) = min(find(binop(lEdge_GT(h):tEdge_GT(h)) == 1))-1;
                            end
                        end
                    end
                    
                    if Compute_latoff == 1
                            % To compute the latency off for the last pulse
                            % in a trial
                            if length(lEdge_GT) >  1 
                                lEdge_GT = [lEdge_GT(2:end) dur*fs];
                            else
                                lEdge_GT = dur*fs;
                            end
                            for i = 1:length(tEdge_GT)-1
                                if isempty (find(binop(tEdge_GT(i):lEdge_GT(i)) == -1)) ~=1
                                t0cap_off(i) = (tEdge_GT(i)-1)+min(find(binop(tEdge_GT(i):lEdge_GT(i)) == -1));
                                Latency_Off(i) = min(find(binop(tEdge_GT(i):lEdge_GT(i)) == -1))-1;                         
                                end
                            end
                    end
                    
                    %%
                  
                    
                    if isempty(t0cap_off) == 1 
                        t0cap_off = NaN;
                        Latency_Off = NaN;
                        disp('Offset not detected')
                    end
                   
                    %%
                    
                    if isempty(t0cap_On) == 1
                        t0cap_On = NaN;
                        Latency_On = NaN;
                        disp('Onset not detected')
                    end
                    

%%
                     LatencyParams.lEdge_GT        = lEdge_GT; 
                     LatencyParams.tEdge_GT        = tEdge_GT;
                     LatencyParams.Latency_On      = Latency_On;
                     LatencyParams.Latency_Off     = Latency_Off;
                     LatencyParams.t0cap_On        = t0cap_On;
                     LatencyParams.t0cap_off       = t0cap_off;
                     LatencyParams.Avg_Latency_ON  = mean(Latency_On);
                     LatencyParams.Avg_Latency_Off = mean(Latency_Off);
                     
                     %% Computing f_delT considering the average latency on and off < 250 ms
                      if (0 <=LatencyParams.Avg_Latency_ON ) && (LatencyParams.Avg_Latency_ON  <= 250)        % condition for 100 ms
                        f_delT_ON = (LatencyParams.Avg_Latency_ON /250);
                      else
                        f_delT_ON = 1;
                      end
                     
                       if (0 <=LatencyParams.Avg_Latency_Off) && (LatencyParams.Avg_Latency_Off  <= 250)        % condition for 100 ms
                        f_delT_Off = (LatencyParams.Avg_Latency_Off/250);
                       else
                        f_delT_Off = 1;
                       end
                      
                       LatencyParams.f_delT_ON =f_delT_ON;
                       LatencyParams.f_delT_Off =f_delT_Off;
                     
                     clear tEdge_GT;
                     clear lEdge_GT;
                     clear t0cap_off;
                     clear t0cap_On;
end