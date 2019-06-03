function se_anatomy(action,varargin)


global st JuBrain SPM Macro

warning off all

if ~nargin, Anatomy; return; end

switch lower(action)
    
    case {'init'}
        
        try; delete(st.fig); end
        
        
        
        try;   FS = spm('FontSizes');
        catch; f = errordlg({'SPM needs to be in the Matlab path';'     for the Anatomy Toolbox';'         to function properly'},'SPM not found');
            return
        end
        
        clear global
        global st JuBrain SPM Macro
        
        %        load JuBrain_Data_public_v30.mat
        try
            load(spm_select(1,'mat','Select JuBrain Data File',[],spm_str_manip(which('se_anatomy.m'),'H'),'JuBrain_Data_'));
        catch
            load(fullfile(fileparts(which('se_anatomy.m')),'JuBrain_Data_v30beta.mat'))
        end
        
        JuBrain.Vo.fname = fullfile(fileparts(which('se_anatomy.m')),JuBrain.Vo.fname);
        
        FS = [1:36]+1; PF = spm_platform('fonts'); S0 = get(0,'ScreenSize'); WS = [1 1 S0(3:4)./[1680 1050]];
        
        st.fig    = figure(...
            'Tag','Graphics',...
            'Position',[100 105 1512 892].*WS,...
            'Resize','off',...
            'Color','w',...
            'ColorMap',gray(64),... % Split colormap ??
            'DefaultTextColor','k','DefaultTextInterpreter','none', 'DefaultTextFontName',PF.helvetica, 'DefaultTextFontSize',FS(14),...
            'DefaultAxesColor','w', 'DefaultAxesXColor','k', 'DefaultAxesYColor','k', 'DefaultAxesZColor','k',...
            'DefaultAxesFontName',PF.times,...
            'DefaultPatchFaceColor','k', 'DefaultPatchEdgeColor','k',...
            'DefaultSurfaceEdgeColor','k','DefaultLineColor','k',...
            'DefaultUicontrolFontName',PF.times, 'DefaultUicontrolFontSize',FS(14),...
            'DefaultUicontrolInterruptible','on',...
            'PaperType','A4','PaperUnits','normalized','InvertHardcopy','off','PaperPosition',[.0726 .0644 .854 .870],...
            'Renderer',spm_get_defaults('renderer'),...
            'Visible','off', 'Toolbar','none',...
            'Name','SPM Anatomy Toolbox','Visible','on','units','normalized');
        
        spm_orthviews('Reset');
        spm_orthviews('Image', JuBrain.Vo.fname, [0.18 0.03 1 1]);
        


        
        st.callback = 'se_anatomy(''shopos'');';
        spm_orthviews('Interp',0)
        
        st.WS = [1/1512 1/892 1/1512 1/892]; st.FS = FS;
        
        
        % Top left: coordinates
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[23 705+35+35 294+35 100].*st.WS);
        uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[25 775+35+30 290+35 030].*st.WS,'String','Crosshair Position','FontSize',st.FS(18),'FontWeight','bold');
        uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[40 745+35+35 35 020].*st.WS,'String','mm:','FontSize',st.FS(16));
        uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[40 715+35+35 35 020].*st.WS,'String','vx:','FontSize',st.FS(16));
        st.posmm = uicontrol(st.fig,'Style','edit','units','normalized', 'Position',[85 745+35+35 170+25 020].*st.WS,'String','','Callback','se_anatomy(''setposmm'')','ToolTipString','move crosshairs to mm coordinates','FontSize',st.FS(15));
        st.posvx = uicontrol(st.fig,'Style','edit','units','normalized', 'Position',[85 715+35+35 170+25 020].*st.WS,'String','','Callback','se_anatomy(''setposvx'')','ToolTipString','move crosshairs to voxel coordinates','FontSize',st.FS(15));
        uicontrol(st.fig,'Style','PushButton','units','normalized', 'Position',[300 715+35+35 30 50].*st.WS,'Callback','spm_orthviews(''Reposition'',[0 0 0]);','ToolTipString','move crosshairs to origin','String',{'0';'0';'0'});
        
        
        % Top right: figure controls
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[338+30 705+35+35 224 100].*st.WS);
        zl = spm_orthviews('ZoomMenu'); czlabel = cell(size(zl)); zl = zl(end:-1:1);
        for cz = 1:numel(zl)
            if isinf(zl(cz));       czlabel{cz} = 'Full Volume';
            elseif isnan(zl(cz));   czlabel{cz} = 'BBox (Y > ...)';
            elseif zl(cz) == 0;     czlabel{cz} = 'BBox (nonzero)';
            else;                   czlabel{cz} = sprintf('%dx%dx%dmm', 2*zl(cz), 2*zl(cz), 2*zl(cz));
            end
        end
        uicontrol(st.fig,'Style','Popupmenu','units','normalized', 'Position',[355+30 740+35-2+35 190 30].*st.WS, 'Tag','spm_image:zoom',...
            'String',czlabel,'Callback','spm_image(''zoom'')','ToolTipString','Zoom in by different amounts','FontSize',st.FS(15));
        h = findobj(st.fig,'Tag','spm_image:zoom'); set(h,'value',numel(zl)-1); spm_image('zoom')
        
        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[355+30 770+35-2+35 190 30].*st.WS, 'Tag','spm_image:xhairs',...
            'String','Hide Crosshair', 'UserData', true, 'Callback','spm_image(''Xhairs'');','ToolTipString','Show/hide crosshair','FontSize',st.FS(15));
        
        st.cmap = uicontrol(st.fig,'Style','popupmenu','units','normalized', 'Position',[355+30 710+35-2+35 190 30].*st.WS, 'Tag','spm_image:cmap',...
            'String','Colormap "hot"|Red blobs|Yellow blobs|Green blobs|Cyan blobs|Blue blobs|Magenta blobs', 'Callback','se_anatomy(''cmap'');','ToolTipString','Display style','FontSize',st.FS(15));
        
        
        
        % middle right: overlay controls
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[338+30 495+55+25 224 180+10].*st.WS);
        
        st.overlayon = 0;
        st.spm = uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[355+30 625+55+25+7 190 42].*st.WS,...
            'String','Add SPM','Callback','se_anatomy(''addspm'');','ToolTipString','superimpose activations','FontSize',st.FS(18),'FontWeight','bold');
        st.img = uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[355+30 580+55+25+5 190 42].*st.WS,...
            'String','Add Image','Callback','se_anatomy(''addblobs'');','ToolTipString','superimpose activations','FontSize',st.FS(18),'FontWeight','bold');
        st.rem = uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[355+30 510+55+25+3 190 42].*st.WS,...
            'String','Remove','Callback','','ToolTipString','Remove superimposed activations','FontSize',st.FS(18),'ForegroundColor',[.6 .6 .6]);
        
        % middle left: cyto
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[23 495+55+25 294+35 180+10].*st.WS);
        uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[35 645+55+30 270+35 028+5].*st.WS,'String','Cytoarchitecture (JuBrain)','FontSize',st.FS(20),'FontWeight','bold','HorizontalAlignment','left','Tooltip','Point courser over area name to show reference');
        st.hereArea = uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[35 615+55+34 280+35 25].*st.WS,'String','','FontSize',st.FS(20),'FontWeight','bold','HorizontalAlignment','left');
        st.hereAreas = uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[35 495+55+27 280+35 110+10].*st.WS,'String','','FontSize',st.FS(17),'HorizontalAlignment','left');
        
        % Populate
        xyzmm = spm_orthviews('pos'); xyz = JuBrain.Vo.mat \ [xyzmm; 1]; xyz = round(xyz(1:3));
        set(st.posmm,'String',sprintf('%3.1f  %3.1f   %3.1f',xyzmm));
        set(st.posvx,'String',sprintf('%3.1f   %3.1f   %3.1f',xyz));
        loc = se_CytoForVoxel(xyz,JuBrain); set(st.hereArea,'String',loc{1}); set(st.hereAreas,'String',loc{2});
        
        
        
        % Bottom: Histo assignment
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[23 8 539+30 532+25].*st.WS);
        
        st.title = uicontrol(st.fig,'Style','text','units','normalized','Position',[25 500+25 535+30 30].*st.WS,...
            'String','','FontSize',st.FS(19),'FontWeight','bold');
        
        st.cluster = uicontrol(st.fig,'Style','popupmenu','units','normalized','Position',[25 465+25 290+10 30].*st.WS,...
            'String','No Cluster Available yet','Callback','se_anatomy(''setposclust'')','ToolTipString','move crosshairs to cluster','FontSize',st.FS(18));
        
        st.maxima = uicontrol(st.fig,'Style','popupmenu','units','normalized','Position',[330 465+25 250+10 30].*st.WS,...
            'String','No Maxima Found','Callback','se_anatomy(''setposmax'')','ToolTipString','move crosshairs to maximum','FontSize',st.FS(19));
        
        st.vAssign1 = uicontrol(st.fig,'Style','text','units','normalized','Position',[40 10 515+30 450+15].*st.WS,'HorizontalAlignment','left',...
            'String',{},'FontSize',st.FS(16));
        
        st.clshown = 0;
        
        
        
        % Controls below orthviews
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[1035 340 425 110].*st.WS);
        
        st.print1 = uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1007+35 400 160+15 40].*st.WS,...
            'String','Print Window','Callback','se_anatomy(''printcur'')','FontSize',st.FS(17),'ForegroundColor','k','FontWeight','bold','Tooltip','Print a screenshot');
        
        st.print2 = uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1203+35+15-30 400 160+10 40].*st.WS,...
            'String','Print All Clusters','FontSize',st.FS(17),'ForegroundColor',[.6 .6 .6],'FontWeight','bold');
        
        st.tab = uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1007+35 350 160+15 40].*st.WS,...
            'String','Save Table','FontSize',st.FS(17),'ForegroundColor',[.6 .6 .6],'FontWeight','bold');
        
        uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1203+35+15-30 350 160+10 40].*st.WS,...
            'String','Exit','Callback','se_anatomy(''exit'')','FontSize',st.FS(17),'ForegroundColor','k','FontWeight','bold');
        
        
        uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1363+35+15-10 400 40 40].*st.WS,...
            'String','+','Callback','se_anatomy(''fontup'')','FontSize',st.FS(16),'ForegroundColor',[.8 0 0],'BackgroundColor',[1 1 1],'FontWeight','bold','ToolTipString','Increase Font Size');
        
        uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1363+35+15-10 350 40 40].*st.WS,...
            'String','-','Callback','se_anatomy(''fontdown'')','FontSize',st.FS(16),'ForegroundColor',[.8 0 0],'BackgroundColor',[1 1 1],'FontWeight','bold','ToolTipString','Reduce Font Size');
        
        
        % Macroanatomy
        
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[1025 10 445 300].*st.WS);
        st.MacroArea = uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[1030 280 425 028].*st.WS,'String','Macroanatomy (Harvard-Oxford Atlas)','FontSize',st.FS(19),'FontWeight','bold','HorizontalAlignment','left');
        st.MacroAreas = uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[1030 222 425 55].*st.WS,'String',' ','FontSize',st.FS(14),'HorizontalAlignment','left');
        st.mAssign1 = uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[1030 15 425 210].*st.WS,'String',' ','FontSize',st.FS(14),'HorizontalAlignment','left');
        
        
        try
            load(fullfile(fileparts(which('se_anatomy.m')),'FontSet.mat'));
            st.FontSet = FontSet;
            h = findall(gcf,'-property','FontSize');
            for i=1:numel(h)
                set(h(i),'FontSize',max(get(h(i),'FontSize')+st.FontSet,1));
            end
        catch
            st.FontSet = 0;
        end
        
        
    case 'tab'
        
        [status,values] = fileattrib(pwd);
        if values.UserWrite==1
            [~, ~] = mkdir(pwd,'JuBrain_Images');
            base = strrep(strrep(datestr(datetime),' ','_'),':','-');
            
            fid = fopen(fullfile(pwd,'JuBrain_Images',[base '_Clusters.tsv']),'w+');
            
            fprintf(fid,'%s\n\n',get(st.title,'String'));
            
            titles = get(st.cluster,'string'); titles = titles(2:end);
            titles = strrep(titles,'(','\t'); titles = strrep(titles,'):','\t'); titles = strrep(titles,'/','\t');
            for cl = 1:numel(SPM.Cluster)
                
                fprintf(fid,'%s\n',sprintf(titles{cl})); 
                
                Atlas = JuBrain; keepTrack = []; ind0 = Atlas.Index(SPM.cdat == cl);  Ntotal = numel(ind0); idx = ind0(ind0>0);
                idx = Atlas.mpm(idx); idx = idx(idx>0); [n x] = hist(idx,unique(idx)); x = x(n>0); n = n(n>0);
                
                fprintf(fid,'\n%s\t%s\t%s\n','Assignment based on Maximum Probability Map','Percent of Cluster volume in Area','Percent of Area activated by Cluster');
                if numel(n)>0
                    [B I] = sort(n/Ntotal*100,'descend'); 
                    for i=1:numel(B)
                        fprintf(fid,'%s\t%.1f\t%.1f\n',Atlas.Namen{x(I(i))},B(i),n(I(i))/Atlas.vol(x(I(i)))*100); keepTrack = [keepTrack x(I(i))];
                    end
                end
                
                probs = [Atlas.PMap(:,ind0(ind0>0))]; x = find(mean(probs,2)>0); probs = probs(x,:); 
                fprintf(fid,'\n%s\t%s\t%s\t%s\t%s\t%s\n','Probability exceedance by Area','Mean probability at Cluster location (%)','Mean probability across PMap (%)','Ratio','95% CI','95% CI');
                if numel(x)>0
                    [B I] = sort(mean(probs,2)*100,'descend');  
                    for i=1:numel(B)
                        tmp1 = probs(I(i),:); tmp1 = full(tmp1(tmp1>0)); keepTrack = [keepTrack x(I(i))];
                        tmp2 = Atlas.dist{x(I(i))}; N = [numel(tmp1) numel(tmp2)];
                        exceed = nan(200,1); for loop = 1:200; exceed(loop) = mean(tmp1(randi(N(1),N(1),1)))./mean(tmp2(randi(N(2),N(2),1))); end; exceed = sort(exceed);
                        fprintf(fid,'%s\t%.1f\t%.1f\t%.2f\t%.2f\t%.2f\n',Atlas.Namen{x(I(i))},mean(tmp1)*100,mean(tmp2)*100,mean(tmp1)./(mean(tmp2)),exceed(round(200*.025)),exceed(round(200*.975)));
                    end                    
                end
                
                
                fprintf(fid,'\n%s\t%s\n','Top probabilites at peak voxels','Union across peaks');
                
                idx = Atlas.Index(sub2ind(Atlas.Vo.dim,SPM.Cluster(cl).xyz(1,:)',SPM.Cluster(cl).xyz(2,:)',SPM.Cluster(cl).xyz(3,:)')); da = find(idx>0); idx = idx(idx>0);
                union = 1-prod(1-Atlas.PMap(:,idx),2); [B I] = sort(union,'descend'); I = I(B>0); B = B(B>0);
                for i=1:numel(B) 
                    fprintf(fid,'%s\t%.1f\n',Atlas.Namen{I(i)},B(i)); keepTrack = [keepTrack I(i)];
                end
                
                fullData = full(Atlas.PMap(I,idx)); np = numel(da);
                fprintf(fid,'\n%s','Probabilities at local maxima'); 
                for i = 1:np
                    fprintf(fid,'\t%s',[sprintf('%+.1f', SPM.Cluster(cl).xyzmm(1,da(i))) ' / ' sprintf('%+.1f', SPM.Cluster(cl).xyzmm(2,da(i))) ' / ' sprintf('%+.1f', SPM.Cluster(cl).xyzmm(3,da(i))) ' (Height: ' num2str(SPM.Cluster(cl).peaks(da(i)),'%.2g') ')']); 
                end; fprintf(fid,'\n');

                for a = 1:numel(I)
                    fprintf(fid,'%s',Atlas.Namen{I(a)});
                    for i = 1:np
                        fprintf(fid,'\t%.1f',fullData(a,i)*100);
                    end; fprintf(fid,'\n');
                end

                fprintf(fid,'\n\n%s\n\n','Reference List'); keepTrack = unique(keepTrack); 
                
                    for i=1:numel(keepTrack)
                        fprintf(fid,'%s\n',Atlas.Namen{keepTrack(i)} );
                        fprintf(fid,'%s\n\n',strrep(Atlas.Paper{keepTrack(i)},[char([10]) char([10])],char([10])));
                    end
                    
                    fprintf(fid,'\n\n\n');
                end
                
            status = fclose(fid);
            
            spm('alert',{pwd;[filesep 'JuBrain_Images' filesep base '_Clusters.tsv']},'Cluster data saved',0,false)
        else
            spm('alert',{pwd;'No write permission in current directory'},'Nothing saved',0,false)
        end
        

       
        
    case 'fontup'
        st.FontSet = st.FontSet+2; FontSet = st.FontSet; save(fullfile(fileparts(which('se_anatomy.m')),'FontSet.mat'),'FontSet');
        h = findall(gcf,'-property','FontSize');
        for i=1:numel(h)
            set(h(i),'FontSize',min(get(h(i),'FontSize')+2,25));
        end
        
    case 'fontdown'
        st.FontSet = st.FontSet-2; FontSet = st.FontSet; save(fullfile(fileparts(which('se_anatomy.m')),'FontSet.mat'),'FontSet');
        h = findall(gcf,'-property','FontSize');
        for i=1:numel(h)
            set(h(i),'FontSize',max(get(h(i),'FontSize')-2,2));
        end
        
        
    case 'exit'
        try; delete(st.fig); end
        clear global
        
        
        
    case 'printcur'
        figure(st.fig); addpath(fullfile(fileparts(which('se_anatomy.m')),'export_fig'));
        [status,values] = fileattrib(pwd);
        if values.UserWrite==1
            [~, ~] = mkdir(pwd,'JuBrain_Images');
            export_fig(fullfile(pwd,'JuBrain_Images',[strrep(strrep(datestr(clock),' ','_'),':','-') '.png']));
            spm('alert',{pwd;[filesep 'JuBrain_Images' filesep strrep(strrep(datestr(clock),' ','_'),':','-') '.png']},'Screenshot saved',0,false)
        else
            spm('alert',{pwd;'No write permission in current directory'},'Could not save',0,false)
        end
        
    case 'printallc'
        figure(st.fig); addpath(fullfile(fileparts(which('se_anatomy.m')),'export_fig'));
        
        [status,values] = fileattrib(pwd);
        if values.UserWrite==1
            [~, ~] = mkdir(pwd,'JuBrain_Images');
            
            base = strrep(strrep(datestr(datetime),' ','_'),':','-');
            
            for c=2:numel(st.cluster.String)
                set(st.cluster,'value',c)
                se_anatomy('setposclust')
                export_fig(fullfile(pwd,'JuBrain_Images',[base '_Cluster_' int2str(c-1) '.png']));
            end
            spm('alert',{pwd;[filesep 'JuBrain_Images' filesep base '_Cluster_?.png']},'Cluster images saved',0,false)
        else
            spm('alert',{pwd;'No write permission in current directory'},'Could not save',0,false)
        end
        
        
    case 'addblobs'
        SPM = []; 
       try
            SPM.Vol = spm_vol(spm_select(1,'image','Select overlay image'));
            if numel(SPM.Vol)==1
                SPM.pmult  = spm_input(['Premultiply data by '],'+0','r',1,1);
                SPM.u  = spm_input(['Height threshold (0 for none)'],'+0','r',0,1);
                SPM.k  = spm_input(['Extent threshold (0 for none)'],'+0','r',0,1);
                SPM.title = spm_input('Title','+1','s',spm_str_manip(SPM.Vol.fname,'rt'));
                tmp = (spm_read_vols(SPM.Vol)*SPM.pmult); tmp(isnan(tmp)) = 0; tmp = tmp.*(tmp>SPM.u); Q = find(tmp);
                SPM.Z = tmp(Q); [SPM.XYZ(:,1) SPM.XYZ(:,2) SPM.XYZ(:,3)] = ind2sub(SPM.Vol.dim,Q);
                
                A = spm_clusters(SPM.XYZ'); [n x] = hist(A,1:max(A)); Q = ismember(A,x(n>=SPM.k)); SPM.XYZ = SPM.XYZ(Q,:)'; SPM.Z = SPM.Z(Q);
                set(st.title,'string',['Image: ' SPM.title ' [u=' num2str(SPM.u,'%.1f') ', k=' num2str(SPM.k,'%.0f') ']'])
                se_anatomy('procoverlay');
            else
                SPM = [];
            end
        catch
            SPM = [];
        end
        
        
        
        
    case 'addspm'
        SPM = []; spm_figure('Clear','Interactive')
        try
            cwd = pwd; [tmp1,tmp2] = spm_getSPM; SPM.Vol = tmp2.Vspm(1); cd(cwd);
            SPM.title = spm_input('Title','+1','s',tmp2.title);
            SPM.u = tmp2.u; SPM.k = tmp2.k;
            SPM.Z = tmp2.Z; SPM.XYZ = tmp2.XYZ;
            
            set(st.title,'string',['SPM: ' SPM.title ' [' tmp2.thresDesc ', k=' num2str(SPM.k,'%.0f') ']'])
            
            se_anatomy('procoverlay');
        catch
            SPM = [];
        end
        
        
    case 'cmap'
        if or(st.overlayon>0,nargin==2)
            spm_orthviews('rmblobs',1);
            c = get(st.cmap,'value');
            if c > 1
                colours = [1 0 0;1 1 0;0 1 0;0 1 1;0 0 1;1 0 1];
                spm_orthviews('addcolouredblobs',1,SPM.XYZ,sqrt(SPM.Z),SPM.Vol.mat,colours(c-1,:));
            else
                spm_orthviews('AddBlobs',1,SPM.XYZ,SPM.Z-min(SPM.Z),SPM.Vol.mat);
            end
            try; delete(st.vols{1}.blobs{1}.cbar); st.vols{1}.blobs{1} = rmfield(st.vols{1}.blobs{1},'cbar'); end
            spm_orthviews('Redraw');
        end
        
        
        
    case 'procoverlay'
        
        spm_figure('Clear','Interactive')
        
        if min(SPM.Z)==max(SPM.Z);
            cog = (mean(SPM.XYZ'));  cog = ((SPM.XYZ(1,:)-cog(1)).^2)+((SPM.XYZ(2,:)-cog(2)).^2)+((SPM.XYZ(3,:)-cog(3)).^2);
            SPM.Z=ones(size(SPM.Z)); SPM.Z(find(cog==min(cog))) = 1.1;
        end
        
        SPM.Z(isinf(SPM.Z)) = spm_invNcdf(1-eps);
        
        se_anatomy('cmap',1);
        
        A = spm_clusters(SPM.XYZ);
        for cl=1:max(A)
            [voxel maxZ maxXYZ dummy] = spm_max(SPM.Z(A == cl),SPM.XYZ(:,A == cl)); if size(maxZ,1)>size(maxZ,2); maxZ = maxZ'; end
            SPM.Cluster(cl).voxel = voxel(1);
            [maxZ I] = sort(maxZ,'descend'); maxXYZ  = maxXYZ(:,I); Q = ones(size(maxZ));
            for d = 2:numel(maxZ)
                if sqrt(sum(bsxfun(@times,bsxfun(@minus,maxXYZ(:,d),maxXYZ(:,(1:numel(maxZ))<d & Q>0)),abs(diag(SPM.Vol.mat(1:3,1:3)))).^2))<5; Q(d) = 0; end
            end
            OK = find(Q>0,10,'first'); Q(OK(end)+1:end) = NaN;
            SPM.Cluster(cl).peaks = maxZ(Q>0); tmp   = maxXYZ(:,Q>0);
            SPM.Cluster(cl).xyzmm = SPM.Vol.mat * [tmp; ones(1,size(tmp,2))]; SPM.Cluster(cl).xyzmm = SPM.Cluster(cl).xyzmm(1:3,:);
            SPM.Cluster(cl).xyz = round(JuBrain.Vo.mat \ SPM.Vol.mat * [tmp; ones(1,size(tmp,2))]); SPM.Cluster(cl).xyz = SPM.Cluster(cl).xyz(1:3,:);
            
        end
        
        [~, I] = sort([SPM.Cluster.voxel],'descend'); SPM.Cluster = SPM.Cluster(I);
        A2 = nan(size(A)); for cl=1:numel(I); A2(A==cl) = find(I==cl); end
        in = accumarray(SPM.XYZ',A2',SPM.Vol.dim); out = zeros(JuBrain.Vo.dim);
        for p=1:JuBrain.Vo.dim(3)
            TM0 = [ 1 0 0 -JuBrain.Vo.mat(1,4); 0 1 0 -JuBrain.Vo.mat(2,4); 0 0 1 -(p+JuBrain.Vo.mat(3,4)); 0 0 0 1];
            out(:,:,p) = spm_slice_vol(in,inv(TM0*st.vols{1}.blobs{1}.mat),JuBrain.Vo.dim(1:2),[0 NaN]);
        end
        SPM.cdat = uint8(out);
        
        
        clust{1} = 'No cluster selected';
        for cl=1:numel(SPM.Cluster)
            clust{cl+1,1} = ['Cluster ' int2str(cl) ' ('  int2str(SPM.Cluster(cl).voxel)  ' vox): '...
                sprintf('%+.0f', SPM.Cluster(cl).xyzmm(1,1)) '/' sprintf('%+.0f', SPM.Cluster(cl).xyzmm(2,1)) '/' sprintf('%+.0f', SPM.Cluster(cl).xyzmm(3,1))];
        end
        set(st.cluster,'String',clust);
        
        set(st.spm,'ForegroundColor',[.6 .6 .6],'FontWeight','normal','Callback','','FontWeight','normal');
        set(st.img,'ForegroundColor',[.6 .6 .6],'FontWeight','normal','Callback','','FontWeight','bold');
        set(st.rem,'ForegroundColor','k','Callback','se_anatomy(''removeblobs'');','FontWeight','bold');
        set(st.print2,'ForegroundColor','k','Callback','se_anatomy(''printallc'');','Tooltip','Print a screenshot for every cluster');
        set(st.tab,'ForegroundColor','k','Callback','se_anatomy(''tab'');','Tooltip','Save assignment for all clusters as tsv');
        
        
        st.overlayon = 1; st.clshown = 0;
        
        
        
        
        
        
    case 'setposclust'
        poscl = get(st.cluster,'Value')-1;
        if poscl > 0
            spm_orthviews('Reposition',SPM.Cluster(poscl).xyzmm(:,1));
            se_anatomy('shopos')
        end
        
        
    case 'setposmax'
        try
            spm_orthviews('Reposition',SPM.Cluster(get(st.cluster,'Value')-1).xyzmm(:,get(st.maxima,'Value')));
        end
        
        
    case 'removeblobs'
        spm_orthviews('rmblobs',1); SPM = []; spm_figure('Clear','Interactive')
        set(st.spm,'ForegroundColor','k','FontWeight','bold','Callback','se_anatomy(''addspm'');');
        set(st.img,'ForegroundColor','k','FontWeight','bold','Callback','se_anatomy(''addblobs'');');
        set(st.rem,'ForegroundColor',[.6 .6 .6],'FontWeight','normal','Callback','');
        set(st.print2,'ForegroundColor',[.6 .6 .6],'Callback','','Tooltip','');
        set(st.tab,'ForegroundColor',[.6 .6 .6],'Callback','','Tooltip','');
        
        set(st.cluster,'String','No Cluster Available yet','value',1);
        set(st.maxima,'String','No Maxima Found','value',1);
        set(st.title,'String','');
        set(st.vAssign1,'string','');
        set(st.mAssign1,'string','');
        st.clshown = 0;
        
        st.overlayon = 0; st.clshown = 0;
        
        
    case 'shopos'
        % The position of the crosshairs has been moved
        %----------------------------------------------------------------------
        xyzmm = spm_orthviews('pos'); xyz = JuBrain.Vo.mat \ [xyzmm; 1]; xyz = round(xyz(1:3));
        set(st.posmm,'String',sprintf('%6.1f  %6.1f   %6.1f',xyzmm));
        set(st.posvx,'String',sprintf('%6.1f   %6.1f   %6.1f',xyz));
        set(st.MacroArea,'Tooltip',''); set(st.MacroAreas,'Tooltip','');
        set(st.hereArea,'Tooltip',''); set(st.hereAreas,'Tooltip','');

        [loc, ref] = se_CytoForVoxel(xyz,JuBrain,5); set(st.hereArea,'String',loc{1}); set(st.hereAreas,'String',loc{2});
        if numel(ref{1})> 0; set(st.hereArea,'Tooltip',sprintf(ref{1})); end; 
        if numel(ref{2})> 0; set(st.hereAreas,'Tooltip',sprintf(ref{2})); end; 
        
        loc = se_CytoForVoxel(xyz,Macro,2); set(st.MacroArea,'String',['Macroanatomy: ' loc{1}]); set(st.MacroAreas,'String',loc{2});
        if numel(loc{1})> 0; set(st.MacroArea,'Tooltip',Macro.Ref); end; 
        if numel(loc{2})> 0; set(st.MacroArea,'Tooltip',Macro.Ref); end; 
        
        
        if st.overlayon
            if SPM.cdat(xyz(1),xyz(2),xyz(3))>0
                poscl = SPM.cdat(xyz(1),xyz(2),xyz(3));
                set(st.cluster,'Value',poscl+1);
                
                if st.clshown~=poscl
                    
                    clust = {' '};
                    for cl=1:numel(SPM.Cluster(poscl).peaks)
                        clust{cl,1} = ['('  num2str(SPM.Cluster(poscl).peaks(cl),'%.3g') '):  '...
                            sprintf('%+3.0f', SPM.Cluster(poscl).xyzmm(1,cl)) ' / ' sprintf('%+3.0f', SPM.Cluster(poscl).xyzmm(2,cl)) ' / ' sprintf('%+3.0f', SPM.Cluster(poscl).xyzmm(3,cl))];
                    end
                    set(st.maxima,'String',clust,'Tooltip',sprintf('Jump to local maxima\nValues of the overlay at these peaks are provided in parentheses'));
                    
                    
                    if isfield(SPM.Cluster(poscl),'vText1') && numel(SPM.Cluster(poscl).vText1)>0; else
                        
                        [SPM.Cluster(poscl).vText1 SPM.Cluster(poscl).vRef1] = se_assignment(SPM,poscl,xyz,JuBrain,5);
                        [SPM.Cluster(poscl).mText1 SPM.Cluster(poscl).mRef1] = se_assignment(SPM,poscl,xyz,Macro,2);
                        
                    end
                    
                    set(st.vAssign1,'string',SPM.Cluster(poscl).vText1,'Tooltip',sprintf(SPM.Cluster(poscl).vRef1));
                    set(st.mAssign1,'string',SPM.Cluster(poscl).mText1,'Tooltip',sprintf(SPM.Cluster(poscl).mRef1));
                    st.clshown=SPM.cdat(xyz(1),xyz(2),xyz(3));
                    
                end
            else
                set(st.vAssign1,'string',' ','Tooltip',''); st.clshown = 0;
                set(st.mAssign1,'string',' ','Tooltip','');
                set(st.maxima,'String',' ','Tooltip','');
            end
        end
        
        
    case 'setposmm'
        % Move the crosshairs to the specified position {mm}
        %----------------------------------------------------------------------
        pos = sscanf(get(st.posmm,'String'), '%g %g %g');
        if length(pos)==3
            spm_orthviews('Reposition',pos);
            se_anatomy('shopos')
        end
        
        
    case 'setposvx'
        % Move the crosshairs to the specified position {vx}
        %----------------------------------------------------------------------
        pos = sscanf(get(st.posvx,'String'), '%g %g %g');
        if length(pos)==3
            tmp = st.vols{1}.premul*st.vols{1}.mat;
            pos = tmp(1:3,:)*[pos ; 1];
            spm_orthviews('Reposition',pos);
            se_anatomy('shopos')
        end
        
        
        
end




function [loc, ref] = se_CytoForVoxel(xyzv,Atlas,cut)
global st

index = Atlas.Index(min(max(xyzv(1),1),size(Atlas.Index,1)),min(max(xyzv(2),1),size(Atlas.Index,2)),min(max(xyzv(3),1),size(Atlas.Index,3)));

ref = {'',''};

if index == 0
    loc = {'',''};
    return
    
else
    
    try
        idx = Atlas.mpm(index);
        loc{1,1} = Atlas.Namen{idx};
        ref1 = Atlas.Paper{idx};
        
    catch
        loc{1,1} = '';
        ref1 = [];
    end
    
    ref2 = [];
    
    [a, ~, B] = find(Atlas.PMap(:,index)); [B I] = sort(B,'descend'); B = B(B>.01);
    if numel(B)>0
        for i=1:min(cut,numel(B))
            tmp{i,1} = [sprintf('%4.1f',B(i)*100) '%   ' Atlas.Namen{a(I(i))}];
            if isfield(Atlas,'Paper')
                ref2 = [ref2 Atlas.Namen{a(I(i))} '\n'];
                ref2 = [ref2 Atlas.Paper{a(I(i))} '\n'];
            end
        end
        loc{2,1} = tmp;
    else
        loc{2,1} = '';
    end
    ref = {ref1, ref2};
end



function [vText1, vRef1] = se_assignment(SPM,poscl,xyz,Atlas,cut)


loc = {' '}; lon = {' '}; vRef1 = ''; keepTrack = [];
ind0 = Atlas.Index(SPM.cdat == SPM.cdat(xyz(1),xyz(2),xyz(3))); Ntotal = numel(ind0); idx = ind0(ind0>0);
idx = Atlas.mpm(idx); idx = idx(idx>0); [n x] = hist(idx,unique(idx)); x = x(n>0); n = n(n>0);
probs = [Atlas.PMap(x,ind0(ind0>0))];

if numel(n)>0
    [B I] = sort(n/Ntotal*100,'descend'); B = B(B>2.5);
    loc{1} = 'Assignment based on Maximum Probability Map';
    lon{1} = 'Probability exceedance (under cluster vs. entire map)';
    resort = nan(1,min(numel(B),6)); resort(1) = Inf;
    
    keepTrack = [keepTrack x(I(1:min(numel(B),cut)))];
    for i=1:min(numel(B),cut)
        
        if B(i)<10; loc{i+1} = ['  ' ' ' num2str(B(i),'%.1f') '%  in  ' Atlas.Namen{x(I(i))} '   [' num2str(n(I(i))/Atlas.vol(x(I(i)))*100,'%.1f') ' activated]'];
        else;       loc{i+1} = ['  ' num2str(B(i),'%.1f') '%  in  ' Atlas.Namen{x(I(i))} '   [' num2str(n(I(i))/Atlas.vol(x(I(i)))*100,'%.1f') ' activated]']; end
        
        exceed = nan(200,1);
        tmp1 = probs(I(i),:); tmp1 = full(tmp1(tmp1>0));
        tmp2 = Atlas.dist{x(I(i))}; N = [numel(tmp1) numel(tmp2)];
        for loop = 1:200; exceed(loop) = mean(tmp1(randi(N(1),N(1),1)))./mean(tmp2(randi(N(2),N(2),1))); end
        exceed = sort(exceed);
        lon{i+1} = ['  ' num2str(mean(tmp1)./(mean(tmp2)),'%.2f') ' [' num2str(exceed(5),'%.2f') '; '  num2str(exceed(195),'%.2f') '] for ' Atlas.Namen{x(I(i))}];
        resort(i+1) = exceed(100);
    end
    [B I] = sort(resort,'descend'); lon = lon(I(B>.5));
end

idx = Atlas.Index(sub2ind(Atlas.Vo.dim,SPM.Cluster(poscl).xyz(1,:)',SPM.Cluster(poscl).xyz(2,:)',SPM.Cluster(poscl).xyz(3,:)')); idx = idx(idx>0);
union = 1-prod(1-Atlas.PMap(:,idx),2);
[B I] = sort(union,'descend'); B = B(B>.4);

if numel(B)>0
    keepTrack = [keepTrack I(1:min(numel(B),cut))'];
    lop{1} = 'Top probabilites at peak voxels (union)';
    for i=1:min(numel(B),cut)
        lop{i+1} = ['  ' num2str(B(i),'%.2f') ' for ' Atlas.Namen{I(i)}];
    end
else
    lop{1} = ' ';
end
vText1 = {loc{:} ' ' lon{:} ' '  lop{:}}';
if cut == 2 & numel(vText1)>0
    vRef1 = Atlas.Ref;
elseif cut>2
    keepTrack = unique(keepTrack);
    for i=1:numel(keepTrack)
        vRef1 = [vRef1 Atlas.Namen{keepTrack(i)} '\n'];
        vRef1 = [vRef1 Atlas.Paper{keepTrack(i)} '\n'];
        
    end
end
