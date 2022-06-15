% Old figure S3, which was plotted with the 
% motorwoc_Fig02B_medianvsmean.m script

close all
clearvars

load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);


%%

scale_factor = 1;

fig_pos = [10 5] * scale_factor;

fig_width = 18 * scale_factor;

margin_left = 2.5 * scale_factor;
margin_right = 1.5 * scale_factor;
margin_bottom = 2 * scale_factor;
margin_top = 1.25  * scale_factor;

space_horiz = 2.5 * scale_factor;
space_vert = 2 * scale_factor;

axes_width = (fig_width - margin_left - margin_right - space_vert)/2;
axes_height = 0.75 * axes_width;

fig_height = margin_bottom + 3 * axes_height + 2 * space_vert + margin_top ;

letter_size = 17 * scale_factor;
letter_horiz = 0.15 * margin_left;
letter_vert = 1 * axes_height; 
letter_weight = 'normal';
letter_angle = 'italic';

% colorline_width = 3 * scale_factor;
% background_color = 0.75*ones(1,3);

line_width = 1 * scale_factor;
marker_size = 2 * scale_factor;
label_size = 12 * scale_factor;
tick_size = 10 * scale_factor; 
legend_size = 13 * scale_factor;
legend_line_width = 3 * scale_factor;


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
    'String','(a)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 2*axes_height + 1*space_vert 0 0],...
    'String','(b)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz + axes_width + space_horiz  margin_bottom + 2*axes_height + 1*space_vert 0 0],...
    'String','(c)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 1*axes_height + 0*space_vert 0 0],...
    'String','(d)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz + axes_width + space_horiz  margin_bottom + 1*axes_height + 0*space_vert 0 0],...
    'String','(e)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)



%%

load motorwoc_indiverror_mean
load motorwoc_grouperror_mean

distToTruthIndivsMean = distToTruthIndivs;
confIntTruthIndivsMean = confIntTruthIndivs;
distToTruthGroupsMean = distToTruthGroups;
confIntTruthGroupsMean = confIntTruthGroups;

load motorwoc_indiverror
load motorwoc_grouperror

posh = [0 0 1 0 1];
posv = [2 1 1 0 0];

for t = 1:nTasks

    nSegments = length(distToTruthIndivs{t});
    indivSizes = 1:nSegments;

    posAxes = [margin_left + posh(t)*(axes_width + space_horiz) margin_bottom + posv(t)*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    colors = get(gca,'colororder');
    hold on
    
    extIndivSizes = [indivSizes, fliplr(indivSizes)];
    confIntAreaIndivs = [confIntTruthIndivs{t}(1,:) fliplr(confIntTruthIndivs{t}(2,:))];
    ci1 = fill(extIndivSizes, confIntAreaIndivs, colors(1,:),'edgecolor','none');
    set(ci1, 'facealpha', 0.3)
%     plot(indivSizes,confIntTruthIndivs(1,:),'b','linewidth',2)
%     plot(indivSizes,confIntTruthIndivs(2,:),'b','linewidth',2)

    extGroupSizes = [groupSizes(1:end-1), fliplr(groupSizes(1:end-1))];
    confIntAreaGroups = [confIntTruthGroups{t}(1,1:end-1) fliplr(confIntTruthGroups{t}(2,1:end-1))];
    ci2 = fill(extGroupSizes, confIntAreaGroups, colors(2,:),'edgecolor','none');
    set(ci2, 'facealpha', 0.3)
%     plot(groupSizes(1:end-1),confIntTruthGroups(1,1:end-1),'r','linewidth',2)
%     plot(groupSizes(1:end-1),confIntTruthGroups(2,1:end-1),'r','linewidth',2)

    p1 = plot(indivSizes,distToTruthIndivs{t},'color',colors(1,:),'linewidth',line_width);
    p2 = plot(groupSizes(1:end-1),distToTruthGroups{t}(1:end-1),'color',colors(2,:),'linewidth',line_width);
    
%     plot(groupSizes(end-1)+10,confIntTruthGroups(1,end),'or','markersize',5)
%     plot(groupSizes(end-1)+10,confIntTruthGroups(2,end),'or','markersize',5)
    ciInf = confIntTruthGroups{t}(1,end);
    ciSup = confIntTruthGroups{t}(2,end);
    er = errorbar(groupSizes(end-1)+20,(ciInf+ciSup)/2,(ciSup-ciInf)/2,'linewidth',line_width);
    er.Color = colors(2,:);
    
    plot(groupSizes(end-1)+20,distToTruthGroups{t}(end),'o',...
                  'color',colors(2,:),'markerfacecolor',colors(2,:),'markersize',marker_size)
              
              
    colorIndiv = colors(5,:);         
    colorGroup = colors(4,:);         
              
    extIndivSizes = [indivSizes, fliplr(indivSizes)];
    confIntAreaIndivsMean = [confIntTruthIndivsMean{t}(1,:) fliplr(confIntTruthIndivsMean{t}(2,:))];
    ci1 = fill(extIndivSizes, confIntAreaIndivsMean, colorIndiv,'edgecolor','none');
    set(ci1, 'facealpha', 0.3)
%     plot(indivSizes,confIntTruthIndivs(1,:),'b','linewidth',2)
%     plot(indivSizes,confIntTruthIndivs(2,:),'b','linewidth',2)

    extGroupSizes = [groupSizes(1:end-1), fliplr(groupSizes(1:end-1))];
    confIntAreaGroupsMean = [confIntTruthGroupsMean{t}(1,1:end-1) fliplr(confIntTruthGroupsMean{t}(2,1:end-1))];
    ci2 = fill(extGroupSizes, confIntAreaGroupsMean, colorGroup,'edgecolor','none');
    set(ci2, 'facealpha', 0.3)
%     plot(groupSizes(1:end-1),confIntTruthGroups(1,1:end-1),'r','linewidth',2)
%     plot(groupSizes(1:end-1),confIntTruthGroups(2,1:end-1),'r','linewidth',2)

    p3 = plot(indivSizes,distToTruthIndivsMean{t},'color',colorIndiv,'linewidth',line_width);
    p4 = plot(groupSizes(1:end-1),distToTruthGroupsMean{t}(1:end-1),'color',colorGroup,'linewidth',line_width);
    
%     plot(groupSizes(end-1)+10,confIntTruthGroups(1,end),'or','markersize',5)
%     plot(groupSizes(end-1)+10,confIntTruthGroups(2,end),'or','markersize',5)
    ciInf = confIntTruthGroupsMean{t}(1,end);
    ciSup = confIntTruthGroupsMean{t}(2,end);
    er = errorbar(groupSizes(end-1)+20,(ciInf+ciSup)/2,(ciSup-ciInf)/2,'linewidth',line_width);
    er.Color = colorGroup;
    
    plot(groupSizes(end-1)+20,distToTruthGroupsMean{t}(end),'o',...
                  'color',colorGroup,'markerfacecolor',colorGroup,'markersize',marker_size)          

              
    xlim([0 groupSizes(end-1)+22])
    ylim([0 3.1]) % added by hand to normalize all tasks
    
           
%     legend('individual','crowd','location','northeast','fontsize',11)
    toTicks = [0:10:groupSizes(end-1)  groupSizes(end-1)+20];
    toTickLabels = {'0','10','20','30','40','50','all subjects'};
    tickLabels = sprintf(toTickLabels{:});
    set(gca,'xtick',toTicks,'xticklabels',toTickLabels,'fontsize',label_size)
    xlabel('number of trajectories','fontsize',label_size)
    ylabel('error of the aggregate (mm)','fontsize',label_size)
    
    if t == nTasks
        [leg, legObj] = legend([p1 p3 p2 p4],'single, median','single, mean',...
                                   'WOC, median','WOC, mean',...
                                   'autoupdate','off','fontsize',legend_size);
%         leg.NumColumns = 2;
        legPos = get(leg,'position');
        leg.Position = [0.65 0.77 legPos(3:4)];
        legLin = findobj(legObj,'type','line');
        set(legLin,'linewidth',legend_line_width)  
        legend('boxoff')
    end


end



%%

set(gcf,'units','centimeters')
posFig=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',posFig(3:4),'PaperPosition',[0 0 posFig(3:4)])
print('-djpeg','-r600','motorwoc_FigS04.jpeg')
savefig('motorwoc_FigS04')







