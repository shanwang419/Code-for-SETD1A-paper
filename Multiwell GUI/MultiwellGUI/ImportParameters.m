
function ImportParameters (start_folder,duration)

cd (start_folder);
[files]=searchFolder(pwd,'param_all');
e=size(files,2);
for w=1:e
   % number=files{1,w}(end-7:end-4);
    %fileName=strcat('param_all_',number,'.csv');
    fileName='param_all.csv';
    delimiter= ',';
    
    fid = fopen(fileName,'r');   %# Open the file
    lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly
    %#   larger than is needed)
    lineIndex = 1;               %# Index of cell to place the next line in
    nextLine = fgetl(fid);       %# Read the first line from the file
    while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
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
    
    
    table=[lineArray(2:end,4) lineArray(2:end,2) lineArray(2:end,11) lineArray(2:end,12) lineArray(2:end,13) lineArray(2:end,15) lineArray(2:end,17) lineArray(2:end,16)];
    s=size(table,1);% finds collumn 4, 2, 11, 12, 13, 15, 17, 16 in Param_all
    
    burst=[];
    mfr=[];
    for f=1:s
        
        if f==s
            el=str2num(cell2mat(table(f,2)))
            MFR=str2num(cell2mat(table(f,3)));
            BN=str2num(cell2mat(table(f,4)));
            BD_ms=str2num(cell2mat(table(f,5)))/1000;
            MFB=str2num(cell2mat(table(f,6)));
            IBI_ms=str2num(cell2mat(table(f,7)))/1000;
            PRS=100-str2num(cell2mat(table(f,8)));
            
            mfr=[mfr;[el MFR PRS]];
            if BN~=0 && BN~=1
                burst=[burst;[el BN/duration BD_ms MFB IBI_ms]];
            end
                                
            cd(pt_folder_path)
            name=strcat('ParametersBurst_',num2str(cell2mat(well)));
            save (name,'param')
            nometxt= strcat(name, '.txt');
            save (nometxt, 'param', '-ASCII')
            
            name2=strcat('ParametersSpike_',num2str(cell2mat(well)));
            save (name2,'mfr')
            nometxt2= strcat(name2, '.txt');
            save (nometxt2, 'param', '-ASCII')
                         
%         else
%             well=table(f,1)
%             well2=table(f+1,1)
%             name=strcat('Well',num2str(cell2mat(well)));
%             result_folder=mkdir(pwd,name);
%             result_folder_path=strcat(start_folder,'\',name);
%             cd(result_folder_path)
%             name2=strcat(name,'_Parameters');
%             pt_folder=mkdir(pwd,name2);
%             pt_folder_path=strcat(result_folder_path,'\',name2);
%             cd(pt_folder_path)
%             
%             if cell2mat(well)==cell2mat(well2)
%                 el=str2num(cell2mat(table(f,2)))
%                 MFR=str2num(cell2mat(table(f,3)));
%                 BN=str2num(cell2mat(table(f,4)));
%                 BD_ms=str2num(cell2mat(table(f,5)))/1000;
%                 MFB=str2num(cell2mat(table(f,6)));
%                 IBI_ms=str2num(cell2mat(table(f,7)))/1000;
%                 PRS=100-str2num(cell2mat(table(f,8)));
%                 
%                 mfr=[mfr;[el MFR PRS]];
%                 if BN~=0 && BN~=1
%                     burst=[burst;[el BN/duration BD_ms MFB IBI_ms]];
%                 end
%             else
%                 el=str2num(cell2mat(table(f,2)))
%                 MFR=str2num(cell2mat(table(f,3)));
%                 BN=str2num(cell2mat(table(f,4)));
%                 BD_ms=str2num(cell2mat(table(f,5)))/1000;
%                 MFB=str2num(cell2mat(table(f,6)));
%                 IBI_ms=str2num(cell2mat(table(f,7)))/1000;
%                 PRS=100-str2num(cell2mat(table(f,8)));
%                 mfr=[mfr;[el MFR PRS]];
%                 if BN~=0 & BN~=1
%                     burst=[burst;[el BN/duration BD_ms MFB IBI_ms]];
%                 end
%                                           
%                 name=strcat('ParametersBurst_',num2str(cell2mat(well)));
%                 save (name,'param')
%                 nometxt= strcat(name, '.txt');
%                 save (nometxt, 'param', '-ASCII')
%                 
%                 name2=strcat('ParametersSpike_',num2str(cell2mat(well)));
%                 save (name2,'mfr')
%                 nometxt2= strcat(name2, '.txt');
%                 save (nometxt2, 'mfr', '-ASCII')
%                                       
%                 mfr=[];
%                 burst=[];
              end
            
            cd ..
            cd ..
        end
        
    end
    cd (start_folder);
    [files]=searchFolder(pwd,'burst_all');
    e=size(files,2);
    for w=1:e
   % number=files{1,w}(end-7:end-4);
    %fileName=strcat('param_all_',number,'.csv');
    fileName='burst_all.csv';
    delimiter= ',';
    
    fid = fopen(fileName,'r');   %# Open the file
    lineArray = cell(100,1);     %# Preallocate a cell array (ideally slightly
    %#   larger than is needed)
    lineIndex = 1;               %# Index of cell to place the next line in
    nextLine = fgetl(fid);       %# Read the first line from the file
    while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
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
    
    
    table=[lineArray(2:end,4) lineArray(2:end,2) lineArray(2:end,11) lineArray(2:end,12) lineArray(2:end,13)];
    s=size(table,1);% finds collumn 4, 2, 11, 12, 13, 15, 17, 16 in Param_all
    
    burst=[];
%     mfr=[];
    for f=1:s
        
        if f==s
            el=str2num(cell2mat(table(f,2)))
            BD_ms=str2num(cell2mat(table(f,3)))/1000;
            SCB=str2num(cell2mat(table(f,4))); %spike count in burst SCB
            SFB=str2num(cell2mat(table(f,5))); %Spike frequency in burst [Hz]
            
                                            
            cd(pt_folder_path)
            name=strcat('ParametersBurst_2_',num2str(cell2mat(well)));
            save (name,'Burst2')
            nometxt= strcat(name, '.txt');
            save (nometxt, 'Burst2', '-ASCII')
            
                                  
        else
            well=table(f,1)
            well2=table(f+1,1)
            name=strcat('Well',num2str(cell2mat(well)));
            result_folder=mkdir(pwd,name);
            result_folder_path=strcat(start_folder,'\',name);
            cd(result_folder_path)
            name2=strcat(name,'_Parameters');
            pt_folder=mkdir(pwd,name2);
            pt_folder_path=strcat(result_folder_path,'\',name2);
            cd(pt_folder_path)
            
            if cell2mat(well)==cell2mat(well2)
            el=str2num(cell2mat(table(f,2)))
            BD_ms=str2num(cell2mat(table(f,3)))/1000;
            SCB=str2num(cell2mat(table(f,4))); %spike count in burst SCB
            SFB=str2num(cell2mat(table(f,5))); %Spike frequency in burst [Hz]
                
              
            else
                el=str2num(cell2mat(table(f,2)))
                BD_ms=str2num(cell2mat(table(f,3)))/1000;
                SCB=str2num(cell2mat(table(f,4))); %spike count in burst SCB
                SFB=str2num(cell2mat(table(f,5))); %Spike frequency in burst [Hz]
                                          
                name=strcat('ParametersBurst_',num2str(cell2mat(well)));
                save (name,'param')
                nometxt= strcat(name, '.txt');
                save (nometxt, 'param', '-ASCII')
                
                name2=strcat('ParametersSpike_',num2str(cell2mat(well)));
                save (name2,'mfr')
                nometxt2= strcat(name2, '.txt');
                save (nometxt2, 'mfr', '-ASCII')
                                      
                burst=[];
              end
            
            cd ..
            cd ..
        end
        
    end
end
end