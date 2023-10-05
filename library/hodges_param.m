function params = hodges_param(mode,type,SNR,detector, method)
%% Function to define parameters of hodges. 
% The parameters are combined in a array to analyse the detector for
addpath('..\detectors_review_paper\');
params          = struct();
params.M        = 500;           % Window to compute baseline (sample number)
params.tB       = 2000;           % start of relax phase to test (sample number)
if mode == "Test"
    % different paramter combination.  
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
    params.Wsize  = optparams.param(1);
    params.weight = optparams.param(2);
    params.fc     = optparams.param(3); 
else
%% Range of parameters to train    
params.fc       = 1.5:1:10;       % Cutoff frequency range for lpf(Hz)
params.Wsize    = 0.1:0.05:0.3;   % Sliding window size range  (sec)
params.weight   = 1:5;            % weight to determine the threshold    
end

for i =1:length(params.Wsize)
    for k =1:length(params.weight)
        for j = 1:length(params.fc)
        a{i,k,j} = [params.Wsize(i),params.weight(k),params.fc(j)];
        end
    end
end

params.combo = a;

end