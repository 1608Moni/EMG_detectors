function params = AGLRstep_params(mode,type,SNR,detector)
%% function to define parameters for AGLRstep
%
%
%% Define varaible for the script
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\'; 
params        = struct;
params.tB     = 3000;
params.M      = 3000;

%%
if mode == "Test"
datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.Wsize   = optparams.param(1);
    params.weight  = optparams.param(2);  
else
params.Wsize  = 0.1:0.05:0.5;
params.weight = 1:5;
end
%% Create cell array forming different parameter combination
for i =1:length(params.Wsize)
    for k =1:length(params.weight)
        a{i,k} = [params.Wsize(i),params.weight(k)];
    end
end

params.combo = a;
end