%% Main Script to run the analysis for the Low SNR EMG Detector review paper.
%
% Date: 23 March 2022
% Authors: Monisha Yuvaraj & Sivakumar Balasubramanian
%

clc;
clear;
close all;

%% Defining variables used in the script.

datadir         = '..\data\';
addpath('..\library\');
mode   = "Pulse500Test";
Model  = ["biophy"];
SNR    = ["0"];
trial  = 50;                % Total number of trials
dur    = 13;                % Duration in seconds
Detectors =["hodges2","AGLRstep1","AGLRstep2","FuzzyEnt"];%"Detector2018","hodge,"lidierth1","lidierth2",...
    %"AGLRstep1","AGLRstep2","FuzzyEnt","SampEnt","bonato","TKEO","SSA","CWT"];

%% Run through all model and all SNRs
for k = 1:length(Model)
    for l = 1:length(SNR)       
        datafile = strcat(mode,"SNR",SNR(l),"trail",num2str(trial),"dur",num2str(dur),Model(k));
        if mode == "Test"
            datafile = strcat("Test",datafile);
            disp("Running the validation set")
        end
        %% Read the data file and carryout analysis.
        datafile = datadir + datafile;          % for each filename in the datafile array
        %% Load the generated EMG_data of the specific SNR
        EMG = load(datafile);
        EMG.mode = mode;
        for j = 1:length(Detectors)
            detectors(EMG, Detectors(j))
        end       
    end
end