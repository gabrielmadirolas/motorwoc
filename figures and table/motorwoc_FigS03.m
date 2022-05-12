% Old figure S2, which was plotted with the motorwoc_wocvsbest02.m script

close all
clearvars

load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);


%%

scale_factor = 1;

fig_pos = [10 5] * scale_factor;

fig_width = 18 * scale_factor;

margin_left = 2 * scale_factor;
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

% colorline_width = 3 * scale_factor;
% background_color = 0.75*ones(1,3);

line_width = 2 * scale_factor;
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
    'String','A','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 2*axes_height + 1*space_vert 0 0],...
    'String','B','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[margin_left + axes_width + letter_horiz  margin_bottom + 2*axes_height + 1*space_vert 0 0],...
    'String','C','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 1*axes_height + 0*space_vert 0 0],...
    'String','D','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[margin_left + axes_width + letter_horiz  margin_bottom + 1*axes_height + 0*space_vert 0 0],...
    'String','E','FontSize',letter_size,...
    'FontWeight',letter_weight,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)



%%


load motorwoc_indiverror
load motorwoc_crowderror

posh = [0 0 1 0 1];
posv = [2 1 1 0 0];

nSubj = nan(1,nTasks);
nTraj = nan(1,nTasks);
perfBest = cell(1,nTasks);

for t = 1:nTasks
    
    posAxes = [margin_left + posh(t)*(axes_width + space_horiz) margin_bottom + posv(t)*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    colors = get(gca,'colororder');
    hold on
    
    woc = distToTruthGroups{t};
    indivTraj = distToTruthEachTraject{t}{1}(:);
    nTraj(t) = length(indivTraj);
    eachSubj = mean(distToTruthEachTraject{t}{1},2,'omitnan');
    nSubj(t) = length(eachSubj);
    
    perfBest{t} = nan(nTraj(t),1);
    sortTraj = sort(indivTraj);
    for n = 1:nTraj(t)
        perfBest{t}(n) = mean(sortTraj(1:n),'omitnan');
    end
    nData = nTraj(t);
    
    
    p1 = plot(1:nData,perfBest{t},'linewidth',line_width);
    p2 = plot([1 nData],[woc woc],':k','color',colors(2,:),'linewidth',line_width);
    
    xLims = [1 nData];
    yLims = [0 3];
    xlim(xLims)
    ylim(yLims)
    
%     text(nData+0.015*range(xLims),woc,'collective','color',colors(2,:),'fontsize',16,...
%         'verticalalignment','bottom','horizontalalignment','left','rotation',0)
%     text(nData+0.015*range(xLims),woc,'error','color',colors(2,:),'fontsize',16,...
%         'verticalalignment','top','horizontalalignment','left','rotation',0)
%     text(nData+0.015*range(xLims),woc,'WOC','color',colors(2,:),'fontsize',16,...
%         'verticalalignment','middle','horizontalalignment','left','rotation',0)
    
    
    set(gca,'fontsize',label_size,'xscale','log','xdir','reverse','XMinorTick','off',...
        'xtick',nData./[nData 1000 100 10 1],'xticklabel',{'best','99.9','99','90','all'})
    xlabel('expertise percentile','fontsize',label_size)
    ylabel('average error (mm)','fontsize',label_size)
    
    if t == nTasks
        [leg, legObj] = legend([p1 p2],'individual trajectories','WOC all subjects',...
                                   'location','eastoutside',...
                                   'autoupdate','off','fontsize',legend_size);
%         leg.NumColumns = 2;
        legPos = get(leg,'position');
        leg.Position = [0.60 0.80 legPos(3:4)];
        legLin = findobj(legObj,'type','line');
        set(legLin,'linewidth',legend_line_width)  
        legend('boxoff')
    end


end



%%

set(gcf,'units','centimeters')
posFig=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',posFig(3:4),'PaperPosition',[0 0 posFig(3:4)])
print('-djpeg','-r600','motorwoc_FigS03.jpeg')
savefig('motorwoc_FigS03')







