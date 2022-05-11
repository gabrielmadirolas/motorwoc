
close all
clearvars

load motorwoc_methods01_data
toAllFigNames = 'motorwoc_Fig01CD';

% parameters for the figures

saveFigs = true; % wanna save the figures? 
pauseFigs = false; % pause after each figure is created

scale_factor = 1;
line_width = 5 * scale_factor; 
marker_size = 30 * scale_factor; 
legend_size = 15 * scale_factor; 

% to adjust the size of the axes to the shape of the tablet screen:
propAxes = gd.mmYScreen/gd.mmXScreen;
currentFig = 0;

figure

set(gcf, 'InvertHardcopy', 'off')
set(gcf,'units','centimeters')
% set(gca,'units','centimeters')
set(gcf,'color',[1 1 1])
posFig = get(gcf,'position');
set(gcf,'position', [posFig(1) posFig(2)/4 posFig(3) 0.8*posFig(3)])
posFigNew = get(gcf,'position');
set(gca,'color',0.75*ones(1,3))
posAxes = get(gca,'position');
set(gca,'position',[posAxes(1), 0.45-propAxes*posAxes(3)/2, posAxes(3), propAxes*posAxes(3)/0.8])
posAxNew = get(gca,'position');
% set(gcf,'position', [posFigNew(1:3) posFigNew(3)])
% posFigZoom = get(gcf,'position');
% set(gca,'position',[posAxes(1:3) posAxes(3)])
% posAxZoom = get(gca,'position');
set(gcf,'position', [posFigNew(1:2) posFigNew(4) posFigNew(4)])
posFigZoom = get(gcf,'position');
set(gca,'position',[posAxes(1:2) 0.9*posAxes(4) 0.9*posAxes(4)])
posAxZoom = get(gca,'position');

colors = get(gca,'colororder');
colors = [colors; [0 0 0]];
% colInds = [1 3 4 5 6];
colWoc = 2;

xLims = gd.pix2mm * [0 gd.pixelsXScreen];
yLims = gd.pix2mm * [0 gd.pixelsYScreen];

% a = 0.098; % when using 4th segment of subj 1, and zooming on the left
% b = 0.66; % when using 4th segment of subj 1, and zooming on the left
% a = 0.847; % old parameters from ver01
% b = 0.605; % old parameters from ver01
a = 0.85; 
b = 0.606; 
xCorner = a * xLims(2);
yCorner = b * yLims(2);
propSide = 0.09; % Proportion of the side of the region slected

xLimsZoom = [xCorner xCorner+propSide*range(xLims)];
yLimsZoom = [yCorner yCorner+propSide*range(xLims)];

% to make the ellipse a bit bigger:
margRemove = 0.04;
xLims = [margRemove*range(xLims) xLims(2)-margRemove*range(xLims)];
yLims = [margRemove*range(yLims) yLims(2)-margRemove*range(yLims)];

close


% zoom to ROI

fZoom = figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigZoom);
set(gca,'Position',posAxZoom, 'XColor','none','YColor','none')

xlim(xLimsZoom)
ylim(yLimsZoom)

for n = 1:nBins
    plot(newVerts(n,1:2:3),newVerts(n,2:2:4),'--k')
end

% sub-sample

% shapeSoft = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 0.5],'linewidth',0.25*lineWidths);
shapeNormal = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 1],'linewidth',0.25*line_width);
groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',colors(end,:),...
    'markerfacecolor',colors(end,:),'markerSize',0.25*marker_size,'linewidth',0.5*line_width);


if saveFigs
    currentFig = currentFig + 1;
    toName =[toAllFigNames '_' sprintf('%02u',currentFig)] ;

    set(gcf,'units','centimeters')
    pos=get(gcf,'Position');
    set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
    print('-djpeg','-r600',[toName '.jpeg'])
    savefig(toName)
end
if pauseFigs
    pause
end




% now show only subsampled individual trajectory plus ground truth dots

groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',colors(end,:),...
    'markerfacecolor',colors(end,:),'markerSize',0.25*marker_size,'linewidth',0.5*line_width);
pExaIndivTraj = plot(xIndivTrajec(:,1),yIndivTrajec(:,1),...
    'color',[colors(1,:) 0.5],'linewidth',1);
pExaRound = plot(xIndivTrajec(:,1),yIndivTrajec(:,1),'o','color',colors(1,:),...
    'markerfacecolor',colors(1,:),'markerSize',0.25*marker_size,'linewidth',0.5*line_width);


if saveFigs
    currentFig = currentFig + 1;
    toName =[toAllFigNames '_' sprintf('%02u',currentFig)] ;

    set(gcf,'units','centimeters')
    pos=get(gcf,'Position');
    set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
    print('-djpeg','-r600',[toName '.jpeg'])
    savefig(toName)
end
if pauseFigs
    pause
end



% add scale annotation

axPos = get(gca,'position');

xRangeZoom = range(xLimsZoom);
yRangeZoom = range(yLimsZoom);

linPos = nan(1,4);
linPos(1) = 0.7;
linPos(2) = 0.75;
linPos(3) = 5*axPos(3)/xRangeZoom;
linPos(4) = 0;

anLine = annotation('line','linewidth',line_width,'position',linPos);

anText = annotation('textbox','Position',[linPos(1) 1.02*linPos(2) linPos(3) 0.1],...
        'String','5 mm','FontSize',legend_size,'LineStyle','none',...
        'horizontalalignment','center','verticalalignment','bottom','margin',0);

    
if saveFigs
    currentFig = currentFig + 1;
    toName =[toAllFigNames '_' sprintf('%02u',currentFig)] ;

    set(gcf,'units','centimeters')
    pos=get(gcf,'Position');
    set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
    print('-djpeg','-r600',[toName '.jpeg'])
    savefig(toName)
end
if pauseFigs
    pause
end    
    
delete(anLine)
delete(anText)
    

% add subject trajectories

% delete(shapeSoft)
delete(groundTruthDots)
delete(pExaRound)
delete(pExaIndivTraj)

for s = 1:groupSize
    
    xCurrent = xIndivTrajec(:,s);
    yCurrent = yIndivTrajec(:,s);

    xToPlotSubj = [xCurrent; xCurrent(1)]; % repeat x to avoid holes in the plot
    yToPlotSubj = [yCurrent; yCurrent(1)]; % same with y as above
    toPlotSubj = [xToPlotSubj yToPlotSubj];
%     plot(xToPlotSubj,yToPlotSubj,'color',[colors(colInds(s),:) 0.2],'linewidth',1)    
    plot(xToPlotSubj,yToPlotSubj,'color',[colors(1,:) 0.2],'linewidth',1) % blue  
        
%     plot(xIndivTrajec(:,s),yIndivTrajec(:,s),'sq',...
%         'color',colors(colInds(s),:),'markerfacecolor',colors(colInds(s),:),'markerSize',0.25*markerSizes)       
    scatSubj = scatter(xIndivTrajec(:,s),yIndivTrajec(:,s),2*marker_size,...      
        'markerfacecolor',colors(1,:),'markeredgecolor',colors(1,:)); % all blue
%         'markerfacecolor',colors(colInds(s),:),'markeredgecolor',colors(colInds(s),:));       
          
    scatSubj.MarkerFaceAlpha = 0.75;
    scatSubj.MarkerEdgeAlpha = 0.75;    
end

if saveFigs
    currentFig = currentFig + 1;
    toName =[toAllFigNames '_' sprintf('%02u',currentFig)] ;

    set(gcf,'units','centimeters')
    pos=get(gcf,'Position');
    set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
    print('-djpeg','-r600',[toName '.jpeg'])
    savefig(toName)
end
if pauseFigs
    pause
end




% plot WOC and Truth

plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',colors(end,:),...
    'markerfacecolor',colors(end,:),'markerSize',0.25*marker_size,'linewidth',0.5*line_width)

plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'color',[colors(colWoc,:) 0.75],'linewidth',1)
plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'o','color',colors(2,:),...
    'markerfacecolor',colors(colWoc,:),'markerSize',0.25*marker_size,'linewidth',0.5*line_width)

if saveFigs
    currentFig = currentFig + 1;
    toName =[toAllFigNames '_' sprintf('%02u',currentFig)] ;

    set(gcf,'units','centimeters')
    pos=get(gcf,'Position');
    set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
    print('-djpeg','-r600',[toName '.jpeg'])
    savefig(toName)
end
if pauseFigs
    pause
end





