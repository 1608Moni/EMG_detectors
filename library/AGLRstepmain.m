function AGLRstepmain(EMG,choice)
%% function to run AGLR-G and AGLR-L detector over Ntrail = 50 for each parameter combination
%

detectors       = {'AGLRstep','AGLRstepLaplace'};
%% Define parameters for the detector
addpath('..\detectors_review_paper\')
outdir          = strcat('output\');
processdir      = strcat('process\',EMG.mode,'\');
if choice == '1'
    params = AGLRstep_params(EMG.mode,EMG.param.type,EMG.SNR,detectors{str2num(choice)});
elseif choice == '2'
    params = AGLRstepLaplace_params(EMG.mode,EMG.param.type,EMG.SNR,detectors{str2num(choice)});
end
N               = EMG.param.notrials;
x               = EMG.data;
AGLRstepOp      = struct();
plotflag        = 'N';

 
%% Run the detectors for different parameter combination over N trails 
    for j = 1:numel(params.combo)
        disp(strcat('paramters : ', num2str(params.combo{j})));
        for i= 1:N
            if choice == '1'
                % AGLR-G
                AGLRstepOutput = AGLRstep(x(i,:), params.combo{j}, params, EMG.param);
            elseif choice == '2'
                % AGLR-L
                AGLRstepOutput = AGLRstepLaplace(x(i,:), params.combo{j}, params, EMG.param);
            end
                    
            %% plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(AGLRstepOutput,j,string(detectors{str2num(choice)}));
            end
         
            %% Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)    = AGLRstepOutput.binop;
            t0capon(i)    = AGLRstepOutput.t0capon;
            t0capoff(i)   = AGLRstepOutput.t0capoff;

            %% Save output for each trail and each parameter combination in .mat
%             field      = strcat(detectors(str2num(choice)),'trail',num2str(i),...
%                         'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)),'force',num2str((EMG.force)));
%             pathname   = fileparts(processdir);
%             name       = fullfile(pathname, strcat('Output',field));
%             save(name,'-struct','AGLRstepOutput')
        
        end              
        %% Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    =  t0capon;  
        Offset{j}   = t0capoff;
    end
    
    %% Format and save as mat file for all combination all trials
     AGLRstepOp.binop      = Binaryop;
     AGLRstepOp.t0capON    = Onset;
     AGLRstepOp.t0capOFF   = Offset;
     AGLRstepOp.params     = params;
     AGLRstepOp.dataparams = AGLRstepOutput.dataparams;
     AGLRstepOp.dataparams.SNR  = EMG.SNR;
     AGLRstepOp.dataparams.mode = EMG.mode;   
        
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
        save(name,'-struct','AGLRstepOp','-v7.3') 
     end
end