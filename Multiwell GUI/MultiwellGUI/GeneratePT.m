clr

function GeneratePT (start_folder, duration, fs)

%
%[start_folder]= selectfolder('Select the folder containing the signal');
%if isempty (start_folder)
%    return
%end

%Entering in the folder containing the .csv files extracted from the
%Multiwell Analyzer software.
cd (start_folder);

%Seraching fot the .csv file containing the timestamp of the spikes
%detected.
[files] = searchFolder(pwd, 'PT_all');
%Computation of the number of column of the .csv file.
d       = size(files, 2);

for w = 1:d
    %number   = files{1,w}(end-7 : end-4);
    
    fileName = 'PT_all.csv';
    delimiter= ',';
    
    %Open the file containing the output of the Multiwell Analyzer
    %software.
    fid = fopen(fileName,'r');   
    
    %Preallocate a cell array (ideally slightly larger than is needed).
    %The rows of this array should be major or equal to the number of
    %recording channel of the well.
    line_Array = cell(20,1);
    %Index of cell to place the next line in
    line_Index = 1; 
    %Read the first line from the .csv file
    nextLine = fgetl(fid);      
    
    % Loop while not at the end of the file
    while ~isequal(nextLine,-1)
        % Add the line to the cell array
        line_Array{line_Index} = nextLine; 
        % Increment the line index
        line_Index = line_Index+1;     
        % Read the next line from the file
        nextLine = fgetl(fid);           
    end
    
    fclose(fid);                 %# Close the file
    line_Array = line_Array(1:line_Index-1);  %# Remove empty cells, if needed
    
    for iLine = 1:line_Index-1              %# Loop over lines
        lineData = textscan(line_Array{iLine},'%s',...  %# Read strings
            'Delimiter',delimiter);
        lineData = lineData{1};              %# Remove cell encapsulation
        if strcmp(line_Array{iLine}(end),delimiter)  %# Account for when the line
            lineData{end+1} = '';                     %#   ends with a delimiter
        end
        line_Array(iLine,1:numel(lineData)) = lineData;  %# Overwrite line data
    end
   w0=line_Array(2:end,4);
    w1=cell2mat(w0);
    ww=w1(:,2:3); w=cellstr(ww);
    e0=line_Array(2:end,2);
    e1=cell2mat(e0);
    ee=e1(:,2:3); e=cellstr(ee); 
    table=[w e line_Array(2:end,10) ...
        line_Array(2:end,11)];
    
    s=size(table,1);
    well=table(1,1);
    
    PT=[];
    for i=1:s
        if i==s
            PT=[PT;[table(i,3) table(i,4)]];
            s2=size(PT,1);
            for j=1:s2
                sample=str2double(cell2mat(PT(j,1)));
                sample=sample/100;
                amplitude=str2double(cell2mat(PT(j,2)));
                peak_train(sample)=amplitude;
            end
            artifact=[];
            elnum=cell2mat(el);
            cd(ptrain_phase_path)
            name_peaktrain=strcat('ptrain_',elnum);
            save (name_peaktrain,'peak_train','artifact')
            cd ..
            cd ..
            cd ..
            PT=[];
        else
            well  = table(i,1);
            well2 = table(i+1,1);
            
            name=strcat('Well',num2str(cell2mat(well)));
            
            result_folder = mkdir(pwd,name);
         
            result_folder_path=strcat(start_folder,'\',name);
            
            cd(result_folder_path)
            name2=strcat(name,'_PeakDetectionMAT_PLP2ms_RP1ms');
            pt_folder=mkdir(pwd,name2);
            pt_folder_path=strcat(result_folder_path,'\',name2);
            cd(pt_folder_path)
            
            %    if cell2mat(well2)==cell2mat(well)
            el=table(i,2);
            el2=table(i+1,2);
            if cell2mat(el2)==cell2mat(el)
                PT=[PT;[table(i,3) table(i,4)]];
                cd ..
                cd ..
            else
                PT=[PT;[table(i,3) table(i,4)]];
                %maxsample=cell2mat(PT(end,1));
                %maxsample1=str2num(maxsample);
                %maxsample1=maxsample1/100;
                duration_s=duration*60;
                maxsample1=duration_s*fs;
                peak_train=sparse(maxsample1,2);
                
                s2=size(PT,1);
                for j=1:s2
                    sample=str2double(cell2mat(PT(j,1)));
                    sample=sample/100;
                    amplitude=str2double(cell2mat(PT(j,2)));
                    peak_train(sample)=amplitude;
                end
                artifact=[];
                elnum=cell2mat(el);
                ptrain_phase=strcat(name, '_ptrain_');
                ptrain_phase_path=strcat(pt_folder_path,'\',ptrain_phase);
                mkdir(pwd,ptrain_phase)
                cd(ptrain_phase_path)
                name_peaktrain=strcat('ptrain_',elnum);
                save (name_peaktrain,'peak_train','artifact')
                cd ..
                cd ..
                cd ..
                PT=[];
            end
        end
    end
    
end
end