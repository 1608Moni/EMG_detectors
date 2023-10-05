function params = AGLRstepLaplace_param(mode,type,SNR,detector, method)
%% function to define parameters for AGLR-L 
%
%
%%
addpath('..\detectors_review_paper\');

params        = struct;
params.tB     = 2000;
params.M      = 500;

%%
if mode == "Test"
    if method == "step"
        Optdir          = '..\detectors_review_paper\Optparams\';
    elseif method == "pulse"
        Optdir          = '..\detectors_review_paper\Optparams\pulse500\Dur13\';
    end
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.Wsize   = optparams.param(1);
    params.weight  = optparams.param(2);
else
params.Wsize  = 0.1:0.05:0.3;
params.weight = 1:5;
end
%% Combine the parameters into a cell array to form different parameter combination
for i =1:length(params.Wsize)
    for k =1:length(params.weight)
        a{i,k} = [params.Wsize(i),params.weight(k)];
    end
end
params.combo = a;
end