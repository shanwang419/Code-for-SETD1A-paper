

function Calculate_CV (start_folder,duration)


clr


% get the parameters needed to calculate (duration of recording and frequecncy)
parameters = calculatenetworkmeansparam;
recfreq = parameters.recfreq;
reclength = parameters.reclength;

duration = reclength;

% select folder
[start_folder] = selectfolder('Select the source folder containing Netburst_all');

cd (start_folder);
[files]=searchFolder(pwd,'Netburst_all');
d=size(files,2);
for w=1:d
    % number=files{1,w}(end-7:end-4);
    %fileName=strcat('param_all_',number,'.csv');
    fileName='Netburst_all.csv';
    delimiter= {','};
    i=0;
    fid = fopen(fileName,'r');   %# Open the file
    lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly
    %#   larger than is needed)
    lineIndex = 1;               %# Index of cell to place the next line in
    nextLine = fgets(fid);       %# Read the first line from the file
    while ~isequal(nextLine,-1)  %# Loop while not at the end of the file
        
        i=i+1;
        lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
        lineIndex = lineIndex+1;          %# Increment the line index
        nextLine = fgetl(fid);            %# Read the next line from the file
    end
    fclose(fid);                 %# Close the file
    lineArray = lineArray(1:lineIndex-1);  %# Remove empty cells, if needed
    for iLine = 1:lineIndex-1              %# Loop over lines
        lineData = textscan(lineArray{iLine},'%s',...  %# Read strings
            'Delimiter',delimiter);
        lineData = lineData{1};              %# Remove cell encapsulation
        if strcmp(lineArray{iLine}(end),delimiter)  %# Account for when the line
            lineData{end+1} = '';                     %#   ends with a delimiter
        end
        lineArray(iLine,1:numel(lineData)) = lineData;  %# Overwrite line data
    end
    
    
    wellID=lineArray(2:end,2); % take out the well ID from the excel
    wellID1=cell2mat(wellID);
    wellID2=wellID1(:,2:3); % only take into account what is between ''
    WellID=cellstr(wellID2);
    
    
    NBstarttime = str2double(lineArray(2:end,8));
    NBduration = str2double(lineArray(2:end,9));
    
    NBendtime = num2cell(NBstarttime + NBduration);
    NBstarttime2 = num2cell(NBstarttime);
    
    table= [WellID NBstarttime2 NBendtime];
    
    
    table_NIBI=[NBstarttime2 NBendtime];
    
    
    %here the summary parameters empty table is built that will be filled
    %in the rest of the script
    
    SummaryParam = [];
    
    lables = {'well', 'Network inter-burst-interval (ms)',...
        'Coefficient of variability',};
    
    well_label = (lables(1,1));
    NIBI = (lables(1,2));
    CV2 = (lables(1,3));
    
    SummaryParam=[SummaryParam; [well_label NIBI CV2]];
    
    % from here on the calculation of the NIBI will be made for the
    % specified file
    
    s=size(table,1) ;
    
    ibi_all=[];
    ibi_table=[];
    
    for i=1:s
        
        if i==s     %when the end of the table is reached
            
            NIBI_mean=mean(ibi_all_ms(:,1));
            stand=std(ibi_all_ms(:,1));
            CV=stand/NIBI_mean;
            
            SummaryParam= [SummaryParam; [well NIBI_mean CV]];
            
        else
            
            well=table(i,1);
            well2=table(i+1,1);
            
            if cell2mat(well)==cell2mat(well2)  %as long as the well number in the table is the same, continue building the parameters summary of this particular well
                
                NIBI_table=cell2mat(table(:,2:3));
                ibi=NIBI_table(i+1,1)-NIBI_table(i,2);
                ibi_table=[ibi_table;[ibi]];
                ibi_all_ms=ibi_table*1000/10000;
                
            else
                NIBI_mean=mean(ibi_all_ms(:,1));
                stand=std(ibi_all_ms(:,1));
                CV=stand/NIBI_mean;
                
                %build the summaryparameters table
                
                SummaryParam= [SummaryParam; [well NIBI_mean CV]]
                
                %empty the parameters again to fill for the next well
                ibi_all=[];
                ibi_table=[];
            end
        end
        
    end
    
    save('NBparam.mat', 'SummaryParam')
    
    %code to write data in excel sheet (warning that there is no specified worksheet is turned off)
    data=load('NBparam.mat');
    f=fieldnames(data);
    
    for k=1:size(f,1)
        xlswrite('NBparam.xlsx',data.(f{k}),f{k})
        
    end
    
    
end
end
