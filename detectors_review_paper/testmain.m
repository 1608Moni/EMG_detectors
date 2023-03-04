%% Main Script to run the analysis for the Low SNR EMG Detector review paper.
%
% Date: 23 March 2022
% Authors: Monisha Yuvaraj & Sivakumar Balasubramanian
%

clc;
clear;
close all;

% global output;

%% Defining variables used in the script.

datadir = '..\data\';
outdir = 'output\';
addpath('..\library\');
datafiles = ["EMGDataSNR-6trail50dur13gaussian.mat"];
Detectors = ["AGLRstep"];

%% Go through data files and carryout analysis.
datafile = datadir + datafiles(1);          % for each filename in the datafile array
 
% Load the generated EMG_data of the specific SNR
EMG = load(datafile);


%% detector
cwtmain(EMG);
 