function params = FuzzyEnt_param(mode,type,SNR,detector)
%%
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\pulse500\Dur13\';
params      = struct;
params.dim  = 2;
params.n    = 2;
params.r    = 0.25;
params.tB   = 1000;
params.M    = 500;
if mode == "Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.W   = optparams.param(1)*2;
    params.h   = optparams.param(2);
else
params.W    = (10:10:100)./2;
params.h    = 1:5;
end
%%
for j = 1:length(params.W)
    for i =1:length(params.h)        
        a{j,i} = [params.W(j),params.h(i)];     
    end
end

params.combo = a;
params.combo{1}
end