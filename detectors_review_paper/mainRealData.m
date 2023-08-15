%% Main Script to run the analysis for the Low SNR EMG Detector review paper.
%
% Date: 23 March 2022
% Authors: Monisha Yuvaraj & Sivakumar Balasubramanian
%

clc;
clear;
close all;

%% Defining variables used in the script.

folderPath = 'F:\StrokeData\Data\';
addpath('..\library\');
% mode   = ["Test"];
% method = "T_EdgePmove";
% Model  = ["biophy"];
% SNR    = ["0"];
% trial  = 50;                % Total number of trials
% dur    = 15;                % Duration in seconds
Detectors =["FuzzyEnt"];% "hodges","modifiedhodges","AGLRstep","AGLRstepLaplace" 

%% Read the real EMG data file
filePath = fullfile(folderPath, 'Finaldata.mat');
EMGdata = load(filePath);

%% Run through all model and all SNRs
for l = 1:length(Detectors)
    detectorsmain(EMGdata, Detectors(l))   
end

%