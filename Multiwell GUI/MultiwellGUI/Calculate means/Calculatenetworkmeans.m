%script to calculate network burst rate (nbr), duration of network bursts
%(dnb), inter burst interval of the network bursts (ibinb)across all wells 
%of one experiment and put them together in one file.\
%ELINE

function [] = Calculatenetworkmeans ()

clear all
clc


%% get the parameters needed to calculate (duration of recording and frequency)
parameters = calculatenetworkmeansparam;
recfreq = parameters.recfreq;
reclength = parameters.reclength;

%% select the experiment folder
[expfolder] = selectfolder('Select the main experiment folder to analyze');
cd (expfolder)

%% make loop trough experiment folders
F = searchFolder(pwd, 'Well');
 for i = 1:length(F);
       cd(F {i});
%% loop trough all burstdetection folders 
 G = searchFolder(pwd, 'BurstDetection');
 for i = 1:length(G);
       cd(G {i});
  %% select the appropriate folder for nbr, dnb and ibinb     
[nbDetectionfolder] = searchFolder(pwd, 'BurstMerge');
cd(nbDetectionfolder {1,1});

% load appropriate folder containing nbr, dnb and ibinb
dirname = cd;
List = dir(fullfile(dirname, 'net*.mat'));
File = List.name;
Data = importdata(File); %Loads data into variable Data
if isempty(Data)
    cd .. 
    continue 
else 
NBdata = Data.netBursts;
end 

%% calculate nbr & dnb and mean dnb
nbr = length(NBdata)/reclength;
dnb = (NBdata(:,2)-NBdata(:,1))/recfreq;
meandnb = mean(dnb);

%% calculate ibinb
ibinb = zeros(1, size(NBdata,1)-1)';
    for i = 1:size(NBdata,1)-1;
    B = NBdata((i+1), 1) - NBdata(i, 2);
    ibinb(i) = B;
    end

%% save calculated variables in the corresponding well folder 
cd .. 
save ('networkburstrate.mat','nbr');
save ('networkburstrate.txt','nbr', '-ascii');
save ('durationofnetworkbursts.mat','dnb');
save ('durationofnetworkbursts.txt','dnb', '-ascii');
save ('interburstintervalnetworkbursts.mat','ibinb');
save ('interburstintervalnetworkbursts.txt','ibinb', '-ascii');
save ('meandnb.mat','meandnb');
save ('meandnb.txt','meandnb', '-ascii');
 end
 cd .. 
 cd ..
 
 end
end
