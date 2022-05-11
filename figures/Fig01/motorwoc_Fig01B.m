


clearvars
close all


load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;

% to adjust the size of the axes to the shape of the tablet screen
propAxes = gd.mmYScreen/gd.mmXScreen;

xLims = gd.pix2mm * [0 gd.pixelsXScreen];
yLims = gd.pix2mm * [0 gd.pixelsYScreen];


td = motorwoc_cleaned_data.tracing_lemniscate;
subjects = td.subjectDataCleaned;


iSubjects = [11 3 2];
groupSize = length(iSubjects);

x = cell(1,groupSize);
y = cell(1,groupSize);



for i = 1:groupSize
    s = iSubjects(i);
    x{i} = gd.pix2mm * subjects(s).x'; % x coordinates of the trajectory drawn by the subject
    y{i} = gd.pix2mm * subjects(s).y'; % y coordinates of the trajectory drawn by the subject
end


% paplot = gd.pix2mm * [groundTruth(end,:); groundTruth; groundTruth(1,:)];

for s = 1:groupSize
    
    figure
    plot(gd.pix2mm * td.groundTruth(:,1),gd.pix2mm * td.groundTruth(:,2),'k','linewidth',3)
    hold on
    plot(x{s},y{s})

    xlim(xLims)
    ylim(yLims)

end

figure
set(gcf,'Units','centimeters')
pos = get(gcf,'position');
set(gcf,'position', [pos(1) pos(2)/4 pos(3) pos(3)])
set(gca,'color',[1 1 1]) % set(gca,'color',[.8 .8 .8])
pos = get(gca,'position');
newAxPos = [pos(1), 0.5-propAxes*pos(3)/2, pos(3), propAxes*pos(3)];
set(gca,'position',newAxPos)

colorsOriginal = get(gca,'colororder');
colors = colorsOriginal([1 2 5],:);

hold on

pl = nan(groupSize,1);
pl(groupSize+1) = plot(gd.pix2mm * td.groundTruth(:,1),gd.pix2mm * td.groundTruth(:,2),':k','linewidth',3);

nSegments = 8;
for i = 1:nSegments/2
    for s = 1:groupSize
        xSubj = x{s};
        ySubj = y{s};
        lenX = length(xSubj);
        lenY = length(ySubj);
        lenSegmX = floor(lenX/nSegments);
        lenSegmY = floor(lenY/nSegments);
        xSegm = xSubj((i-1)*lenSegmX+(1:lenSegmX+1));
        ySegm = ySubj((i-1)*lenSegmY+(1:lenSegmY+1));
        pl(s) = plot(xSegm,ySegm,'color',[colors(s,:) 0.6],'linewidth',1);
    end
end

% paplot = gd.pix2mm * [groundTruth(end,:); groundTruth; groundTruth(1,:)];

toLegend = {'subject 1','subject 2','subject 3','template'};
leg = legend(pl,toLegend, 'fontsize',11,'location','southoutside',...
                'box','off','autoupdate','off');
leg.NumColumns = groupSize+1;
plot([10 20],[5 5],'k','linewidth',3)
text(15,6.5,'1 cm','fontsize',14,...
    'horizontalalignment','center','verticalalignment','bottom')
% title('all subjects as one','fontsize',12)
% line([xLims(1) xLims(2)],[yLims(2) yLims(2)],'color','k')
% line([xLims(2) xLims(2)],[yLims(1) yLims(2)],'color','k')
set(gca,'xtick',[],'ytick',[])
xlim(xLims)
ylim(yLims)
set(gca,'box','off')
set(gca,'XColor','none','YColor','none')

set(gca,'position',newAxPos)

toName = 'motorwoc_Fig01B';

set(gcf,'units','centimeters')
pos=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
print('-djpeg','-r300',[toName '.jpeg'])
savefig(toName)







