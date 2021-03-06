% Old figure S1. Now we are going to show how, for every separate
% template, the performance of younger/older changes when we scan the value
% of the age threshold within a wide range

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
margin_right = 1 * scale_factor;
margin_bottom = 2 * scale_factor;
margin_top = 1.25  * scale_factor;

space_horiz = 2 * scale_factor;
space_vert = 2 * scale_factor;

axes_width = (fig_width - margin_left - margin_right - space_vert)/2;
axes_height = 0.75 * axes_width;

fig_height = margin_bottom + 3 * axes_height + 2 * space_vert + margin_top ;

letter_size = 17 * scale_factor;
letter_horiz = 0.3 * margin_left;
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

load motorwoc_classerror

posh = [0 0 1 0 1];
posv = [2 1 1 0 0];

nThres = length(ageThresValues);

for t = 1:nTasks
    
    posAxes = [margin_left + posh(t)*(axes_width + space_horiz) margin_bottom + posv(t)*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    colors = get(gca,'colororder');
    hold on
    
    colorIndivsChild = colors(1,:);
    colorIndivsTeen = colors(5,:);
    colorGroupsChild = colors(2,:);
    colorGroupsTeen = colors(4,:);
    
    
    distToTruthChildIndivs = nan(1,nThres);
    distToTruthTeenIndivs = nan(1,nThres);
    distToTruthChildGroups = nan(1,nThres);
    distToTruthTeenGroups = nan(1,nThres);
    for a = 1:nThres
        distToTruthChildIndivs(a) = distToTruthClassIndivs{t}{a}(1);
        distToTruthTeenIndivs(a) = distToTruthClassIndivs{t}{a}(2);
        distToTruthChildGroups(a) = distToTruthClassGroups{t}{a}(1);
        distToTruthTeenGroups(a) = distToTruthClassGroups{t}{a}(2);
    end
    
    confIntChildIndivs = nan(2,nThres);
    confIntTeenIndivs = nan(2,nThres);
    confIntChildGroups = nan(2,nThres);
    confIntTeenGroups = nan(2,nThres);
    for a = 1:nThres
        confIntChildIndivs(:,a) = confIntTruthClassIndivs{t}{a}(:,1);
        confIntTeenIndivs(:,a) = confIntTruthClassIndivs{t}{a}(:,2);
        confIntChildGroups(:,a) = confIntTruthClassGroups{t}{a}(:,1);
        confIntTeenGroups(:,a) = confIntTruthClassGroups{t}{a}(:,2);
    end

    extThresValues = [ageThresValues(2:end-1), fliplr(ageThresValues(2:end-1))];
    
    confIntAreaIndivsChild = [confIntChildIndivs(1,2:end-1)...
                        fliplr(confIntChildIndivs(2,2:end-1))];
    ci1 = fill(extThresValues, confIntAreaIndivsChild, colorIndivsChild,'edgecolor','none');
    set(ci1, 'facealpha', 0.3)
    p1 = plot(ageThresValues(2:end-1),distToTruthChildIndivs(2:end-1),'color',colorIndivsChild,'linewidth',line_width);
    
    confIntAreaIndivsTeen = [confIntTeenIndivs(1,2:end-1)...
                        fliplr(confIntTeenIndivs(2,2:end-1))];
    ci2 = fill(extThresValues, confIntAreaIndivsTeen, colorIndivsTeen,'edgecolor','none');
    set(ci2, 'facealpha', 0.3)
    p2 = plot(ageThresValues(2:end-1),distToTruthTeenIndivs(2:end-1),'color',colorIndivsTeen,'linewidth',line_width);
    
    confIntAreaGroupsChild = [confIntChildGroups(1,2:end-1)...
                        fliplr(confIntChildGroups(2,2:end-1))];
    ci3 = fill(extThresValues, confIntAreaGroupsChild, colorGroupsChild,'edgecolor','none');
    set(ci3, 'facealpha', 0.3)
    p3 = plot(ageThresValues(2:end-1),distToTruthChildGroups(2:end-1),'color',colorGroupsChild,'linewidth',line_width);
    
    confIntAreaGroupsTeen = [confIntTeenGroups(1,2:end-1)...
                        fliplr(confIntTeenGroups(2,2:end-1))];
    ci4 = fill(extThresValues, confIntAreaGroupsTeen, colorGroupsTeen,'edgecolor','none');
    set(ci4, 'facealpha', 0.3)
    p4 = plot(ageThresValues(2:end-1),distToTruthTeenGroups(2:end-1),'color',colorGroupsTeen,'linewidth',line_width);
    
    xlim([10 17.5])
    ylim([0 4])
    
    if t == nTasks
        [leg, legObj] = legend([p1 p2 p3 p4],'younger indivs','older indivs',...
                                   'younger WOC','older WOC',...
                                   'location','eastoutside',...
                                   'autoupdate','off','fontsize',legend_size);
%         leg.NumColumns = 2;
        legPos = get(leg,'position');
        leg.Position = [0.65 0.76 legPos(3:4)];
        legLin = findobj(legObj,'type','line');
        set(legLin,'linewidth',legend_line_width)  
        legend('boxoff')
    end

    
    set(gca,'xtick',10:17)
    xlabel('age threshold','fontsize',label_size)
    ylabel('average error (mm)','fontsize',label_size)

end



%%

set(gcf,'units','centimeters')
posFig=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',posFig(3:4),'PaperPosition',[0 0 posFig(3:4)])
print('-djpeg','-r600','motorwoc_FigS02.jpeg')
savefig('motorwoc_FigS02')







