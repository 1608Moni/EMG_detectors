function lidierthmain(EMG,choice)
%% function to run hodges detector over no of trails for different parameter combination
%

%% choose which detector to run 1 - lidierth ; 2 - modifiedlidierth
% prompt          = 'choose detector : 1 - lidierth ; 2 - modifiedlidierth ';
% choice          = input(prompt,'s');  
detectors       = {'lidierth','modifiedLidierth'};

%% Define parameters for the hodges detector
addpath('..\detectors_review_paper\')
outdir          = strcat('output\',EMG.mode,'\');
processdir      = strcat('process\',EMG.mode,'\');
if choice == '1'
    params = Lidierth_param(EMG.mode,EMG.param.type,EMG.SNR,detectors{str2num(choice)});
elseif choice == '2'
    params = modifiedLidierth_param(EMG.mode,EMG.param.type,EMG.SNR,detectors{str2num(choice)});
end
N               = EMG.param.notrials;
x               = EMG.data;
lidierthOp      = struct();
% To enable plot function 
% prompt          = 'Do you want to plot? Y/N [Y]: ';
plotflag        = 'N';%input(prompt,'s');  

 
%% Run the detectors for different parameter combination over N trails 
    for j = 1:numel(params.combo)
        params.combo{j}
        for i= 1:N
            % lidierth Detector
            if choice == '1'
                lidierthOutput = lidierth(x(i,:), params.combo{j}, params, EMG.param);
            elseif choice == '2'
                lidierthOutput = modifiedlidierth(x(i,:), params.combo{j}, params, EMG.param);
            end
                    
            % plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(lidierthOutput,i,string(detectors{str2num(choice)}));
            end
         
            % Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)   = lidierthOutput.binop;
            t0cap(i)     = lidierthOutput.t0cap;
           

            % Save output for each trail and each parameter combination in .mat
            %file
%             field      = strcat(detectors(str2num(choice)),'trail',num2str(i),...
%                         'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)),'force',num2str((EMG.force)));
%             pathname   = fileparts(processdir);
%             name       = fullfile(pathname, strcat('Output',field));
%             save(name,'-struct','lidierthOutput')
        end
        
      
        %% Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    = t0cap;
                       
    end  
    %% format and save
        lidierthOp.binop      = Binaryop;
        lidierthOp.t0cap      = Onset;
        lidierthOp.params     = params;
        lidierthOp.dataparams = lidierthOutput.dataparams;
        lidierthOp.dataparams.SNR  = EMG.SNR;
        lidierthOp.dataparams.mode = EMG.mode;
        
            if EMG.param.type == "gaussian" || EMG.param.type == "laplacian" 
            field      = strcat(detectors(str2num(choice)),'trail',num2str(N),...
                          EMG.param.type,'dur',num2str(EMG.param.dur),...
                          'SNR',num2str(round(EMG.SNR)));
            elseif EMG.param.type == "BioPhy"
            field      = strcat(detectors(str2num(choice)),'trail',num2str(N),...
                          EMG.param.type,'dur',num2str(EMG.param.dur),...
                          'SNR',num2str(round(EMG.SNR)),'force',num2str((EMG.force)));    
            end
           if plotflag ~= "Y" 
            pathname   = fileparts(outdir);
            name       = fullfile(pathname, strcat(EMG.mode,'Output',field));
            save(name,'-struct','lidierthOp','-v7.3')           
           end
end