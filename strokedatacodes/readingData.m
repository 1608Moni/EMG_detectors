clc
clear all
close all

parentFolderPath = 'F:\StrokeData\Data\';
% Get the list of contents in the parent folder
contents = dir(parentFolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

for l = 30:numel(subfolders)
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(parentFolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));
    
    for m = 1:numel(sessionfolders)    
        %% Reading the DAT file
        folderPath = fullfile(parentFolderPath,  PatientfolderName, sessionfolders(m).name );
        files = dir(fullfile(folderPath, '*.dat'));   
        files2 = dir(fullfile(folderPath, '*.mat')); 
        if isempty(files2) == 1
            for j = 1:numel(files)

                filePath = fullfile(folderPath, files(j).name);
                [dat, stat, prm] = load_bcidat(filePath);


                %%
                sampling_rate = prm.SamplingRate.NumericValue;

                if size(dat,2) >= 33
                % subtract the channels
                    dat(:,17:17+7) = dat(:,17:2:end-1) - dat(:,18:2:end-1);
                    % delete the rest
                    dat = dat(:,1:24);
                end
                %%
                trial_rest_end = find(diff(double(stat.TargetCode')) > 0);
                % We use the last 4 seconds of each period
                trial_rest_start = trial_rest_end - 4*sampling_rate-1;

                % Find start and end of the trials (MOVE period)
                trial_mov_start = find([0 diff(double(stat.Feedback'))] > 0);
                trial_mov_end = find(diff(double(stat.Feedback')) < 0);
                fc = 10;
                Fs = sampling_rate;

                %% Designing the notch and HPF 
                %%%%%% Notch filter %%%%%%%%%
                %     fo = 50;
                %     q = 35;
                %     bw = (fo/(Fs/2))/q;
                %     [b,a] = iircomb(Fs/fo,bw,'notch');

                [bh,ah]   = butter(2,fc/(Fs/2),'high');
                %% Read data of 8 channel EMG
                for i = 1:8

                    % EMG_notch(:,i) = filter(b,a,dat(:,i));
                    EMG_hpf(:,i) = filter(bh,ah,dat(:,16+i)); 
                    tr = 1;
                    for k = 1:length(trial_mov_end)
                        if trial_rest_start(k) > 0 && (trial_mov_end(k)- trial_rest_start(k) == mode( trial_mov_end - trial_rest_start))...
                                && (length(trial_rest_end) == length(trial_mov_start))
                            EMGdatatrials(:,tr) = EMG_hpf(trial_rest_start(k):trial_mov_end(k),i);
                            Move_onset = trial_mov_start(k)-trial_rest_start(k);
                            Move_offset = trial_mov_end(k)-trial_rest_start(k);
                            Rest_offset = trial_rest_end(k)-trial_rest_start(k);
                            tr = tr + 1;
                        end

    %                 figure(k)
    %                 plot(EMGdatatrials(:,k) );
    %                 hold on
    %                 xline(trial_rest_start(k)-trial_rest_start(k))
    %                 hold on
    %                 xline(trial_rest_end(k)-trial_rest_start(k))
    %                 hold on
    %                 xline(trial_mov_start(k)-trial_rest_start(k),'r--')
    %                 hold on
    %                 xline(trial_mov_end(k)-trial_rest_start(k),'r--')
                    end
                 EMGdata{i} = EMGdatatrials; 
                 clear EMGdatatrials

                end
                clear EMG_hpf
                EMG.data = EMGdata;
                EMG.params.Move_onset = Move_onset;
                EMG.params.Move_offset = Move_offset;
                EMG.params.Rest_offset = Rest_offset;
                EMG.OrgParams.trial_rest_start = trial_rest_start;
                EMG.OrgParams.trial_rest_end = trial_rest_end;
                EMG.OrgParams.trial_mov_end = trial_mov_end;
                EMG.OrgParams.trial_mov_start = trial_mov_start;
                EMG.OrgParams.stat = stat;
                EMG.OrgParams.prm =prm;

                [~, fileNameWithoutExtension, ~] = fileparts(files(j).name);
                name = fullfile(folderPath, strcat(fileNameWithoutExtension,'.mat'));
                save(name,'-struct','EMG','-v7.3');   
                clear EMG;
            end 
        end
    end
end



