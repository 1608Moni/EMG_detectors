             %For each parameter combination compute cost function      
             for q = 1:No_of_combo_params      
                binop    =  output.binop{q};
                t0cap    =  output.t0cap{q};
                %% To Obtain the Wshift to generalise time samples  for computing the factor
                if string(algoname) == "Detector2018" 
                    params = output.params.combo{q};              
                    Wshift = params(3);
                    Wsize  = params(1)*fs;
                    fs1    = fs/Wshift ;
                    t1     = (1/fs1):(1/fs1):output.dataparams.dur;
                elseif string(algoname) == "bonato"
                    Wshift = 2;
                    Wsize  = 0;
                else
                    Wshift = 1;
                    Wsize  = 0;
                end
                %% Compute cost function for N = 50 trails for each parameter combination
                t1 = (Wshift/fs):(Wshift/fs):dur; 
                t = (1/fs):(1/fs):13;
                for p = 1:N
                    binop(find(binop == 0)) = -1;
                    groundtruth(find(groundtruth == 0)) = -1;
                    
                    %% To compute the latency of the burst
                    [lEdge_GT, tEdge_GT] = edge(groundtruth(p,:));
                    [lEdge_Bin, tEdge_Bin] = edge(binop(p,:));
                    if length(lEdge_GT) > length(tEdge_GT)
                       tEdge_GT = [tEdge_GT dur*fs];
                    end                   
                    for h = 1:length(tEdge_GT)
                        t0cap_On(h) = (lEdge_GT(h)-1)+min(find(binop(p,lEdge_GT(h):tEdge_GT(h)) == 1));
                        Latency_On(h) = min(find(binop(p,lEdge_GT(h):tEdge_GT(h)) == 1))-1;
                        if h > 1 
                            t0cap_off(h-1) = (tEdge_GT(h-1)-1)+min(find(binop(p,tEdge_GT(h-1):lEdge_GT(h)) == -1));
                            Latency_Off(h-1) = min(find(binop(p,tEdge_GT(h-1):lEdge_GT(h)) == -1))-1;
                        end                       
                    end
                    
                    if (length(lEdge_GT) == length(tEdge_GT)) && (tEdge_GT(end) ~= (dur*fs)/Wshift)
                        tempVar = (tEdge_GT(end)-1)+min(find(binop(p,tEdge_GT(end):end) == -1));
                        Latency_temp = min(find(binop(p,tEdge_GT(end):end) == -1));
                        t0cap_off = [t0cap_off tempVar];
                        Latency_Off = [Latency_Off Latency_temp];
                    end
                    
                   
                    Avg_Latency_ON(q,p) = mean(Latency_On);
                    Avg_Latency_Off(q,p) = mean(Latency_Off);
                    
                    %% To compute the rFP and rFN
                    [rFP(q,p),rFN(q,p)]= crosscorrcompute(groundtruth(p,tB:Wshift:end),binop(p,(tB/Wshift):end));
                    
                    
                    
                    figure(p)
%                     subplot(2,1,1)
                    stairs(groundtruth(p,:),'LineWidth',1.5);
                    hold on
                    stairs(binop(p,:),'r');
                    hold on                   
                    stem(t0cap_On,binop(p,t0cap_On),'m','LineWidth',1);
                    hold on
                    stem(t0cap_off,-binop(p,t0cap_off),'g','LineWidth',1);
                    hold on
                    stem(lEdge_GT,groundtruth(p,lEdge_GT),'k');
                    hold on
                    stem(tEdge_GT,groundtruth(p,tEdge_GT),'c');
                    ylim([-1.1 1.1])  
                    

                    clear tEdge_GT;
                    clear lEdge_GT;
                    clear t0cap_off;
                    clear t0cap_On;
                    
%                   
                end
            
             end