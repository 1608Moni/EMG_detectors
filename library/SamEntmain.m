function SamEntmain(EMG,detector)
%% function to run hodges detector over no of trails for different parameter combination
%

%% Define parameters for the detector
outdir          = strcat('output\',EMG.mode,'\');
processdir      = strcat('process\',EMG.mode,'\');
addpath('..\detectors_review_paper\')
params          = SamEntparams(EMG.mode,EMG.param.type,EMG.SNR,detector);
N               = EMG.param.notrials;
x               = EMG.data;
SamEntOp        = struct();
% To enable plot function 
%prompt         = 'Do you want to plot? Y/N [Y]: ';
plotflag        = 'Y';%input(prompt,'s');  

 
%% Run the detectors for different parameter combination over N trails 
    for j = 1:numel(params.combo)
        params.combo{j}
        for i= 1:N
            % Sample Entropy Detector
            SamEntOutput = SamEnt(x(i,:), params.combo{j}, params, EMG.param);
            
                    
            % plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(SamEntOutput,j,detector);
            end
         
            %% Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)   = SamEntOutput.binop;
            t0cap(i)     = SamEntOutput.t0cap;
       

            % Save output for each trail and each parameter combination in .mat
            %file
%             field      = strcat('SamEnt','trail',num2str(i),...
%                         'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)));
%             pathname   = fileparts(processdir);
%             name       = fullfile(pathname, strcat('Output',field));
%             save(name,'-struct','SamEntOutput')
        end

        %% Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    = t0cap;

    end  
    
    %%
        SamEntOp.binop      = Binaryop;
        SamEntOp.t0cap      = Onset;
        SamEntOp.params     = params;
        SamEntOp.dataparams = SamEntOutput.dataparams;
        SamEntOp.dataparams.SNR  = EMG.SNR;
        SamEntOp.dataparams.mode = EMG.mode;
        
       if EMG.param.type == "gaussian" || EMG.param.type == "laplacian" 
            field      = strcat(char(detector),'trail',num2str(N),...
                          EMG.param.type,'dur',num2str(EMG.param.dur),...
                          'SNR',num2str(round(EMG.SNR)));
          elseif EMG.param.type == "BioPhy"
            field      = strcat(char(detector),'trail',num2str(N),...
                          EMG.param.type,'dur',num2str(EMG.param.dur),...
                          'SNR',num2str(round(EMG.SNR)),'force',num2str((EMG.force)));    
          end
          if plotflag ~= "Y" 
            pathname   = fileparts(outdir);
            name       = fullfile(pathname, strcat(EMG.mode,'Output',field));
            save(name,'-struct','SamEntOp','-v7.3')   
          end                
end