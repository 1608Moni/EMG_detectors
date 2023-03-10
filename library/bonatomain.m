function bonatomain(EMG,detector)
%% function to run bonato detector over no of trails for different parameter combination
%

%% Define parameters for the detector
outdir          = strcat('output\',EMG.mode,'\');
processdir      = strcat('process\',EMG.mode,'\');
addpath('..\detectors_review_paper\')
params          = Bonato_param(EMG.mode,EMG.param.type,EMG.SNR,detector);
N               = EMG.param.notrials;
x               = EMG.data;
BonatoOp        = struct();
plotflag        = 'N';

 
%% Run the detectors for different parameter combination over N trails 
    for j = 1:numel(params.combo)
        params.combo{j}
        for i= 1:N
            % bonato Detector
            bonatoOutput = bonato(x(i,:), params.combo{j}, params, EMG.param);
            
                    
            % plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(bonatoOutput,i,detector);
            end
         
            % Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)   = bonatoOutput.binop;
            t0cap(i)     = bonatoOutput.t0cap;

            % Save output for each trail and each parameter combination in .mat
            %file
%             field      = strcat('Bonato','trail',num2str(i),...
%                         'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)),num2str((EMG.force)));
%             pathname   = fileparts(processdir);
%             name       = fullfile(pathname, strcat('Output',field));
%             save(name,'-struct','bonatoOutput'         
        end
        
       
        % Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    = t0cap;                       
    end  
        BonatoOp.binop      = Binaryop;
        BonatoOp.t0cap      = Onset;
        BonatoOp.params     = params;
        BonatoOp.dataparams = bonatoOutput.dataparams;
        BonatoOp.dataparams.SNR  = EMG.SNR;
        BonatoOp.dataparams.mode = EMG.mode;

        
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
         name       = fullfile(pathname, strcat(EMG.method,EMG.mode,'Output',field));
         save(name,'-struct','BonatoOp','-v7.3')   
         end
end