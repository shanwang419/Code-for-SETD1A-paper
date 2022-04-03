
function ImportParameters (start_folder,duration)

cd (start_folder);
[files]=searchFolder(pwd,'param_all');
d=size(files,2);
for w=1:d
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
    s=size(table,1);
    
    param=[];
    mfr=[];
    for i=1:s
        
        if i==s
            el=str2num(cell2mat(table(i,2)))
            MFR=str2num(cell2mat(table(i,3)));
            BN=str2num(cell2mat(table(i,4)));
            BD_ms=str2num(cell2mat(table(i,5)))/1000;
            MFB=str2num(cell2mat(table(i,6)));
            IBI_ms=str2num(cell2mat(table(i,7)))/1000;
            PRS=100-str2num(cell2mat(table(i,8)));
            
            mfr=[mfr;[el MFR PRS]];
            if BN~=0 && BN~=1
                param=[param;[el BN/duration BD_ms MFB IBI_ms]];
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
                         
        else
            well=table(i,1)
            well2=table(i+1,1)
            name=strcat('Well',num2str(cell2mat(well)));
            result_folder=mkdir(pwd,name);
            result_folder_path=strcat(start_folder,'\',name);
            cd(result_folder_path)
            name2=strcat(name,'_Parameters');
            pt_folder=mkdir(pwd,name2);
            pt_folder_path=strcat(result_folder_path,'\',name2);
            cd(pt_folder_path)
            
            if cell2mat(well)==cell2mat(well2)
                el=str2num(cell2mat(table(i,2)))
                MFR=str2num(cell2mat(table(i,3)));
                BN=str2num(cell2mat(table(i,4)));
                BD_ms=str2num(cell2mat(table(i,5)))/1000;
                MFB=str2num(cell2mat(table(i,6)));
                IBI_ms=str2num(cell2mat(table(i,7)))/1000;
                PRS=100-str2num(cell2mat(table(i,8)));
                
                mfr=[mfr;[el MFR PRS]];
                if BN~=0 && BN~=1
                    param=[param;[el BN/duration BD_ms MFB IBI_ms]];
                end
            else
                el=str2num(cell2mat(table(i,2)))
                MFR=str2num(cell2mat(table(i,3)));
                BN=str2num(cell2mat(table(i,4)));
                BD_ms=str2num(cell2mat(table(i,5)))/1000;
                MFB=str2num(cell2mat(table(i,6)));
                IBI_ms=str2num(cell2mat(table(i,7)))/1000;
                PRS=100-str2num(cell2mat(table(i,8)));
                mfr=[mfr;[el MFR PRS]];
                if BN~=0 & BN~=1
                    param=[param;[el BN/duration BD_ms MFB IBI_ms]];
                end
                                          
                name=strcat('ParametersBurst_',num2str(cell2mat(well)));
                save (name,'param')
                nometxt= strcat(name, '.txt');
                save (nometxt, 'param', '-ASCII')
                
                name2=strcat('ParametersSpike_',num2str(cell2mat(well)));
                save (name2,'mfr')
                nometxt2= strcat(name2, '.txt');
                save (nometxt2, 'mfr', '-ASCII')
                                      
                mfr=[];
                param=[];
              end
            
            cd ..
            cd ..
        end
        
    end
end
end