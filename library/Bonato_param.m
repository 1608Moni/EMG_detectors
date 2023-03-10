function params = Bonato_param(mode,type,SNR,detector)
%% Function to define the parameters of bonato algorithm
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\';
%% Define the ranges for each parameter
params        = struct;
params.M      = 3000;
params.tB     = 3000;  
params.n      = 1;
if mode == "Test"
datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.weight  = optparams.param(1);  
    params.T2      = optparams.param(2);
    params.T1      = optparams.param(3);
    
else
params.weight = 1:5;               % multiplier for threshold 
params.T2     = 5:10:95;            % window to check if atleast 1 crosses
params.T1     = [30,60,100];       % duration of active state 
end
%% Different combination of parameters in a array
for k =1:length(params.weight)
    for j =1:length(params.T2)
        for l =1:length(params.T1)
            a{k,j,l} = [params.weight(k),params.T2(j),params.T1(l)];
        end
    end
end

%% To include only those combinations with T2 < T1
j=1;
for i =1:numel(a)
    tempvar = a{i};
    if tempvar(2) < tempvar(3)
        b{j} = a{i} ;
        j=j+1;
    end
end

params.combo = b;
numel(params.combo)

end