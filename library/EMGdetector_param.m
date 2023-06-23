function params = EMGdetector_param(mode,type,SNR,detector)
%% Function to define parameters of hodges. 
% The parameters are combined in a array to analyse the detector for
% different paramter combination.  
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\';
%%
params          = struct();
params.fl       = 10;            % Cutoff of BPF lower limit
params.fh       = 225;           % Cutoff of BPF upper limit
params.M        = 3000;          % Window to compute baseline (ms)
params.tB       = 3000;          % start of relax phase to test (ms)
%%
if mode == "Test"
   datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
%To run the detector with parameters in the paper Balasubranian 2018 et al
% datafile = strcat('Detector2018','.mat');    
optparamsfile = Optdir + string(datafile);
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.Wsize   = optparams.param(1);
    params.weight  = optparams.param(2);
    params.Wshift  = optparams.param(3);
    params.m       = optparams.param(4);    
else
params.Wsize    = 0.12:0.04:0.44;       % Sliding window size range  (sec)
params.weight   = 1:5;                  % weight to determine the threshold
params.Wshift   = [1,10,20,40];         % paramter to increment the window (ms)
params.m        = [40,80,120,160,200];  % temporal threshold in (ms)                  %200;%[5,50,100,200];% paramter to see last m samples active
end

for i =1:length(params.Wsize)
    for k =1:length(params.weight)
        for j = 1:length(params.Wshift)
            for l = 1:length(params.m)
                a{i,k,j,l} = [params.Wsize(i),params.weight(k),params.Wshift(j),params.m(l)];
            end
        end
    end
end

params.combo = a;
numel(params.combo)
end