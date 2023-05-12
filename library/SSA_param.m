function params = SSA_param(mode,type,SNR,detector)
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\pulse500\';
params = struct;
params.tB = 3000;
if mode == "Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.m = optparams.param(1);
else
params.m  = 50:2:100;
end
for j =1:length(params.m)
    a{j} = [params.m(j)];
end
 
params.combo = a;


end