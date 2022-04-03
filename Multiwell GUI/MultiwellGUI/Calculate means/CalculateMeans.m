%script to calculate mean firing rate (mfr), mean bursting 
% rate (mbr), mean burst duration (mbd), mean inter burst interval (ibi), mean percentage of
%random spikes (prs) across all wells of one experiment and put them
%together in one file.
%ELINE

function [] = CalculateMeans ()

clear all
clc

%% select the experiment folder
[expfolder] = selectfolder('Select the main experiment folder to analyze');

cd (expfolder)

%% make loop 
F = searchFolder(pwd, 'Well');
   for i = 1:length(F)
       cd(F {i})

%% select the appropriate folder for mfr
[spikeanalysisfolder] = searchFolder(pwd, 'Spike');
cd(spikeanalysisfolder {1,1})

[mfrfolder] = searchFolder(pwd, 'Mean');
cd(mfrfolder {1,1})

% load appropriate folder containing mfr 
dirname = cd;
List = dir(fullfile(dirname, 'mfr*.mat'));
File = List.name;

%Loads data into X.
X = importdata(File); 

% calculate mfr
mfr = mean(X(:,2));

cd .. 
cd .. 
%% select the appropriate folder for mbr and mbd

[burstanalysisfolder] = searchFolder(pwd, 'BurstAnalysis');
cd(burstanalysisfolder {1,1})

[Statburstfolder] = searchFolder(pwd, 'MeanStatReportBURST');
cd(Statburstfolder {1,1})

%% load appropriate file containing mbd, mbr and ibi 
load MStReportB_ptrain_.mat

mbr = mean(SRMburst(:,3));
mbd = mean(SRMburst(:,7));
ibi = mean(SRMburst(:,10)); % calculate mbr, mbd, ibi

%% load appropriate folder and file containing percentage of random spikes (prs)
cd .. 

[Statspikefolder] = searchFolder(pwd, 'SPIKE');
cd(Statspikefolder {1,1})
load MStReportSpinB_ptrain_.mat

prs = mean(SRMspike(:,5)); %calculate prs

%% put all means in one file, first mean firing rate, then mean bursting 
% rate, then mean burst duration, then inter burst interval, then percentage of
%random spikes 
Reportmeans = [mfr, mbr, mbd, ibi, prs];

cd ..
cd ..
save ('Reportmeans.mat', 'Reportmeans');
save ('Reportmeans.txt', 'Reportmeans', '-ascii');
cd ..
   end
end 
