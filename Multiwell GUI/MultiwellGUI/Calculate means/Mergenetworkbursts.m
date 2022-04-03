function [] = Mergenetworkbursts()

clear all
clc


%% select the experiment folder
[expfolder] = selectfolder('Select the main experiment folder to analyze');
cd (expfolder)

% make loop trough experiment folders
F = searchFolder(pwd, 'Well');
 for i = 1:length(F);
       cd(F {i});
% loop trough all burstdetection folders 
 G = searchFolder(pwd, 'BurstDetection');
 for i = 1:length(G);
       cd(G {i});
 % select the appropriate folder containing the networkbursts file      
[nbDetectionfolder] = searchFolder(pwd, 'Network');
cd(nbDetectionfolder {1,1});

% load appropriate folder containing nbr, dnb and ibinb
dirname = cd;
List = dir(fullfile(dirname, 'Network*.mat'));
File = List.name;
Data = importdata(File); %Loads data into variable Data

if isempty(Data) 
    cd .. 
    continue 

else 
netBursts = Data.netBursts;

end    

NBdata2=[]
 le=length(netBursts)
    count=1
 


for i=1:le;
        if i==le;
            t1=netBursts(count,1)
            t2=netBursts(i,2)
            duration= t2 - t1
            NBdata2=[NBdata2;[t1,t2,duration]]
        else
            time=netBursts((i+1),1)-netBursts(i,2)
            if time>10000
                t1=netBursts(count,1)
                t2=netBursts(i,2)
                duration= t2 - t1
                NBdata2=[NBdata2;[t1,t2,duration]]
                count=i+1
            end
        end
        
end
 cd ..
       C = {1};
 mkdir NetworkBurstMergeDetection
 cd NetworkBurstMergeDetection
        netBursts=NBdata2;
        nome= strcat('netBursts'); % MAT file name
        save (nome, 'netBursts', 'C');
        
        cd .. 
end
 end
end








