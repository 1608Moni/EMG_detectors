function hodgesmain(EMG,choice)
%% function to run hodges detector over no of trails for different parameter combination
%

%% choose which detector to run 1 - lidierth ; 2 - modifiedlidierth
% prompt          = 'choose detector : 1 - hodges ; 2 - modifiedhodges ';
% choice          = input(prompt,'s');  
detectors       = {'hodges','modifiedhodges'};
mode            = char(EMG.mode);
%% Define parameters for the hodges detector
addpath('..\detectors_review_paper\')
outdir          = strcat('output\',string(mode(1:4)),'\');
mkdir(strcat('process\',string(mode(1:4)),'\'));
processdir      = strcat('process\',string(mode(1:4)),'\');
if choice == '1'
    params = hodges_param(string(mode(1:4)),EMG.param.type,EMG.SNR,detectors{str2num(choice)});
elseif choice == '2'
    params = modifiedhodges_param(string(mode(1:4)),EMG.param.type,EMG.SNR,detectors{str2num(choice)});
end
N               = EMG.param.notrials;
x               = EMG.data;
hodgesOp        = struct();
% To enable plot function 
% prompt          = 'Save output enter 1 else 0: ';
% saveflag        = input(prompt,'s');
plotflag        = 'N';  
processSaveflag = 0;

 
%% Run the detectors for different parameter combination over N trails 
    for j = 1:numel(params.combo)
        params.combo{j}
        for i= 1:N
            % Hodeges Detector
%              figure(200*i); plot(EMG.Groundtruth(i,:),'LineWidth',1.25)
            if choice == '1'
                hodgesOutput = hodges(x(i,:), params.combo{j}, params, EMG.param);
            elseif choice == '2'
                hodgesOutput = modifiedhodges(x(i,:), params.combo{j}, params, EMG.param);
            end            
                    
            % plot the intermediate steps to verify
            if plotflag == "Y"
                plotfunc(hodgesOutput,i,string(detectors{str2num(choice)}),EMG.groundtruth(i,:));
            end
            
            % Save binary o/p and estimated onset seperately for further analysis
            binop(i,:)    = hodgesOutput.binop;
            t0cap(i)      = hodgesOutput.t0cap;

            if processSaveflag == 1
            disp('Internal variable saved')
            %% Save output for each trail and each parameter combination in .mat
            %file
            field      = strcat(EMG.method,EMG.mode,detectors(str2num(choice)),'trail',num2str(i),...
                        'paramcombo',num2str(j),EMG.param.type,'SNR',num2str(round(EMG.SNR)));
            pathname   = fileparts(processdir);
            name       = fullfile(pathname, strcat('Output',field));
            save(name,'-struct','hodgesOutput')
            
            end
        end
    %% Save the output alone without internal variables to analyse.
        Binaryop{j} = binop;
        Onset{j}    = t0cap;       
    end   
    
    %% Saving the output for all parameter combination and all trails in a mat file
        hodgesOp.binop      = Binaryop;
        hodgesOp.t0cap      = Onset;
        hodgesOp.params     = params;
        hodgesOp.dataparams = hodgesOutput.dataparams;
        hodgesOp.dataparams.SNR  = EMG.SNR;
        hodgesOp.dataparams.mode = EMG.mode;

  

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
            name       = fullfile(pathname, strcat('Alpha_pulse500',EMG.method,EMG.mode,'Output',field));
            save(name,'-struct','hodgesOp','-v7.3')    
            disp('filesaved')
        end

end