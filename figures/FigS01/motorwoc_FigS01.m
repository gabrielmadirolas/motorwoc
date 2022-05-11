
close all
clearvars

load motorwoc_methods01_data

% parameters for the figures

saveFigs = true; % wanna save the figures? 
pauseFigs = false; % pause after each figure is created

toAllFigNames = 'motorwoc_FigS01';

lineWidths = 5;
markerSizes = 30;

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
colInds = [1 3 4 5 6];
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


% show selected subject total trajectory

figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigNew);
set(gca,'Position',posAxNew,'XColor','none','YColor','none')

xlim(xLims)
ylim(yLims)

xCurrent = gd.pix2mm * subjects(iExaSubj).x';
yCurrent = gd.pix2mm * subjects(iExaSubj).y';
pExaHard = plot(xCurrent,yCurrent,'color',[colors(colInds(iExaSubj),:) 1],'linewidth',1);

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

delete(pExaHard)

% show selected subject total trajectory + selected segment

pExaSoft = plot(xCurrent,yCurrent,'color',[colors(colInds(iExaSubj),:) 0.3],'linewidth',1);
pExaIndivTraj = plot(xExaTrajec,yExaTrajec,'color',[colors(colInds(iExaSubj),:) 1],'linewidth',3);

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

% delete(pExaSoft)
% delete(pExaIndivTraj)



% show subject individual trajectories

figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigNew);
set(gca,'Position',posAxNew,'XColor','none','YColor','none')

xlim(xLims)
ylim(yLims)

handVerts = nan(1,nBins);
for n = 1:nBins
    handVerts(n) = plot(newVerts(n,1:2:3),newVerts(n,2:2:4),'--k');
end

% shapeSoft = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 0.25],'linewidth',2);
% groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),...
%     '.','color',0.75*ones(1,3),'markerfacecolor',0.75*ones(1,3),'markerSize',0.5 * markerSizes);

handSubjPlots = nan(groupSize,1);
for s = 1:groupSize
    
    xCurrent = xIndivTrajec(:,s);
    yCurrent = yIndivTrajec(:,s);

    xToPlotSubj = [xCurrent; xCurrent(1)]; % repeat x to avoid holes in the plot
    yToPlotSubj = [yCurrent; yCurrent(1)]; % same with y as above
    toPlotSubj = [xToPlotSubj yToPlotSubj];
    handSubjPlots(s) = plot(xToPlotSubj,yToPlotSubj,'color',[colors(colInds(s),:) 0.5],'linewidth',1);
    plot(xToPlotSubj,yToPlotSubj,'.',...
    'color',colors(colInds(s),:),'markerSize',0.35*markerSizes);
                
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



% big shape

figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigNew);
set(gca,'Position',posAxNew,'XColor','none','YColor','none')

xlim(xLims)
ylim(yLims)

plot(xGroundTruth,yGroundTruth,'color',colors(end,:),'linewidth',lineWidths)
% rectangle('position',[xLimsZoom(1) yLimsZoom(2) range(xLimsZoom) range(yLimsZoom)])

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



% big shape with bins

for n = 1:nBins
    plot(newVerts(n,1:2:3),newVerts(n,2:2:4),'--k')
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



% big shape with points

figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigNew);
set(gca,'Position',posAxNew,'XColor','none','YColor','none')

xlim(xLims)
ylim(yLims)

handVerts = nan(1,nBins);
for n = 1:nBins
    handVerts(n) = plot(newVerts(n,1:2:3),newVerts(n,2:2:4),'--k');
end

groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),...
    '.','color',colors(end,:),'markerfacecolor',colors(end,:),'markerSize',0.5 * markerSizes);
% rectangle('position',[xLimsZoom(1) yLimsZoom(2) range(xLimsZoom) range(yLimsZoom)])

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



% big shape with subsampled individual trajectory

delete(handVerts)

% xCurrent = xIndivTrajec(:,iExaSubj);
% yCurrent = yIndivTrajec(:,iExaSubj);
% 
% xToPlotSubj = [xCurrent; xCurrent(1)]; % repeat x to avoid holes in the plot
% yToPlotSubj = [yCurrent; yCurrent(1)]; % same with y as above
% toPlotSubj = [xToPlotSubj yToPlotSubj];
% plot(xToPlotSubj,yToPlotSubj,'color',[colors(colInds(s),:) 0.75],'linewidth',0.25*lineWidths)

delete(groundTruthDots)

shapeSoft = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 0.25],'linewidth',1);
groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),...
    '.','color',0.75*ones(1,3),'markerfacecolor',0.75*ones(1,3),'markerSize',0.5 * markerSizes);
pExaIndivTraj = plot(xExaTrajec,yExaTrajec,'color',[colors(colInds(iExaSubj),:) 0.5],'linewidth',2);
pExaRound = plot(xIndivTrajec(:,iExaSubj),yIndivTrajec(:,iExaSubj),'.',...
    'color',colors(colInds(iExaSubj),:),'markerSize',0.5*markerSizes);



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



% zoom to ROI

fZoom = figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigZoom);
set(gca,'Position',posAxZoom, 'XColor','none','YColor','none')

xlim(xLimsZoom)
ylim(yLimsZoom)


shapeStrong = plot(xGroundTruth,yGroundTruth,'color',colors(end,:),'linewidth',lineWidths);

for n = 1:nBins
    plot(newVerts(n,1:2:3),newVerts(n,2:2:4),'--k')
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



% sub-sample

delete(shapeStrong)

shapeSoft = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 0.5],'linewidth',0.25*lineWidths);
groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',colors(end,:),...
    'markerfacecolor',colors(end,:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths);


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



% add selected subject trajectory

% delete(shapeSoft)
delete(groundTruthDots)
% alphaTruth = 0.25;

% shapeSoft = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) alphaTruth],'linewidth',0.25*lineWidths);
% groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',(1-alphaTruth)*[1 1 1],...
%     'markerfacecolor',(1-alphaTruth)*[1 1 1],'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths);

% This was a fight against subborn Matlab. He won.
% pause(0.1);
% truthMarkers = groundTruthDots.MarkerHandle;
% pause(0.1);
% truthMarkers.FaceColorData = uint8(repmat(255*[colors(end,:) 0.5]',1,1));
% pause(0.1);
% truthMarkers.EdgeColorData = uint8(repmat(255*[colors(end,:) 0.5]',1,1));

pExaSoft = plot(xExaTrajec,yExaTrajec,'color',[colors(colInds(iExaSubj),:) 0.5],'linewidth',1); 
pExaPoints = plot(xExaTrajec,yExaTrajec,'x','color',colors(colInds(iExaSubj),:),...
    'markerfacecolor',colors(colInds(iExaSubj),:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths);


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



% add subsampled subject trajectory

% pExaRound = plot(xIndivTrajec(:,iExaSubj),yIndivTrajec(:,iExaSubj), 'sq',...
%     'color',colors(colInds(iExaSubj),:),'markerSize',0.4*markerSizes,'linewidth',0.5*lineWidths);
pExaRound = plot(xIndivTrajec(:,iExaSubj),yIndivTrajec(:,iExaSubj),'o',...
    'color',colors(colInds(iExaSubj),:),'markerSize',0.35*markerSizes,'linewidth',0.5*lineWidths);


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

delete(pExaSoft)
delete(pExaRound)
delete(pExaPoints)

groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',colors(end,:),...
    'markerfacecolor',colors(end,:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths);
pExaIndivTraj = plot(xIndivTrajec(:,iExaSubj),yIndivTrajec(:,iExaSubj),...
    'color',[colors(colInds(iExaSubj),:) 0.5],'linewidth',1);
pExaRound = plot(xIndivTrajec(:,iExaSubj),yIndivTrajec(:,iExaSubj),'o','color',colors(colInds(iExaSubj),:),...
    'markerfacecolor',colors(colInds(iExaSubj),:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths);


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
    plot(xToPlotSubj,yToPlotSubj,'color',[colors(colInds(s),:) 0.5],'linewidth',1)      
   
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



% plot round subject trajectories

for s = 1:groupSize
        
%     plot(xIndivTrajec(:,s),yIndivTrajec(:,s),'sq',...
%         'color',colors(colInds(s),:),'markerfacecolor',colors(colInds(s),:),'markerSize',0.25*markerSizes)       
    plot(xIndivTrajec(:,s),yIndivTrajec(:,s),'o',...
        'color',colors(colInds(s),:),'markerfacecolor',colors(colInds(s),:),'markerSize',0.25*markerSizes)       
        
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



% show WOC

plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'o',...
    'color',colors(colWoc,:),'markerSize',0.35*markerSizes,'linewidth',0.5*lineWidths);


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



% new figure to plot WOC and Truth


fZoom2 = figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigZoom);
set(gca,'Position',posAxZoom, 'XColor','none','YColor','none')

xlim(xLimsZoom)
ylim(yLimsZoom)

plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 0.5],'linewidth',0.25*lineWidths);
plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'color',[colors(colWoc,:) 0.5],'linewidth',1)
plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'o','color',colors(2,:),...
    'markerfacecolor',colors(colWoc,:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths)

for n = 1:nBins
    plot(newVerts(n,1:2:3),newVerts(n,2:2:4),'--k')
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



plot(roundGroundTruth(:,1),roundGroundTruth(:,2),'o','color',colors(end,:),...
    'markerfacecolor',colors(end,:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths)

plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'color',[colors(colWoc,:) 0.5],'linewidth',1)
plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'o','color',colors(2,:),...
    'markerfacecolor',colors(colWoc,:),'markerSize',0.25*markerSizes,'linewidth',0.5*lineWidths)

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



% final big plot with truth and woc


figure;
hold on

set(gcf,'units','centimeters')
% set(gca,'units','centimeters')

set(gcf,'Position',posFigNew);
set(gca,'Position',posAxNew,'XColor','none','YColor','none')

xlim(xLims)
ylim(yLims)


shapeSoft = plot(xGroundTruth,yGroundTruth,'color',[colors(end,:) 0.25],'linewidth',1);
groundTruthDots = plot(roundGroundTruth(:,1),roundGroundTruth(:,2),...
    '.','color',0.75*ones(1,3),'markerfacecolor',0.75*ones(1,3),'markerSize',0.5 * markerSizes);
plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'color',[colors(colWoc,:) 0.5],'linewidth',1)
plot(roundTrajecGroup(:,1),roundTrajecGroup(:,2),'.','color',colors(colWoc,:),'markerSize',0.5*markerSizes);


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




