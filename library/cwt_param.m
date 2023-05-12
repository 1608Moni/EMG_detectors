function params = cwt_param(mode,type,SNR,detector)
addpath('..\detectors_review_paper\');
Optdir          = '..\detectors_review_paper\Optparams\pulse500\';
params = struct;
params.lamda = [0.5, 1.5, 2, 3];
params.a     = [1, 3, 4, 6];%[10, 50, 100, 150, 200, 250, 450]; 
params.tou   = 200;
params.M     = 3000;
params.tB    = 3000;
if mode == "Test"
    datafile = strcat(type,detector,num2str(round(SNR)),'.mat');    
    optparamsfile = Optdir + datafile;
%% Read .mat file to get the optimsed paramters
    optparams = load(optparamsfile);
    disp('Read parameters from the file')
    params.w = optparams.param(1);
else
params.w     = 1:0.1:2; 
end

for l =1:length(params.w)
    a{l} = [params.w(l)];
end  

params.combo = a;

end