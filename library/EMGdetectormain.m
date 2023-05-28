function EMGdetectormain(EMG,detector)
%% function to run the detector in (Sivakumar et.al) no of trails for different parameter combination
%

mode            = char(EMG.mode);
%% Define parameters for the detector
outdir          = strcat('output\',string(mode(1:4)),'\');
processdir      = strcat('process\',string(mode(1:4)),'\');
addpath('..\detectors_review_paper\')
mode            = char(EMG.mode);
N               = EMG.param.notrials;
x               = EMG.data;
detectorOp      = struct();
params          = EMGdetector_param(string(mode(1:4)),EMG.param.type,EMG.SNR,detector);
% To enable plot function 
%prompt          = 'Do you want to plot? Y/N [Y]: ';
plotflag        = 'N';%input(prompt,'s');  
% binop           = zeros(N,EMG.param.dur*EMG.param.fs);
 
%% Run the detectors for different parameter combination over N trails 
    for j = 1:numel(params.combo)
        params.combo{j}
        for i= 1:N
            % RMS Detector
            detectorOutput   = EMGdetector(x(i,:), params.combo{j}, params, EMG.param);
                                       
            % plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(detectorOutput ,j,detector);
            end
%             
            % Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)   = detectorOutput.binop;
            t0cap(i)     = detectorOutput.t0cap;
% 
% 
          %  Save output for each trail and each parameter combination in .mat
%         
%             field      = strcat('Detector2018New','trail',num2str(i),...
%                         'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)));%,'force',num2str((EMG.force))
%             pathname   = fileparts(processdir);
%             name       = fullfile(pathname, strcat('Output',field));
%             save(name,'-struct','detectorOutput')
% %          pause(2)
%          close all
        end
        close all 
%        
        % Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    = t0cap;
        clear binop        
    end
        
        detectorOp.binop      = Binaryop;
        detectorOp.t0cap      = Onset;
        detectorOp.params     = params;
        detectorOp.dataparams = detectorOutput.dataparams;
        detectorOp.dataparams.SNR  = EMG.SNR;
        detectorOp.dataparams.mode = EMG.mode;
% 
        if EMG.param.type == "gaussian" || EMG.param.type == "laplacian" 
            field      = strcat('Detector2018','trail',num2str(N),...
                          EMG.param.type,'dur',num2str(EMG.param.dur),...
                          'SNR',num2str(round(EMG.SNR)));
        elseif EMG.param.type == "BioPhy"
            field      = strcat('Detector2018','trail',num2str(N),...
                          EMG.param.type,'dur',num2str(EMG.param.dur),...
                          'SNR',num2str(round(EMG.SNR)),'force',num2str((EMG.force)));    
        end
        if plotflag ~= "Y" 
        pathname   = fileparts(outdir);
%         name       = fullfile(pathname, strcat('Constant',EMG.method,EMG.mode,'Output',field));
        %%to save the parameter as in the paper
        name       = fullfile(pathname, strcat('Alpha_pulse500',EMG.mode,'Output',field));
        save(name,'-struct','detectorOp','-v7.3')               
        end
end