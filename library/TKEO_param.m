function params = TKEO_param(mode,type,SNR,detector)
%% Function to define parameters for TKEO processing
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\';
params        = struct;
params.M      = 3000;
params.tB     = 3000; 
if mode == "Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.fc_h   = optparams.param(1);
    params.Wsize  = optparams.param(2);  
    params.weight = optparams.param(3);  
    params.T1     = optparams.param(4);
else
params.fc_h   = 5:5:30;        % to remove motion artefacts which is mostly below 20Hz
params.Wsize  = 0.1:0.1:0.5;   % Window size for moving avg (smoothening)
params.weight = 1:5;           % Weight to determine the threshold. 
params.T1     = [30,60,100];   % Double threshold to check only the active state duration
end
%%
for j = 1:length(params.fc_h)
    for i =1:length(params.Wsize)
        for k =1:length(params.weight)
            for l =1:length(params.T1)
            a{j,i,k,l} = [params.fc_h(j),params.Wsize(i),params.weight(k),params.T1(l)];
            end
        end
    end
end
params.combo = a;

numel(params.combo)
end