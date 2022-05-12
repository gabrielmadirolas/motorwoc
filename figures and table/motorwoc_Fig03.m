% This is going to be made of lines E to G of the old Fig02, which we are
% splitting in two because it was too mammoth

close all
clearvars

load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);


%%

scale_factor = 1;

fig_pos = [10 5] * scale_factor;

fig_width = 24 * scale_factor;

margin_left = 2 * scale_factor;
margin_right = 0.75 * scale_factor;
margin_bottom = 1.5 * scale_factor;
margin_top = 0.75  * scale_factor;

space_horiz = 0.6 * scale_factor;
space_vert = 1.5 * scale_factor;

axes_width = (fig_width - margin_left - space_horiz*(nTasks-1) - margin_right) / nTasks;
axes_height = 1.15 * axes_width;

fig_height = margin_bottom + 3 * axes_height + 2 * space_vert + margin_top ;

letter_size = 17 * scale_factor;
letter_horiz = 0.3 * margin_left;
letter_vert = 1 * axes_height; 
letter_weight = 'normal';

% colorline_width = 3 * scale_factor;
% background_color = 0.75*ones(1,3);

line_width = 1 * scale_factor;
marker_size = 2 * scale_factor;
label_size = 12 * scale_factor;
tick_size = 10 * scale_factor; 
legend_size = 12 * scale_factor;


% cbar_width = (0.05 * axes_width) / fig_width;
% cbar_height = (1 * axes_height) / fig_width;
cbar_horiz = (fig_width - 0.85*margin_right) / fig_width;
cbar_fontsize = 10;

%%

f = figure;
set(gcf,'Units','centimeters','Position',[fig_pos fig_width fig_height])
set(gcf, 'InvertHardcopy', 'off')
set(gcf,'Units','centimeters')
set(gcf,'color',[1 1 1])


annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 3*axes_height + 2*space_vert 0 0],...
    'String','A','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 2*axes_height + 1*space_vert 0 0],...
    'String','B','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 1*axes_height + 0*space_vert 0 0],...
    'String','C','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)



%% Fig 3A

load motorwoc_indiverror
load motorwoc_grouperror

for t = 1:nTasks

    nSegments = length(distToTruthIndivs{t});
    indivSizes = 1:nSegments;
    
    posAxes = [margin_left + (t-1)*(axes_width + space_horiz) margin_bottom + 2*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    colors = get(gca,'colororder');
    hold on
    
    extIndivSizes = [indivSizes, fliplr(indivSizes)];
    confIntAreaIndivs = [confIntTruthIndivs{t}(1,:) fliplr(confIntTruthIndivs{t}(2,:))];
    ci1 = fill(extIndivSizes, confIntAreaIndivs, 'k','edgecolor','none');
    set(ci1, 'facealpha', 0.3)
%     plot(indivSizes,confIntTruthIndivs(1,:),'b','linewidth',2)
%     plot(indivSizes,confIntTruthIndivs(2,:),'b','linewidth',2)

    extGroupSizes = [groupSizes(1:end-1), fliplr(groupSizes(1:end-1))];
    confIntAreaGroups = [confIntTruthGroups{t}(1,1:end-1) fliplr(confIntTruthGroups{t}(2,1:end-1))];
    ci2 = fill(extGroupSizes, confIntAreaGroups, colors(2,:),'edgecolor','none');
    set(ci2, 'facealpha', 0.3)
%     plot(groupSizes(1:end-1),confIntTruthGroups(1,1:end-1),'r','linewidth',2)
%     plot(groupSizes(1:end-1),confIntTruthGroups(2,1:end-1),'r','linewidth',2)

    plot(indivSizes,distToTruthIndivs{t},'k','linewidth',line_width)
    plot(groupSizes(1:end-1),distToTruthGroups{t}(1:end-1),'color',colors(2,:),'linewidth',line_width)
    
%     plot(groupSizes(end-1)+10,confIntTruthGroups(1,end),'or','markersize',5)
%     plot(groupSizes(end-1)+10,confIntTruthGroups(2,end),'or','markersize',5)
    ciInf = confIntTruthGroups{t}(1,end);
    ciSup = confIntTruthGroups{t}(2,end);
    er = errorbar(groupSizes(end-1)+13,(ciInf+ciSup)/2,(ciSup-ciInf)/2,'linewidth',line_width);
    er.Color = colors(2,:);
    
    plot(groupSizes(end-1)+13,distToTruthGroups{t}(end),'o',...
                  'color',colors(2,:),'markerfacecolor',colors(2,:),'markersize',marker_size)
    
    xlim([0 groupSizes(end-1)+15])
    xlims = get(gca,'xlim');
%     ylims = get(gca,'ylim');
%     ylim([0 ylims(2)])
    ylim([0 3.1]) % added by hand to normalize all tasks
    ylims = get(gca,'ylim');
    
    if t == nTasks
%         axPos = get(gca,'position');
%         linPos = nan(1,4);
%         linPos(1) = (axPos(1) + 1.14 * axPos(3)) / fig_width;
%         linPos(2) = (axPos(2) + 0.35 * axPos(4)) / fig_height;
%         linPos(3) = (50 / xLims(2)) * axes_width / fig_width;
%         linPos(4) = 0;
        xAnnon = 0.75;

        lin1 = annotation('line','units','centimeters','linewidth',2*line_width,'color',[0 0 0], ...
            'position',[posAxes(1) + xAnnon * axes_width  (posAxes(2) + 0.7 * axes_height)  0.25 * axes_width  0]);
        
        annotation('textbox','string','single subject','units','centimeters','fontsize',label_size,'color',[0 0 0], ...
            'position',[posAxes(1) + xAnnon * axes_width  (posAxes(2) + 0.7 * axes_height)  0.25 * axes_width  0], ...
        'LineStyle','none','horizontalalignment','center','verticalalignment','bottom')
        
        lin2 = annotation('line','units','centimeters','linewidth',2*line_width,'color',colors(2,:), ...
            'position',[posAxes(1) + xAnnon * axes_width  (posAxes(2) + 0.5 * axes_height)  0.25 * axes_width  0]);
        
        annotation('textbox','string','WOC','units','centimeters','fontsize',label_size,'color',colors(2,:), ...
            'position',[posAxes(1) + xAnnon * axes_width  (posAxes(2) + 0.5 * axes_height)  0.25 * axes_width  0], ...
        'LineStyle','none','horizontalalignment','center','verticalalignment','bottom')
        
%         annotation('textbox','Units','centimeters',...
%         'Position',[axPos(1) + 1.13 * axPos(3)  (axPos(2) + 0.35 * axPos(4))  2*(50 / xLims(2)) * axes_width  0],...
%         'String','5 cm','FontSize',legend_size,'LineStyle','none',...
%         'horizontalalignment','left','verticalalignment','bottom','margin',0)
    end
    
%     dimIndiv = [posAxes(1) + axes_width*indivSizes(end)/range(xlims) ...
%               posAxes(2) + axes_height*distToTruthIndivs{t}(end)/range(ylims) 0 0];
%     annotation('textbox','units','centimeters','position',dimIndiv,'string','individual',...
%                'verticalalignment','bottom','horizontalalignment','left',...
%                'color',colors(1,:),'fontsize',label_size)
%     
%     dimGroup = [posAxes(1) + axes_width*groupSizes(end-1)/range(xlims) ...
%               posAxes(2) + axes_height*distToTruthGroups{t}(end-1)/range(ylims) 0 0];
%     annotation('textbox','units','centimeters','position',dimGroup,'string','WOC',...
%                'verticalalignment','bottom','horizontalalignment','left',...
%                'color',colors(2,:),'fontsize',label_size)
    
           
%     legend('individual','crowd','location','northeast','fontsize',11)
    toTickLabels = {'0','25','50','all'};
    tickLabels = sprintf(toTickLabels{:});
    if t == 3
        xlabel('number of individual trajectories aggregated','fontsize',label_size)
    end
    if t == 1
        set(gca,'xtick',[0:25:50 63],'xticklabels',toTickLabels,'fontsize',tick_size,'ticklength',[.025 .025])
        ylabel({'error of the','aggregate (mm)'},'fontsize',label_size)
    else
        set(gca,'xtick',[0:25:50 63],'xticklabels',toTickLabels,'ytick',[],'fontsize',tick_size,'ticklength',[.025 .025])
    end
    
end



%% Fig 3B

load motorwoc_crowderror

nSubj = nan(1,nTasks);
nTraj = nan(1,nTasks);
percSubj = nan(1,nTasks);
percTraj = nan(1,nTasks);

for t = 1:nTasks
    
    woc = distToTruthGroups{t};
    confIntWoc = confIntTruthGroups{t};
    indivs = distToTruthEachTraject{t}{1}(:);
    cadaSuj = mean(distToTruthEachTraject{t}{1},2,'omitnan');
    nSubj(t) = length(cadaSuj);
    nTraj(t) = length(indivs);
    percSubj(t) = 100*sum(woc<cadaSuj)/nSubj(t);
    percTraj(t) = 100*sum(woc<indivs)/nTraj(t);
    
    posAxes = [margin_left + (t-1)*(axes_width + space_horiz) margin_bottom + 1*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    colors = get(gca,'colororder');
    
    hold on
    
    indivs2 = indivs;
    indivs2(indivs > 8) = 9.94;
    h1 = histogram(indivs2,[0:0.25:9.5 10.5]);
    ylim([0 1000])
    
    toTickLabels = {'0','2','4','6','8','> 8'};
    tickLabels = sprintf(toTickLabels{:});
    
    if t == 1
        set(gca,'xtick',[0 2 4 6 8 10],'xticklabels',toTickLabels,'ytick',0:200:1000,'fontsize',tick_size,'ticklength',[.025 .025])
        yLab = ylabel({'number of','trajectories'},'fontsize',label_size);
        yLabPos = get(yLab,'Position');
        set(yLab,'Position',[0.8*yLabPos(1) yLabPos(2:3)])
    else
        set(gca,'xtick',[0 2 4 6 8 10],'xticklabels',toTickLabels,'ytick',[],'fontsize',tick_size,'ticklength',[.025 .025])
    end
    if t == 3
        xlabel('error of individual trajectories (mm)','fontsize',label_size)
    end
    
%     histogram(median(distToBinsGroup{end},2,'omitnan'),0:2.5:50)
    xLims = get(gca,'xlim');
    yLims = get(gca,'ylim');
    confIntAreaGroups = [confIntTruthGroups{t}(1,1:end-1) fliplr(confIntTruthGroups{t}(2,1:end-1))];
    ci2 = fill(confIntWoc([1 2 2 1]), [0 0 0.7*yLims(2) 0.7*yLims(2)], colors(2,:),'edgecolor','none');
    set(ci2, 'facealpha', 0.3)
%     p1 = plot([woc woc],[0 0.7*yLims(2)],':','color',colors(2,:),'linewidth',2);
    p1 = plot([woc woc],[0 0.7*yLims(2)],'color',colors(2,:),'linewidth',1);
    text(woc,yLims(1)+0.72*range(yLims),'WOC','color',colors(2,:),'fontsize',label_size,...
        'verticalalignment','middle','horizontalalignment','left','rotation',90)
%     text(woc-0.015*range(xLims),yLims(1)+0.67*range(yLims),'collective','color',colors(2,:),'fontsize',16,...
%         'verticalalignment','bottom','horizontalalignment','left','rotation',90)
%     text(woc-0.030*range(xLims),yLims(1)+0.72*range(yLims),'error','color',colors(2,:),'fontsize',16,...
%         'verticalalignment','top','horizontalalignment','left','rotation',90)
%     p1 = plot([woc woc],[0 0.9*yLims(2)],':','color',colors(2,:),'linewidth',2);
%     text(woc-0.00*range(xLims),yLims(1)+0.92*range(yLims),'crowd',...
%         'color',colors(2,:),'fontsize',15,...
%         'verticalalignment','bottom','horizontalalignment','center','rotation',0)
    % title('performance of each subject')
end



%% Fig 3C

load motorwoc_classerror

% labelBars = {{'indiv.','child'},{'indiv.','teen'},{'WOC','children'},{'WOC','teen'}};
% labelBars = {'indiv.\newline child','indiv.\newline teen','WOC\newline children','WOC\newline teen'};
labelBars = {'child',' \newline INDIVIDUAL','teen',' ','child',' \newline WOC','teen'};
 
ageThreshold = 10.5; % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, iAgeThres] = min(abs(ageThreshold-ageThresValues));

for t = 1:nTasks

    toBars = [distToTruthClassIndivs{t}{iAgeThres} distToTruthClassGroups{t}{iAgeThres}];
    
    aci = confIntTruthClassIndivs{t}{iAgeThres}(:,1);
    bci = confIntTruthClassIndivs{t}{iAgeThres}(:,2);
    cci = confIntTruthClassGroups{t}{iAgeThres}(:,1);
    dci = confIntTruthClassGroups{t}{iAgeThres}(:,2);
    
    confInts = [aci bci cci dci];
    toErrors = diff(confInts,1);

    posAxes = [margin_left + (t-1)*(axes_width + space_horiz) margin_bottom + 0*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    hold on
    
    barPlot = bar(1:length(toBars),toBars,'FaceColor','flat');
    barPlot.CData(3,:) = colors(2,:);
    barPlot.CData(4,:) = colors(2,:);
    er = errorbar(1:length(toBars),mean(confInts,1),toErrors/2);
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    er.LineWidth = scale_factor;
    
    angTicks = -0;
    if t == 1
        set(gca,'xtick',1:0.5:length(toBars),'xticklabels',labelBars,'fontsize',label_size,'ticklength',[.025 .025])
        xtickangle(angTicks)
        ylabel('average error (mm)','fontsize',label_size)
    else
        set(gca,'xtick',1:0.5:length(toBars),'xticklabels',labelBars,'ytick',[],'fontsize',label_size,'ticklength',[.025 .025])
        xtickangle(angTicks)
    end
    
    ax = ancestor(er, 'axes');
    xrule = ax.XAxis;
    % Change properties of the ruler
    xrule.FontSize = 0.85*label_size;
    
%     legend('individual','woc')
    xlim([0.5,length(toBars)+0.5])
    ylim([0 4])

end



%%

set(gcf,'units','centimeters')
posFig=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',posFig(3:4),'PaperPosition',[0 0 posFig(3:4)])
print('-djpeg','-r600','motorwoc_Fig03.jpeg')
savefig('motorwoc_Fig03')













