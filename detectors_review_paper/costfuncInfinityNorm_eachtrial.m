function [CF,Latency,f_delT,FPR,FNR] = costfuncInfinityNorm_eachtrial(binop,t0cap,groundtruth,t0,tB,fs,p)
%% Function to compute latency, FPR and FNT for each trial 
% cost is computed by taking maximum (latency, false positive rate and false negative rate)
% INPUT  : binary output for each trial
% OUTPUT : Normalised latency
%          False postive rate
%          False negative rate
%

%% Define parameters in the function
W_lat = 1;
W_FPR = 1;
W_FNR = 1;

%% Latency
[Latency, f_delT] = latency(t0cap,t0,fs); 

%% FPR
FPR = falsePositveRate(groundtruth,binop,t0,tB,p);

%% FNR
FNR = falseNegativeRate(groundtruth,binop,t0,p);

%% Cost function

CF = max([W_lat*f_delT , W_FPR*FPR , W_FNR*FNR]); % Computing the infinity norm 

end