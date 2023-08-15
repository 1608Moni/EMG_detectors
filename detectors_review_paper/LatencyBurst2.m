function [LatencyParams] = LatencyBurst2(groundtruth, binop,dur,fs,Wshift)
                  
                    t0cap_off = [];
                    t0cap_On  = [];
                    Compute_latoff = 1;
                    Compute_laton = 1;
                    
                     %% To compute the latency of the burst
                    [lEdge_GT, tEdge_GT] = edge(groundtruth);
                    [lEdge_binop, tEdge_binop] = edge(binop);
                    
                    %%
%                     lEdge_GT = lEdge_GT/Wshift;
%                     tEdge_GT = tEdge_GT/Wshift;
%                     lEdge_binop = lEdge_binop/Wshift;
%                     tEdge_binop = tEdge_binop/ Wshift;
                  
                    if isempty(lEdge_GT) == 1
                        if isempty(lEdge_binop) == 1 
                            disp('No leading edge found')
                            t0cap_On = 0;
                            Latency_On = 0; 
                            Compute_laton = 0;
                            f_delT_ON = 0;
                        else
                            t0cap_On = NaN;
                            Latency_On = NaN; 
                            Compute_laton = 0;
                            f_delT_ON  = NaN;
                        end
                    end
%                     
                     if isempty(tEdge_GT) == 1 && isempty(lEdge_GT) == 0
                        if isempty(tEdge_binop) == 1 
                            disp('No trailing edge found')
                            Compute_latoff = 0; 
                            t0cap_off = 0;
                            Latency_Off = 0; 
                            f_delT_Off = 0;                                
                        else
                            Compute_latoff = 0; 
                            t0cap_off = NaN;
                            Latency_Off = NaN; 
                            f_delT_Off = NaN;
                        end
                     end                 
 %%                                                       
                    for h = 1:length(lEdge_GT)                      %%
                        if Compute_laton == 1
                            if length(lEdge_GT) ~= length(tEdge_GT)
                                tEdge_GT = [tEdge_GT dur*fs];
                            end
                            if isempty (find(binop(lEdge_GT(h):tEdge_GT(h)) == 1)) ~=1
                                t0cap_On(h) = (lEdge_GT(h)-1)+min(find(binop(lEdge_GT(h):tEdge_GT(h)) == 1));
                                Latency_On(h) = (min(find(binop(lEdge_GT(h):tEdge_GT(h)) == 1))-1)*Wshift;
                              %%  
                                if (0 <= Latency_On(h) ) && (Latency_On(h)  <= 125)        % condition for 100 ms
                                    f_delT_ON(h) = (Latency_On(h) /125);
                                else
                                    f_delT_ON(h) = 1;
                                end
                            end
                        end
                    end
                    
                     if Compute_latoff == 1
                            % To compute the latency off for the last pulse
                            % in a trial
%                              if length(lEdge_GT) >  1 
                                lEdge_GT = [lEdge_GT(2:end) dur*fs/Wshift];
%                              else
%                                 lEdge_GT = [] 
%                              end
%                             
                            for i = 1:length(tEdge_GT)
                                if isempty (find(binop(tEdge_GT(i):lEdge_GT(i)) == 0)) ~=1
                                t0cap_off(i) = (tEdge_GT(i)-1)+min(find(binop(tEdge_GT(i):lEdge_GT(i)) == 0));
                                Latency_Off(i) = (min(find(binop(tEdge_GT(i):lEdge_GT(i)) == 0)))*Wshift;
                                    if (0 <= Latency_Off(i)) && (Latency_Off(i)  <= 125)        % condition for 100 ms
                                        f_delT_Off(i) = (Latency_Off(i)/125);
                                    else
                                        f_delT_Off(i) = 1;
                                    end
                                end
                            end
                    end
                    
                    %%
                  
                    
                    if isempty(t0cap_off) == 1 
                        t0cap_off = NaN;
                        Latency_Off = NaN;
                        f_delT_Off = NaN;
                        disp('Offset not detected')
                    end
                   
                    %%
                    
                    if isempty(t0cap_On) == 1
                        t0cap_On = NaN;
                        Latency_On = NaN;
                        f_delT_ON = NaN;
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
                     
                     %% Computing f_delT considering the average latency on and off < 125 ms
                    
                     
                      
                      
                       LatencyParams.f_delT_ON = mean(f_delT_ON);
                       LatencyParams.f_delT_Off =mean(f_delT_Off);
                     
                     clear tEdge_GT;
                     clear lEdge_GT;
                     clear t0cap_off;
                     clear t0cap_On;
end