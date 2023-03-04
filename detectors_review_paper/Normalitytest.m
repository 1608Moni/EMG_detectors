%% Script to carry out the normality test
clc
clear all
close all

%% define the parametes in the script
dataBiodir   = 'EMG_Biophymodel\';
dataGaussdir = '..\data\';
datafiles    = ["RawEMGforce300.mat", "NoiseEMGforce300SNR0dB.mat", "EMGDataSNR0trail50dur13gaussian.mat","EMGDataSNR0trail50dur13laplacian.mat"];

%% Load the files
RawdataBioPhyfile    = dataBiodir + datafiles(1);
RawBiophydata        = load(RawdataBioPhyfile);
RawBiophydata        = RawBiophydata.data;

Noise0BioPhydatafile = dataBiodir + datafiles(2);
Noise0BioPhydata     = load(Noise0BioPhydatafile);
Noise0BioPhydata     = Noise0BioPhydata.data;

gaussdatafile        = dataGaussdir + datafiles(3);
gaussdata            = load(gaussdatafile);
gaussdata            = gaussdata.data;

laplaciandatafile    = dataGaussdir + datafiles(4);
laplaciandata        = load(laplaciandatafile);
laplaciandata        = laplaciandata.data;


figure
subplot(2,2,1)
histogram(RawBiophydata(1,:))
title('RawEMGforce300')
subplot(2,2,2)
histogram(Noise0BioPhydata(1,:))
title('Addedwith0db noise')
subplot(2,2,3)
histogram(gaussdata(1,:))
title('Gaussian data')
subplot(2,2,4)
histogram(laplaciandata(1,:))
title('laplacian data')

figure
 subplot(2,2,1)
plot(RawBiophydata(1,:))
title('RawEMGforce300')
 subplot(2,2,2)
% figure
plot(Noise0BioPhydata(1,:))
title('Addedwith0db noise')
% figure
subplot(2,2,3)
plot(gaussdata(1,:))
title('Gaussian data')
subplot(2,2,4)
plot(laplaciandata(1,:))
title('laplacian data')





