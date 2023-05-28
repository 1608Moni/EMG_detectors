function params = SamEntparams(mode,type,SNR,detector)
%% Function to define parameters for sample entropy algorithm
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\pulse500\';
%%

params      = struct;
params.dim  = 2;
params.tB   = 3000;
params.M    = 3000;
if mode == "Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.W  = optparams.param(1);
    params.h  = 1:10;%optparams.param(2);  
    params.rho = optparams.param(3);  
else
params.rho    = 0.5:1:2.5;   % Tolerance for chebyshave distance
params.W      = 50:50:150;     % Window size
params.h      = 1:5;           % threshold
end

%%
for j = 1:length(params.W)
    for i =1:length(params.h)
        for k =1:length(params.rho)
            a{j,i,k} = [params.W(j),params.h(i),params.rho(k)];
        end
    end
end
params.combo = a;
numel(params.combo)
end