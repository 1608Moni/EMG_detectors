function params = modifiedhodges_param(mode,type,SNR,detector, method)
%% Function to define parameters of hodges. 
% The parameters are combined in a array to analyse the detector for
% different paramter combination.  
%%
addpath('..\detectors_review_paper\');


%%
params          = struct();
params.tB       = 2000;           % start of relax phase to test (ms)
params.M        = 1500; 
if mode == "Test"  
%     if method == "step"
%         Optdir          = '..\detectors_review_paper\Optparams\';
%     elseif method == "pulse"
%         Optdir          = '..\detectors_review_paper\Optparams\pulse500\Dur13\';
%     end
%     datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
%     optparamsfile = Optdir + datafile;
% %% Read .mat file to get the optimsed paramters
%     optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.weight = 2;   %optparams.param(1);
    params.fc     = 100; %optparams.param(2);    
else
params.fc       = [1.5,5,10,50,100,200];%1.5:1:10;      % Cutoff frequency range for lpf(Hz)
params.weight   = [2,3];%1:10;      % weight to determine the threshold
end

for k =1:length(params.weight)
    for j = 1:length(params.fc)
        a{k,j} = [params.weight(k),params.fc(j)];
    end
end
params.combo = a;

end