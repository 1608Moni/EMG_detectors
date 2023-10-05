function params = FuzzyEnt_param(mode,type,SNR,detector,method)
%%
addpath('..\detectors_review_paper\');

params      = struct;
params.dim  = 2;
params.n    = 2;
params.r    = 0.25;
params.tB   = 2000;
params.M    = 500;
if mode == "Test"
    if method == ""
        Optdir          = '..\detectors_review_paper\Optparams\';   
    elseif method == "pulse"
        Optdir          = '..\detectors_review_paper\Optparams\pulse500\Dur13\';
    end
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.W   = optparams.param(1)/2;
    params.h   = optparams.param(2);
else
params.W    = (20:10:100)./2;
params.h    = 1:5;
end
%%
for j = 1:length(params.W)
    for i =1:length(params.h)        
        a{j,i} = [params.W(j),params.h(i)];     
    end
end

params.combo = a;
end