function FuzzyEntmain(EMG,detector)
%% function to run hodges detector over no of trails for different parameter combination
%
mode            = char(EMG.mode);
%% Define parameters for the detector

outdir          = strcat('output\',string(mode(1:4)),'\');
processdir      = strcat('process\',string(mode(1:4)),'\');
addpath('..\detectors_review_paper\')
params          = FuzzEntparams(string(mode(1:4)),EMG.param.type,EMG.SNR,detector);
N               = EMG.param.notrials;
x               = EMG.data;
fuzzEntOp       = struct();
% To enable plot function 
%prompt         = 'Do you want to plot? Y/N [Y]: ';
plotflag        = 'N';%input(prompt,'s');  


%% Run the detectors for different parameter combination over N trails 
     for j = 1:numel(params.combo)
        params.combo{j}
        for i= 1:N
            % Sample Entropy Detector
            FuzzEntOutput = FuzzyEnt(x(i,:), params.combo{j}, params, EMG.param);
            
                    
            % plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(FuzzEntOutput,j,detector);
            end
         
            % Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)   = FuzzEntOutput.binop;
            t0cap(i)     = FuzzEntOutput.t0cap;

            % Save output for each trail and each parameter combination in .mat
            %file
%             field      = strcat('FuzzEnt','trail',num2str(i),...
%                         'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)));
%             pathname   = fileparts(processdir);
%             name       = fullfile(pathname, strcat('Output',field));
%             save(name,'-struct','FuzzEntOutput')
         end
        
 
        %% Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    = t0cap;                 
     end   
    
    %% format
        fuzzEntOp.binop      = Binaryop;
        fuzzEntOp.t0cap      = Onset;
        fuzzEntOp.params     = params;
        fuzzEntOp.dataparams = FuzzEntOutput.dataparams;
        fuzzEntOp.dataparams.SNR  = EMG.SNR;
        fuzzEntOp.dataparams.mode = EMG.mode;
        
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
            name       = fullfile(pathname, strcat('Alpha_pulse500',EMG.method,EMG.mode,'Output',field));
            save(name,'-struct','fuzzEntOp','-v7.3')   
          end
end