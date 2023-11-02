clc
clear all
% close all

DatafolderPath = 'E:\outputData\';
addpath '    D:\EMG detectors\library'
 
contents = dir(DatafolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

Datatypes = ["EMG","Noise"];
Detectors = ["modifiedhodges"];

No_of_paramCombo = 190;
MaxSepAllcombo = [];
b = 1;
noparams = [26];%[7,8,15,16,24,25,34,35,43,44,53,54,63,64,72,73,82,83];
for i = 1:length(noparams)
   l=2;
 
    % for l = 1:length(subfolders)
          tr = 1;
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
                    index11 = find(string(fileName) == strcat('Alpha',Datatypes(1),Detectors(1)));
                    % load the data
                    filePath_data = fullfile(folderPath, files(index11).name);
                    EMGdata = load(filePath_data);  

                    index2 = find(string(fileName) == strcat('Alpha',Datatypes(2),Detectors(1)));
                    % load the data
                    filePath_Noise = fullfile(folderPath, files(index2).name);
                    Noisedata = load(filePath_Noise);

                    %% For each parameter combination

                        for j = 1:size(EMGdata.output,2)
                            BinaryOpData = EMGdata.output{noparams(i),j}.binop;     
                            BinaryOpNoise = Noisedata.output{noparams(i),j}.binop;
                            ProbDetEMG(l,tr) = probdetection(BinaryOpData);
                            ProbDetNoise(l,tr) = probdetection(BinaryOpNoise);
%                         Pd{l,tr} = ProbDet;
                           
    %                     %% Plot binaryop and prob detection
                        % if tr == 33
                        fig= figure;
                        fig.Position = [1 1 1280 647.3333];
                        subplot(2,1,1)
                        plot(EMGdata.output{noparams(i),j}.emgrect,'Color', [0.8 0.85 1])
                        hold on
                        plot(EMGdata.output{noparams(i),j}.testfunc,'m','LineWidth',1.5);
                        hold on
                        plot(max(EMGdata.output{noparams(i),j}.emgrect).*EMGdata.output{noparams(i),j}.binop,'k');
                        hold on
                        yline(EMGdata.output{noparams(i),j}.h,'r--');
                        txt = {strcat('ProbDet = ',num2str(round(ProbDetEMG(l,tr),3)))};
                        text(1.5,0.8,txt,'FontSize',12)
                        title(Datatypes(1))
                        subplot(2,1,2)
                        plot(Noisedata.output{noparams(i),j}.emgrect,'Color', [0.8 0.85 1]);
                        hold on
                        plot(Noisedata.output{noparams(i),j}.testfunc,'m','LineWidth',1.5);
                        hold on
                        plot(max(Noisedata.output{noparams(i),j}.emgrect).*Noisedata.output{noparams(i),j}.binop,'k');
                        hold on
                        yline(Noisedata.output{noparams(i),j}.h,'r--');
                        txt = {strcat('ProbDet = ',num2str(round(ProbDetNoise(l,tr),3)))};
                        text(1.5,0.8,txt,'FontSize',12)
                        txt = {strcat('Ratio = ',num2str(ProbDetNoise(l,tr)*log(ProbDetNoise(l,tr)/ProbDetEMG(l,tr))))};
                        text(1.5,10,txt,'FontSize',12)
                        title(Datatypes(2))
                        sgtitle(strcat('Combo',num2str(i),sessionfolders(m).name,'Trial',num2str(j)),'Interpreter','none');
                        pause(2)
                        close all;
                        % NormaliseH1(j,:) = (EMGdata.output{i,j}.testfunc-EMGdata.output{i,j}.mean_baseline)/EMGdata.output{i,j}.stdv_baseline;
                        % NormaliseH0(j,:) = (EMGdata.output{i,j}.testfunc-EMGdata.output{i,j}.mean_baseline)/EMGdata.output{i,j}.stdv_baseline;
                        % 
% 
%                           fig1 = figure;
% %                         figure(1)
%                           fig1.Position = [120.3333 208.3333 1.0467e+03 410.6667];
%                           % subplot(1,2,1)
%                           histogram(EMGdata.output{noparams(i),j}.testfunc(2002:end),'BinWidth',0.5,'Displaystyle','stairs')
% %                         hold on
% %                         xline(1,'r--')
%                           hold on
%                           xline(EMGdata.output{noparams(i),j}.h,'r--')
% %                         hold on
% %                         xline(EMGdata.output{i,j}.mean_baseline, 'r')
% %                         hold on
% %                         xline(Noisedata.output{i,j}.stdv_baseline , 'g')
% % %     xline(H0stats(j,3),'r--')
%                             hold on; 
%                             histogram(Noisedata.output{noparams(i),j}.testfunc(2002:end),'BinWidth',0.05,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4])
%                             hold on
%                             xline(Noisedata.output{noparams(i),j}.h,'k--')
% %                          hold on
% %                         xline(Noisedata.output{i,j}.mean_baseline, 'k')
% %                         hold on
% %                         xline(Noisedata.output{i,j}.stdv_baseline , 'y')
% % %                         title(strcat('H0',num2str(cutoff(j))))
%                          legend('H1','h_H1','H0','h_H0');
%                            xlim([0 50])
%                             ylim([0 800])
%                          subplot(1,2,2)
%                         histogram(EMGdata.output{i,j}.testfunc(2002:end),'BinWidth',0.05,'Displaystyle','stairs')
%                         hold on
%                         xline(EMGdata.output{i,j}.h,'r--')
% %     xline(H0stats(j,3),'r--')
%                         hold on; 
%                         histogram(Noisedata.output{i,j}.testfunc(2002:end),'BinWidth',0.05,'Displaystyle','stairs','EdgeColor',[0.6 0.2 0.4])
%                         hold on
%                         xline(Noisedata.output{i,j}.h,'k--')
% %                         title(strcat('H0',num2str(cutoff(j))))
%                         legend('H1','h_H1','H0','h_H0');
%                         name = 'ModifiedhodgesP2filtercharalpha2';
%                         export_fig(char(name),'-pdf','-append',figure(b));
%                          pause(1)
%     %                     close all
%                          EMGdata.output{i, j}.paramcombo
                        % end
                         b = b+1; 
                         tr = tr+1;
                        end
            end
           disp(['Completed computing seperation for session:', num2str(m)]);
        end
        disp(['Completed computing seperation :', PatientfolderName, 'Combo', num2str(noparams(i))]);
    % end
    PdEMG = ProbDetEMG';
    PdNoise = ProbDetNoise';
    
    MaxSep = [PdEMG(:) PdNoise(:)];
    MaxSepAllcombo = [MaxSepAllcombo MaxSep];
    paramcombo{i} = EMGdata.output{i, 1}.paramcombo;   
%     figure(1)
%     hold on
%     boxplot(MaxSep);
end
% 
%  Probdet.MaxSepAllcombo = MaxSepAllcombo;
%  Probdet.paramcombo = paramcombo; 
%  save('D:\EMG detectors\detectors_review_paper\Probdetection\lidierthPdALLcombo.mat','-struct','Probdet','-v7.3');
