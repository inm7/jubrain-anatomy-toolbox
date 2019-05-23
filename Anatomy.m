I = imread('Titel.png');
a = get(0,'ScreenSize');
figure(99), clf; image(I), axis off, set(gca,'OuterPosition',[0 0 1 1],'Position',[0 0 1 1]),
set(gcf,'MenuBar','none','Position',[round((a(3)-round((a(4)-60)/size(I,1)*size(I,2)))/2) 60 round((a(4)-60)/size(I,1)*size(I,2)*.95) a(4)-80])

width = round((a(4)-60)/size(I,1)*size(I,2)*.95); hight = a(4);

uicontrol(gcf,'Style','Pushbutton', 'Position',[.05.*width .025*hight .4.*width .075*hight],...
    'String','Atlas & Assignment Tool', 'Callback','se_anatomy(''init'');','ToolTipString',sprintf('Explore  the JuBrain atlas\nOverlay activation data\nAnatomically assign imaging results'),'FontSize',18,'FontWeight','bold');

uicontrol(gcf,'Style','Pushbutton', 'Position',[.55.*width .025*hight .4.*width .075*hight],...
    'String','ROI Tool', 'Callback','se_ROItools(''init'');','ToolTipString',sprintf('Create anatomical masks from JuBrain'),'FontSize',18,'FontWeight','bold');

