function params = modifiedhodges_param(mode,type,SNR,detector)
%% Function to define parameters of hodges. 
% The parameters are combined in a array to analyse the detector for
% different paramter combination.  
%%
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\Dur13\';

%%
params          = struct();
params.tB       = 3000;           % start of relax phase to test (ms)
params.M        = 3000; 
if mode == "Test"  
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.weight = optparams.param(1);
    params.fc     = optparams.param(2);    
else
params.fc       = 0.5:1:10;      % Cutoff frequency range for lpf(Hz)
params.weight   = 1:5;      % weight to determine the threshold
end

for k =1:length(params.weight)
    for j = 1:length(params.fc)
        a{k,j} = [params.weight(k),params.fc(j)];
    end
end
params.combo = a;

end