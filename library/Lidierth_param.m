function params = Lidierth_param(mode,type,SNR,detector)
%% Function to define parameters of Lidierth. 
% The parameters are combined in a array to analyse the detector for
% different paramter combination.  
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\';
%% Define parameters in the function
params        = struct;
params.M      = 3000;             % wnidow to compute the baseline thrshold
params.tB     = 3000;             % start of relax phase to test (ms)
params.n      = 1; 
if mode == "Pulse500Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.Wsize   = optparams.param(1);
    params.weight  = optparams.param(2);  
    params.T2      = optparams.param(3);  
    params.T1      = optparams.param(4);
else
params.Wsize  = 0.1:0.1:0.5;     % Moving avg window 
params.weight = 1:5;             % multiplier for threshold 
params.T2     = 5:5:95;          % window to check if atleast 1 crosses
params.T1     = [30,60,100];     % Condition for period of active state[50,60,70,80,90,100];               % atleast 1 out of a window cross threshold
end
%% 


%% 
for i =1:length(params.Wsize)
    for k =1:length(params.weight)
        for j =1:length(params.T2)
            for l =1:length(params.T1)
                a{i,k,j,l} = [params.Wsize(i),params.weight(k),params.T2(j),params.T1(l)];
           end                  
        end
    end
end
 

%% To make sure that m < T1;
j=1;
for i =1:numel(a)
    tempvar = a{i};
    if tempvar(3) < tempvar(4)
        b{j} = a{i} ;
        j=j+1;
    end
end

params.combo = b;
end