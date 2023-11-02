clc
clear all
close all

DatafolderPath = 'E:\outputData\';
addpath '    E:\EMG detectors\library\'
 
contents = dir(DatafolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

Datatypes = ["EMG","Noise"];
Detectors = ["modifiedhodges"];


%%  Get the parameters
    mode = "Train";
    method = "";
    type = "";
    SNR = [];
   paramfuncname = strcat(Detectors(1), '_param');
   paramfunc =  str2func(paramfuncname);
   params = paramfunc(mode,type,SNR,Detectors(1),method);

No_of_paramCombo = numel(params.combo);
MaxSepAllcombo = [];
 b = 1;
% for i = 1:No_of_paramCombo
%      Data_H1 =[];
PdEMG = [];
PdNoise = [];
testfuncEMG = [];
testfuncNoise = [];
% l=2;
for l = 1:length(subfolders)
          % tr = 1;
        PatientfolderName = subfolders(l).name;
        Foldcontents = dir(fullfile(DatafolderPath,  PatientfolderName));
        sessionfolders = Foldcontents([Foldcontents.isdir]);
        sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
       
        for m = 1:length(sessionfolders)    
            folderPath = fullfile(DatafolderPath,  PatientfolderName, sessionfolders(m).name,'output' );
            files = dir(fullfile(folderPath, '*.mat')); 
            if isempty(files) == 0
                 % Search the file of the required detector and datatype 
                for k = 1:length(files)
                    [~, fileName{k}, fileExtension] = fileparts(files(k).name);
                end 
                %% Compute the prob of detection for both onlyrest and move data
        %         for o = 1:length(Datatypes)
                    index11 = find(string(fileName) == strcat('Coarsesearch',Datatypes(1),Detectors(1)));
                    % load the data
                    filePath_data = fullfile(folderPath, files(index11).name);
                    EMGdata = load(filePath_data);  
                    
                    %% Obtaining the binop from all the cell elements
                    nameFieldArray = cellfun(@(s) s.binop  , EMGdata.output, 'UniformOutput', false);
                    % testfuncH1 = cellfun(@(s) s.testfunc  , EMGdata.output(2:5:end,:), 'UniformOutput', false);
                    % get the shift params if its EMGdetector
                    if Detectors(1) == "EMGdetector"
                        Wshift = cellfun(@(x) x(3), params.combo, 'UniformOutput', false);
                        Wshift= cell2mat(Wshift);
                        w = Wshift(:);
                        wnew = repmat(w,[1,size(EMGdata.output,2)]);
                        ProbDetEMG = cellfun(@(x, startIdx) sum(x(:,2002:end),2)/length(x(:,round(2002/startIdx):end),'UniformOutput', false),...
                         nameFieldArray, num2cell(wnew));
                    else
                        ProbDetEMG = cellfun(@(x) sum(x(:,2002:end),2)/length(x(:,2002:end)), nameFieldArray,'UniformOutput', false);
                    end
                  
                    index2 = find(string(fileName) == strcat('Coarsesearch',Datatypes(2),Detectors(1)));
                    % load the data
                    filePath_Noise = fullfile(folderPath, files(index2).name);
                    Noisedata = load(filePath_Noise);
                    
                     %% Obtaining the binop from all the cell elements
                    binopH0 = cellfun(@(s) s.binop  , Noisedata.output, 'UniformOutput', false);
                    % testfuncH0 = cellfun(@(s) s.testfunc  , Noisedata.output(2:5:end,:), 'UniformOutput', false);
                    % get the shift params if its EMGdetector
                    if Detectors(1) == "EMGdetector"
                        Wshift = cellfun(@(x) x(3), params.combo, 'UniformOutput', false);
                        Wshift= cell2mat(Wshift);
                        w = Wshift(:);
                        wnew = repmat(w,[1,size(Noisedata.output,2)]);
                        ProbDetNoise = cellfun(@(x, startIdx) sum(x(:,2002:end),2)/length(x(:,round(2002/startIdx):end),'UniformOutput', false),...
                         binopH0, num2cell(wnew));
                    else
                        ProbDetNoise = cellfun(@(x) sum(x(:,2002:end),2)/length(x(:,2002:end)), binopH0,'UniformOutput', false);
                    end
                   
                    %% For each parameter combination

                        % for j = 1:size(EMGdata.output,2)
                        %     BinaryOpData = EMGdata.output{i,j}.binop;     
                        %     BinaryOpNoise = Noisedata.output{i,j}.binop;
                        %     ProbDetEMG(l,tr) = probdetection(BinaryOpData);
                        %     ProbDetNoise(l,tr) = probdetection(BinaryOpNoise);
%                         Pd{l,tr} = ProbDet;
%                            
%     %                     %% Plot binaryop and prob detection
                        % fig= figure(b);
                        % fig.Position = [1 1 1280 647.3333];
                        % subplot(2,1,1)
                        % plot(EMGdata.output{1,1}.emgrect(1,:),'Color', [0.8 0.85 1])
                        % hold on
                        % plot(EMGdata.output{1,1}.testfunc(1,:),'m','LineWidth',1.5);
                        % hold on
                        % plot(max(EMGdata.output{1,1}.emgrect(1,:)).*EMGdata.output{1,1}.binop(1,:),'k');
                        % hold on
                        % yline(EMGdata.output{1,1}.h(1),'r--');
                        % txt = {strcat('ProbDet = ',num2str(round(ProbDetEMG{1,1}(1),3)))};
                        % text(1.5,0.8,txt,'FontSize',12)
                        % title(Datatypes(1))
                        % subplot(2,1,2)
                        % plot(Noisedata.output{1,1}.emgrect(1,:),'Color', [0.8 0.85 1]);
                        % hold on
                        % plot(Noisedata.output{1,1}.testfunc(1,:),'m','LineWidth',1.5);
                        % hold on
                        % plot(max(Noisedata.output{1,1}.emgrect(1,:)).*Noisedata.output{1,1}.binop(1,:),'k');
                        % hold on
                        % yline(Noisedata.output{1,1}.h(1),'r--');
                        % txt = {strcat('ProbDet = ',num2str(round(ProbDetNoise{1,1}(1),3)))};
                        % text(1.5,0.8,txt,'FontSize',12)
                        % % txt = {strcat('Ratio = ',num2str(ProbDetNoise(l,tr)*log(ProbDetNoise(l,tr)/ProbDetEMG(l,tr))))};
                        % % text(1.5,10,txt,'FontSize',12)
                        % title(Datatypes(2))
                        % sgtitle(strcat('Combo',num2str(i),sessionfolders(m).name,'Trial',num2str(j)),'Interpreter','none');
% %                         name = 'ModifiedhodgesPdetP1';
% %                         export_fig(char(name),'-pdf','-append',figure(b));
% %                          pause(1)
% %     %                     close all
% %                          EMGdata.output{i, j}.paramcombo
% %                         b = b+1; 
                        %   tr = tr+1;
                        % end
            end
           disp(['Completed computing seperation for session:', num2str(m)]);
        PdEMG = [PdEMG ProbDetEMG'];
        PdNoise = [PdNoise ProbDetNoise'];
        % testfuncEMG = [testfuncEMG testfuncH1 ];
        % testfuncNoise =[testfuncNoise testfuncH0 ];
        end
        
        disp(['Completed computing seperation :', PatientfolderName]);
%    end
% if l > 1
%     NoTrialPatient(l) = size(PdEMG,2) - sum(NoTrialPatient) ;
% else
%     NoTrialPatient(l) = size(PdEMG,2);
% end
%%
% 
% b = cell2mat(testfuncNoise);
% for j = 1:size(b,1)
%     figure(1);
%     hold on; 
%     histogram(b(j,:),'BinWidth',0.5,'Displaystyle','stairs')
%     xlim([0 500])
 Probdet.H0 = PdNoise' ;
 Probdet.H1 = PdEMG';
 Probdet.paramcombo = params.combo; 
 Savefilesname = strcat("CoarseSearchPatient1",num2str(l),'modifiedhodges.mat');
 path1 = 'E:\EMG_detectors\detectors_review_paper\Probdetection';
 save(char(fullfile(path1,Savefilesname)),'-struct','Probdet','-v7.3');
 end

% save('testfuncH0alpha2P2.mat','testfuncNoise','-v7.3')
% save('testfuncH1alpha2P2.mat','testfuncEMG','-v7.3')
    % PdEMG = ProbDetEMG';
    % PdNoise = ProbDetNoise';
%     
%     MaxSep = [PdEMG(:) PdNoise(:)];
%     MaxSepAllcombo = [MaxSepAllcombo MaxSep];
%     paramcombo{i} = EMGdata.output{i, 1}.paramcombo;   
%     figure(1)
%     hold on
%     boxplot(MaxSep);
  % end
% 

