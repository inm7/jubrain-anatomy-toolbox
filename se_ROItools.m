function se_ROItools(action,varargin)


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
        
        try
            load(spm_select(1,'mat','Select JuBrain Data File',[],spm_str_manip(which('se_anatomy.m'),'H'),'JuBrain_Data_'));
        catch
            load(fullfile(fileparts(which('se_anatomy.m')),'JuBrain_Data_public_v30.mat'))
        end
        
        FS = [1:36]+1; PF = spm_platform('fonts'); S0 = get(0,'ScreenSize'); WS = [1 1 S0(3:4)./[1680 1050]];
        
        st.fig    = figure(...
            'Tag','Graphics',...
            'Position',[85 105 1512 892].*WS,...
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

        st.WS = [1/1512 1/892 1/1512 1/892]; st.FS = FS;
        st.FontSize = 0;
        
        
        for i=1:numel(JuBrain.Lobes)
            st.lobe(i) = uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[25 780-(i-1)*60 190 50].*st.WS,...
                'String',JuBrain.Lobes{i}, 'Callback',['se_ROItools(''selectgroup'',' int2str(i) ');'],'ToolTipString',['Select ' JuBrain.Lobes{i} ' regions'],'FontSize',st.FS(20),'FontWeight','bold');
        end
        
        JuBrain.selected = zeros(numel(JuBrain.Namen),2);
        
        for i=1:numel(JuBrain.Namen)
            tmp = JuBrain.Namen{i}; % (1:strfind(JuBrain.Namen{i},'(')-1); if length(tmp) == 0; tmp = JuBrain.Namen{i}; end
            JuBrain.List{i,1} = ['Left ' tmp];
            JuBrain.List{i,2} = ['Right ' tmp];
            JuBrain.List{i,3} = ['Bilateral ' tmp];
        end
        
        st.wasLobe = 2; se_ROItools('selectgroup',1); 
       
        uicontrol(st.fig,'Style','Frame','units','normalized','Position',[1100 400 320 430].*st.WS);
        
        uicontrol(st.fig,'Style','Text','units','normalized', 'Position',[1112 800 270+35 025].*st.WS,'String','Selected regions','FontSize',st.FS(20),'FontWeight','bold','HorizontalAlignment','left');
        st.List = uicontrol(st.fig,'Style','edit','units','normalized','Position',[1102 402 316 385].*st.WS,'HorizontalAlignment','left',...
            'String',{''},'FontSize',st.FS(18),'Min',0, 'Max',2);

        
        
        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[240 25 190 50].*st.WS,...
            'String','Clear all', 'Callback','se_ROItools(''clearall'');','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor','b');

        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[240 80 190 50].*st.WS,...
            'String','Clear page', 'Callback','se_ROItools(''clearpage'');','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor','b');

        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[435 25 190 50].*st.WS,...
            'String','Select all', 'Callback','se_ROItools(''selall'');','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor',[0 .5 0]);

        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[435 80 190 50].*st.WS,...
            'String','Select page', 'Callback','se_ROItools(''selpage'');','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor',[0 .5 0]);

        
        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[715 25 330 50].*st.WS,...
            'String','Create individual ROIs', 'Callback','se_ROItools(''roi'',1);','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor','k');

        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[715 80 330 50].*st.WS,...
            'String','Create joint ROI (all selected)', 'Callback','se_ROItools(''roi'',2);','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor','k');


        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[1100 80 320 50].*st.WS,...
            'String','Extract data per ROI', 'Callback','se_ROItools(''extract'');','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor','k');

        uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[1300 25 120 50].*st.WS,...
            'String','Exit', 'Callback','se_ROItools(''exit'');','FontSize',st.FS(20),'FontWeight','bold','ForegroundColor','k');
        
        
        uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1150 25 40 40].*st.WS,...
            'String','+','Callback','se_ROItools(''fontup'')','FontSize',st.FS(20),'ForegroundColor',[.8 0 0],'BackgroundColor',[1 1 1],'FontWeight','bold','ToolTipString','Increase Font Size');

        uicontrol(st.fig,'Style','pushbutton','units','normalized','Position',[1200 25 40 40].*st.WS,...
            'String','-','Callback','se_ROItools(''fontdown'')','FontSize',st.FS(20),'ForegroundColor',[.8 0 0],'BackgroundColor',[1 1 1],'FontWeight','bold','ToolTipString','Reduce Font Size');

        
        
        
    case 'fontup'
        h = findall(gcf,'-property','FontSize'); st.FontSize = st.FontSize+2;
        for i=1:numel(h)
            set(h(i),'FontSize',min(get(h(i),'FontSize')+2,25));
        end
        
    case 'fontdown'
        h = findall(gcf,'-property','FontSize'); st.FontSize = st.FontSize-2;
        for i=1:numel(h)
            set(h(i),'FontSize',max(get(h(i),'FontSize')-2,2));
        end

        
    case 'exit'
        try; delete(st.fig); end
        clear global
        
        
    case 'extract'
        
        if sum(JuBrain.selected(:))>0
            Vi = spm_vol(spm_select(Inf,'any','Select images (3D/4D)',[],[],{'\.nii$','\.img$','\.nii.gz$'})); cnt = 0;  sides = {'Left '; 'Right '};
            for v = 1:numel(Vi); Input{v} = [Vi(1).fname ' -> ' int2str(Vi(v).n(1))]; end
            Name = spm_input('Title','1','s',strrep(strrep(datestr(clock),' ','_'),':','-'));
            
            for i=1:numel(JuBrain.Namen)
                for side = 1:2
                    if JuBrain.selected(i,side)>0
                        clear XYZ; [XYZ(:,1) XYZ(:,2) XYZ(:,3)] = ind2sub(JuBrain.Vo.dim,JuBrain.idx(JuBrain.mpm==i & JuBrain.lr==side));
                        cnt = cnt+1; Region{cnt,1} = [sides{side} JuBrain.Files{i}]; Volume(cnt,1) = size(XYZ,1);
                        for v = 1:numel(Vi)
                            sXYZ = Vi(v).mat \ JuBrain.Vo.mat * [XYZ'; ones(1,size(XYZ,1))];
                            tmp = (spm_sample_vol(Vi(v),sXYZ(1,:),sXYZ(2,:),sXYZ(3,:),1)); tmp(isnan(tmp)) = 0;
                            dat(cnt,v) = sum(tmp);
                        end
                    end
                end
            end
            
            [~, ~] = mkdir(pwd,'JuBrain_Extracted'); buffer = zeros(JuBrain.Vo.dim); sides = {'Left_'; 'Right_'};
            
            [Region, idx] = sort(Region); Volume = Volume(idx); dat = dat(idx,:);
            save(fullfile(pwd,'JuBrain_Extracted',[Name '.mat']),'Region','Volume','dat','Input')
                        
            fid = fopen(fullfile(pwd,'JuBrain_Extracted',[Name '.txt']),'w+'); fprintf(fid,['%s\t' repmat('%s\t',1,size(dat,1)) '\n'],'Files used',Region{:}); 
            for roi = 1:size(dat,2); fprintf(fid,['%s\t' repmat('%-10.4f\t',1,size(dat,1)) '\n'],Input{roi},dat(:,roi)); end; fclose(fid);
            
        end

        
        
    case 'roi'
        if varargin{1} == 2
            Name = spm_input('Title','1','s',strrep(strrep(datestr(clock),' ','_'),':','-'));
        end
        
        [~, ~] = mkdir(pwd,'JuBrain_ROIs'); buffer = zeros(JuBrain.Vo.dim); sides = {'Left_'; 'Right_'};
        for i=1:numel(JuBrain.Namen)
            for side = 1:2
                if JuBrain.selected(i,side)>0
                    tmp = buffer; tmp(JuBrain.idx(JuBrain.mpm==i & JuBrain.lr==side)) = 1;
                    if varargin{1}==2
                        buffer = buffer+tmp;
                    else
                        Vo = rmfield(JuBrain.Vo,{'pinfo','private'}); Vo.dt = [2 0]; Vo.fname = fullfile(pwd,'JuBrain_ROIs',[sides{side} JuBrain.Files{i} '.nii']); 
                        Vo = spm_write_vol(Vo,tmp); gzip(Vo.fname); delete(Vo.fname);
                    end
                end
            end
        end
        if varargin{1}==2
            buffer = buffer>0;
            Vo = rmfield(JuBrain.Vo,{'pinfo','private'}); Vo.dt = [2 0]; Vo.fname = fullfile(pwd,'JuBrain_ROIs',[Name '.nii']);
            Vo = spm_write_vol(Vo,buffer); gzip(Vo.fname); delete(Vo.fname);

        end
        
        
        
        
        
    case 'clearall'
        JuBrain.selected = zeros(numel(JuBrain.Namen),2);
        tmp = st.wasLobe; st.wasLobe = -1;
        se_ROItools('selectgroup',tmp); 
        se_ROItools('updatelist'); st.wasLobe = tmp;
        
    case 'clearpage'
        JuBrain.selected(JuBrain.Group(st.wasLobe).IDs,:) = 0;
        tmp = st.wasLobe; st.wasLobe = -1;
        se_ROItools('selectgroup',tmp); 
        se_ROItools('updatelist'); st.wasLobe = tmp;
        
    case 'selall'
        JuBrain.selected = ones(numel(JuBrain.Namen),2);
        tmp = st.wasLobe; st.wasLobe = -1;
        se_ROItools('selectgroup',tmp); 
        se_ROItools('updatelist'); st.wasLobe = tmp;
        
    case 'selpage'
        JuBrain.selected(JuBrain.Group(st.wasLobe).IDs,:) = 1;
        tmp = st.wasLobe; st.wasLobe = -1;
        se_ROItools('selectgroup',tmp); 
        se_ROItools('updatelist'); st.wasLobe = tmp;

        
        
        
    case 'selectgroup'
        select = varargin{1};
        if select~=st.wasLobe
                        ;

            if st.wasLobe>0
                set(st.lobe(st.wasLobe),'ForegroundColor','k','FontSize',max(get(st.lobe(st.wasLobe),'FontSize')-2,2));
                set(st.lobe(select),'ForegroundColor','r','FontSize',max(get(st.lobe(select),'FontSize')+2,2)); 
            end
            st.wasLobe = select;
            
            try; delete(st.area), st.area = []; delete(st.LR), st.LR = []; end
            
            colors = 'kr'; style = {'normal','bold'};
            for i=1:numel(JuBrain.Group(select).IDs)
                
                if i<18; offset = 1; x = 10;
                else; offset = 18; x = 430;
                end
                
                st.LR(i,1) = uicontrol(st.fig,'Style','togglebutton','units','normalized','Position',[230+x 795-(i-offset)*40 25 35].*st.WS,'String','L','FontSize',st.FS(20)+st.FontSize,...
                    'Callback',['se_ROItools(''pushbutton'',' int2str(i) ',1,' int2str(JuBrain.Group(select).IDs(i)) ');'],...
                    'ForegroundColor',colors(1+JuBrain.selected(JuBrain.Group(select).IDs(i),1)),'FontWeight',style{1+JuBrain.selected(JuBrain.Group(select).IDs(i),1)});
                st.LR(i,2) = uicontrol(st.fig,'Style','togglebutton','units','normalized','Position',[255+x 795-(i-offset)*40 25 35].*st.WS,'String','R','FontSize',st.FS(20)+st.FontSize,...
                    'Callback',['se_ROItools(''pushbutton'',' int2str(i) ',2,' int2str(JuBrain.Group(select).IDs(i)) ');'],...
                    'ForegroundColor',colors(1+JuBrain.selected(JuBrain.Group(select).IDs(i),2)),'FontWeight',style{1+JuBrain.selected(JuBrain.Group(select).IDs(i),2)});
                
                st.area(i) = uicontrol(st.fig,'Style','Pushbutton','units','normalized', 'Position',[285+x 795-(i-offset)*40 330 35].*st.WS,...
                    'String',JuBrain.Namen{JuBrain.Group(select).IDs(i)},...
                    'Callback',['se_ROItools(''selectarea'',' int2str(i) ',' int2str(JuBrain.Group(select).IDs(i)) ');'],...
                    'ToolTipString',[JuBrain.Paper{JuBrain.Group(select).IDs(i)}],'FontSize',st.FS(20)+st.FontSize);
            end
            
        end
        

    case 'selectarea'
        
        i = varargin{1}; idx = varargin{2};
        
        set(st.LR(i,1),'value',double(~JuBrain.selected(idx,1))); se_ROItools('Pushbutton',i,1,idx);
        set(st.LR(i,2),'value',double(~JuBrain.selected(idx,2))); se_ROItools('Pushbutton',i,2,idx);
        

        
        
    case 'pushbutton'
        
        i = varargin{1}; side = varargin{2}; idx = varargin{3};
        
        JuBrain.selected(idx,side) = get(st.LR(i,side),'value');
        if JuBrain.selected(idx,side)==1
            set(st.LR(i,side),'ForegroundColor','r','FontWeight','bold')
            
        else
            set(st.LR(i,side),'ForegroundColor','k','FontWeight','normal')
        end
        se_ROItools('updatelist');
        
        
    case 'updatelist'
        
        tmp = JuBrain.selected; tmp(:,3) = sum(tmp,2)==2; tmp(tmp(:,3)==1,1:2) = 0; 
        list = sort(JuBrain.List(tmp>0)); 
        set(st.List,'String',list);
        
end

