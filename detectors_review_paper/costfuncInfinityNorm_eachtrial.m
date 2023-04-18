function [CF,Latency_ON, f_delT_ON,Latency_OFF, f_delT_OFF,FPR,FNR] = costfuncInfinityNorm_eachtrial(binop,t0capon,t0capoff,groundtruth,t0,tB,fs,p,tdur)
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
[Latency_ON, f_delT_ON,Latency_OFF, f_delT_OFF] = latency(t0capon,t0capoff,t0,fs,tdur); 

%% FPR
FPR = falsePositveRate(groundtruth,binop,t0,tB,p,tdur);

%% FNR
FNR = falseNegativeRate(groundtruth,binop,t0,p,tdur);

%% Cost function

CF = max([W_lat*f_delT_ON ,W_lat*f_delT_OFF , W_FPR*FPR , W_FNR*FNR]); % Computing the infinity norm 

end