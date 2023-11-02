clc
clear all
close all

% addpath 'F:'
DatafolderPath = '..\StrokeData\NewData\';
% NewDatafolder = 'F:\StrokeData\filterddatanew\';
% addpath 'D:\EMG detectors\detectors_review_paper'

contents = dir(DatafolderPath);
subfolders = contents([contents.isdir]);
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

tr = 1;
for l = 1:length(subfolders)
    PatientfolderName = subfolders(l).name;
    Foldcontents = dir(fullfile(DatafolderPath,  PatientfolderName));
    sessionfolders = Foldcontents([Foldcontents.isdir]);
    sessionfolders = sessionfolders(~ismember({sessionfolders.name}, {'.', '..'}));   
    m = 1;
    while m <= length(sessionfolders)  
%     for m = 1:length(sessionfolders)           
         folderPath = fullfile(DatafolderPath,  PatientfolderName, sessionfolders(m).name );
         files = dir(fullfile(folderPath, '*.mat')); 
         if isempty(files) == 0 && numel(files) < 2
             filePath = fullfile(folderPath, files(1).name);
                EMGdata = load(filePath);
                fieldList = fieldnames(EMGdata);
                EMGdata.finalEMGdata = EMGdata.(fieldList{1});
                k = 1;
                while k <= size(EMGdata.finalEMGdata,2)
                             
%                              fieldList_data = fieldnames(EMGdata.finalEMGdata{1,k});
                             if isfield(EMGdata.finalEMGdata{1,k}, 'filteredData') 
                                EMGdata.finalEMGdata{1,k}.filterdata = EMGdata.finalEMGdata{1,k}.filteredData;
                             end
                            
                             figure('Position',[9.6667 266.3333 1272 373.3334]);
                             plot(EMGdata.finalEMGdata{1,k}.filterdata);
                             hold on
                             l1 = xline(2001,'r--');
                             l1.LineWidth = 1.5;
                             hold on
                             l2 = xline(length(EMGdata.finalEMGdata{1,k}.filterdata),'r--');
                             l2.LineWidth = 1;
                             title(strcat('Session',num2str(EMGdata.finalEMGdata{1,k}.session),'_',EMGdata.finalEMGdata{1,k}.file),'Interpreter','none')
 %%
                             fprintf('Press the space bar to mark the trial\n');
                             fprintf('Esc to delete a point \n');
                             fprintf('Enter to finish marking...\n');
                             pause;
                              % Check if the pressed key is the space bar (ASCII code: 32)
                              key = get(gcf, 'CurrentCharacter');
                              if double(key) == 32
                                  ind = 1;
                                  GTpoint = [];
                                  while true 
                                    keypressed = get(gcf, 'CurrentCharacter');
                                    [x_marked, y_marked, button] = ginput(1);
                                   
                                    if double(button) == 27                        
                                       delete(hline(ind-1)); 
                                       GTpoint(ind-1) = [];
                                       ind=ind-1;
                                    else                                     
                                        count = 0;
                                        if isempty(x_marked) == 1
                                            GTpoint = [GTpoint x_marked];
                                            break;
                                        else
                                             if (ind > 1) && (GTpoint(ind-1) > x_marked)
                                              disp('ERROR : Cannot Select point before the prevois point');                                              
                                             elseif x_marked < 2000
                                              disp('ERROR: Mariking in rest phase');
                                             elseif x_marked > length(EMGdata.finalEMGdata{1,k}.filterdata)
                                              disp('ERROR: Marking beyond trial duration')
                                             else
                                                GTpoint(ind) = x_marked;
                                                hold on
                                                hline(ind) = xline(x_marked,'k--');
                                                ind = ind  + 1;
                                             end
                                        end
                                       
                                    end
                                                             
                                  end
                                    EMGdata.finalEMG{1,k}.markedpoints = GTpoint;
                                    EMGdata.finalEMG{1,k}.groundtruth = GetGT(GTpoint, length(EMGdata.finalEMGdata{1,k}.filterdata));
                                    hold on;
                                    stairs(max(EMGdata.finalEMGdata{1,k}.filterdata)*EMGdata.finalEMG{1,k}.groundtruth, 'r','LineWidth',1.5); 
                                    tr = tr + 1;
                              elseif double(key) == 13
                                    GTpoint = [];
                                    EMGdata.finalEMG{1,k}.markedpoints = GTpoint;
                                    EMGdata.finalEMG{1,k}.groundtruth = GetGT(GTpoint, length(EMGdata.finalEMGdata{1,k}.filterdata));           
                                    hold on;
                                    stairs(max(EMGdata.finalEMGdata{1,k}.filterdata)*EMGdata.finalEMG{1,k}.groundtruth, 'r','LineWidth',1.5); 
                                    tr = tr + 1;
%                               else
%                                    return;
%                                   disp('ERROR: NOT VALID INPUT-PRESS ENTER TO CONTINUE');
%                                   while true
%                                       t=1
%                                       key5 = get(gcf,'CurrentCharacter');
%                                         if double(key5) == 13
%                                            disp('Enter pressed');
%                                             break;
%                                         end
%                                   end
                              end
                              disp('Press backspace to repeat the trial')
                              pause;
                              backkey = get(gcf,'CurrentCharacter');
                              if double(backkey) == 8                               
                                % repeat the trials
                                saveflag = 0;
                                k = max(1, k);                                
                                close all
                              else
                                % Move to the next iteration
                                saveflag = 1;
                                k = k + 1;
                                close all
                              end
                              
                              %% save the groundtruth and points selected
                              if saveflag == 1
                                finalfilename = fullfile( folderPath , strcat('GroundTruth',files(1).name));
                                save(finalfilename,'EMGdata');  
                              end
                end
         disp('Press e to exit or Enter to continue')
         fh = figure('name', 'Press a key',...
                'position', [0 0 1 1]);
          pause;
         exitkey = get(fh,'CurrentCharacter');
         double(exitkey)
         if double(exitkey) == 101                               
            close all;
            return;
         else
            close all;
            m = m + 1;
         end       
                
         else
             m = m + 1;
         end
         
    
    end
 end