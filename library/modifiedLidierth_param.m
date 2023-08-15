function params = modifiedlidierth_param(mode,type,SNR,detector)
%% Function to define parameters of Lidierth. 
% The parameters are combined in a array to analyse the detector for
% different paramter combination.  
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\pulse500\Dur13\';
%% Define parameters in the function
params        = struct;
params.M      = 500;                % wnidow to compute the baseline thrshold
params.n      = 1;                    % atleast 1 out of a window cross threshold
params.tB     = 1000;                 % start of relax phase to test (ms)

if mode == "Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.fc     = optparams.param(1); 
    params.weight = optparams.param(2);
    params.T2     = round(optparams.param(3)/2);
    params.T1     = round(optparams.param(4)/2);
else
params.fc     = 1.5:2:10;             % LPF cutoff frequency
params.weight = 1:3;                  % multiplier for threshold 
params.T2     = 5:10:95;               % window to check if atleast 1 crosses
params.T1     = [30,60,100];          %Condition for period of active state
end

%% 

for i =1:length(params.fc)
    for k =1:length(params.weight)
        for j =1:length(params.T2)
            for l =1:length(params.T1)
                a{i,k,j,l} = [params.fc(i),params.weight(k),params.T2(j),params.T1(l)];
            end
        end
    end
end
 
j=1;
for i =1:numel(a)
    tempvar = a{i};
    if tempvar(3) < tempvar(4)
        b{j} = a{i} ;
        j=j+1;
    end
end

params.combo = b;
numel(params.combo)
end