function raster_multiwell(start_folder,starttime,duration,fs,wells,condition)
close
cd (start_folder);
result_folder='Rasterplot';
mkdir(pwd,result_folder)
result_folder_path=strcat(start_folder,'\',result_folder);
lookuptable=[12; 13; 21; 22; 23; 24; 31; 32; 33; 34; 42; 43];
lookuptable=[(1:12)',lookuptable];
count=1;
n_figures=wells/6;

if n_figures==floor(n_figures)
    n_figures=n_figures;
else
    wells_remaining=wells-(floor(n_figures)*6)
    n_figures=floor(n_figures)+1;
end


[wells_folder]=searchFolder(pwd,'Well');
% ------------------------------------------------
%for i=1:wells

d=dir;
num_folder=size(d,1)

well_count=1;
for i=3:num_folder
    w=strfind(d(i).name,'Well'); % added
    if ~isempty (w)% added
    cd (d(i).name)% added
    % ---------------------
%    cd (wells_folder{1,i}) 
    
    [PD_folder]=searchFolder(pwd,'Peak');
    cd(PD_folder{1,1})
    [ptrain_folder]=searchFolder(pwd,'ptrain');
    s=size(ptrain_folder,2);

   % -----------------------------------------------------------------------------------------------------
    ii=well_count
    if ii==1 | ii==7 | ii==13 | ii==19
        scrsz = get(0,'ScreenSize');
        figure('Position',[1+100 scrsz(1)+100 scrsz(3)-200 scrsz(4)-200]);
        set(gcf,'Color','w');
    end

% ----------------------------------------------------------------------------------------------------------
        for j=1:s
            cd (ptrain_folder{j,1})
            [ptrain_file]=searchFolder(pwd,'ptrain');
            l=size(ptrain_file,2);
            
            for k=1:l
                load (ptrain_file{1,k})
                el=str2num(ptrain_file{1,k}(end-5:end-4));
                
                realspiketimes= find(peak_train(starttime*10000+1:duration*10000));
                realspiketimes= (realspiketimes+starttime)/fs;
                %  spiketimes= [realspiketimes; (duration*60*10000)+10; (duration*60*10000)+11]; % To avoid 0 or 1 spikes - at least two
                
                
                IMT_index=find(lookuptable(:,2)==el);
                graph_pos=lookuptable(IMT_index, 1)+((i-1)*12);
                
                
                if ii==1 | ii==7 | ii==13 | ii==19
                    color='m';
                    graph_pos=lookuptable(IMT_index, 1);
                elseif ii==2 | ii==8 | ii==14 | ii==20
                    color='b';
                    graph_pos=lookuptable(IMT_index, 1)+12;
                elseif ii==3 | ii==9 | ii==15 | ii==21
                    color='g';
                    graph_pos=lookuptable(IMT_index, 1)+24;
                elseif ii==4 | ii==10 | ii==16 | ii==22
                    color='k';
                    graph_pos=lookuptable(IMT_index, 1)+36;
                elseif ii==5 | ii==11 | ii==17 | ii==23
                    color='r';
                    graph_pos=lookuptable(IMT_index, 1)+48;
                elseif ii==6 | ii==12 | ii==18 | ii==24
                    color='c';
                    graph_pos=lookuptable(IMT_index, 1)+60;
                end
                    
                    
                subplot(72, 1, graph_pos,'align')
                raster=bar(realspiketimes, sign(realspiketimes),0.001,color); % Raster Plot
%                 space=round((duration*60/fs-1/fs)/50); % I verified that it is ok this space
%                 text((1/fs-space), 0.25, num2str(el), 'FontSize', 5, 'FontWeight', 'bold');
                    
                if (graph_pos==72)
                     set(gca,'Ycolor', 'w');
                     set(gca,'ytick',[]);
                     set(get(gca,'XLabel'),'String','Time [sec]')
                     name_figure=strcat('Raster',num2str(count));
                     %cd(result_folder_path)
                     %saveas(raster, name_figure,'jpg');   % JPEG format
                     count=count+1;
                     % --------------------------------------
                    % cd ..
                else 
                    axis off

        end

            %                        % Lines are blue
        end

    end
    
        axis([starttime (duration) 0 0.5]); % Olny the time frame selected
        
   % ------------------- ADDED
   cd ..
   cd ..
   cd ..
   well_count=well_count+1;
    end
        
end



