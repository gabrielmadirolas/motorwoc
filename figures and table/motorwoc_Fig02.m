% This is going to be made of lines A to D of the old Fig02, which we are
% splitting in two because it was too mammoth

close all
clearvars

load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);

% to adjust the size of the axes to the shape of the tablet screen
propAxes = gd.mmYScreen/gd.mmXScreen;

xLims = gd.pix2mm * [0 gd.pixelsXScreen];
yLims = gd.pix2mm * [0 gd.pixelsYScreen];

%%

scale_factor = 1;

fig_pos = [10 5] * scale_factor;

fig_width = 24 * scale_factor;

margin_left = 1.5 * scale_factor;
margin_right = 2.25 * scale_factor;
margin_bottom = 1.25 * scale_factor;
margin_top = 0.75  * scale_factor;

space_horiz = 0.5 * scale_factor;
space_vert = 1 * scale_factor;

axes_width = (fig_width - margin_left - space_horiz*(nTasks-1) - margin_right) / nTasks;
axes_height = propAxes * axes_width;

fig_height = margin_bottom + 4 * axes_height + 3 * space_vert + margin_top ;

letter_size = 17 * scale_factor;
letter_horiz = 0.4 * margin_left;
letter_vert = 1.05 * axes_height; 
letter_weight = 'normal';
letter_angle = 'italic';

colorline_width = 3 * scale_factor;
background_color = 0.75*ones(1,3);

line_width = 2 * scale_factor;
label_size = 13 * scale_factor; 
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
    'Position',[letter_horiz  margin_bottom + 3*(axes_height + space_vert) 0 letter_vert],...
    'String','(a)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','top','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 2*(axes_height + space_vert) 0 letter_vert],...
    'String','(b)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','top','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 1*(axes_height + space_vert) 0 letter_vert],...
    'String','(c)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','top','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 0*(axes_height + space_vert) 0 letter_vert],...
    'String','(d)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','top','margin',0)



%% Fig 2A

load motorwoc_disttobins

% to adjust the size of the axes to the shape of the tablet screen
propAxes = gd.mmYScreen/gd.mmXScreen;

xLims = gd.pix2mm * [0 gd.pixelsXScreen];
yLims = gd.pix2mm * [0 gd.pixelsYScreen];

propSubj = 1; % proportion of randomly selected subjects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toLegend = {'all trajectories','WOC trajectory','template'};

for t = 1:nTasks

    taskName = motorwoc_cleaned_data.general_data.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])

    totalNSubjects = length(td.iSubjOK); % total number of subjects
    nSubjects = round(propSubj*totalNSubjects); % number of randomly chosen subjects
                                                % used for the analysis
    % Each time the script is run, the set of used subjects is randomized:
    if nSubjects < totalNSubjects
        iSelSubj = randperm(totalNSubjects,nSubjects);
    else
        iSelSubj = 1:totalNSubjects;
    end
   
    subjects = procTrajects{t};
    nSegments = size(subjects,2);
    nBins = size(subjects{1,1},1);
    
    posAxes = [margin_left + (t-1)*(axes_width + space_horiz) margin_bottom + 3*(axes_height + space_vert)];
    axes('Units','centimeters','Position',[posAxes axes_width axes_height])
    
    colors = get(gca,'colororder');
    
    p1 = plot(gd.pix2mm*td.subjectDataCleaned(iSelSubj(1)).x,...
        gd.pix2mm*td.subjectDataCleaned(iSelSubj(1)).y,...
            'linewidth',line_width,'color',[colors(1,:) 0.75]);
    hold on 
    for i = iSelSubj
        plot(gd.pix2mm*td.subjectDataCleaned(i).x,...
            gd.pix2mm*td.subjectDataCleaned(i).y,'color',[colors(1,:) 0.12]);
    end
        

    % Now concatenate the individual trajectories and average them
    allTrajects = [subjects{:}];
    xAll = allTrajects(:,1:2:end-1);
    yAll = allTrajects(:,2:2:end);
    averTraject = [median(xAll,2,'omitnan') median(yAll,2,'omitnan')]; 
    
    
    p2 = plot(averTraject([1:end 1],1),averTraject([1:end 1],2),...
                'color',colors(2,:),'linewidth',1.5*line_width);
    p3 = plot(gd.pix2mm*td.groundTruth([1:end 1],1),gd.pix2mm*td.groundTruth([1:end 1],2),':k','linewidth',line_width);
    
    set(gca,'xtick',[],'ytick',[])
    
    if t == ceil(nTasks/2)
        toFixAxes = get(gca,'position');
        leg = legend([p1 p2 p3], toLegend,'fontsize',legend_size,...
            'location','southoutside','box','off','autoupdate','off');
        leg.NumColumns = 3;
        legPos = get(leg,'position');
        leg.Position = [0.24 (toFixAxes(2)-0.3*axes_height)/fig_height legPos(3:4)];
%     leg.box = 0;
        set(gca,'position',toFixAxes);
    end
    delete(p1)
    
    if t == nTasks
        axPos = get(gca,'position');
        linPos = nan(1,4);
        linPos(1) = (axPos(1) + 1.14 * axPos(3)) / fig_width;
        linPos(2) = (axPos(2) + 0.35 * axPos(4)) / fig_height;
        linPos(3) = (50 / xLims(2)) * axes_width / fig_width;
        linPos(4) = 0;
        annotation('line','linewidth',line_width,'position',linPos);
        
        annotation('textbox','Units','centimeters',...
        'Position',[axPos(1) + 1.13 * axPos(3)  (axPos(2) + 0.35 * axPos(4))  2*(50 / xLims(2)) * axes_width  0],...
        'String','5 cm','FontSize',legend_size,'LineStyle','none',...
        'horizontalalignment','left','verticalalignment','bottom','margin',0)
    end
    
    xlim(xLims)
    ylim(yLims)
    
%     set(gca,'position',newAxPos)
end    
    
    

%% Fig 2B,C,D

load motorwoc_wocvsindiv distToBinsIndivs
load motorwoc_crowderror distToBinsGroups

% panelName = {'_Fig02B','_Fig02C','_Fig02D'};
% toYLabel = {{'individual','error'},{'collective','error'},{'improvement','of the WOC'}};
toXLabel = {'Individual error','Collective error','Improvement of the WOC'};

for t = 1:nTasks

    taskName = motorwoc_cleaned_data.general_data.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])

    performanceMatrix = [distToBinsIndivs{t}, distToBinsGroups{t}, distToBinsIndivs{t} - distToBinsGroups{t}];

    mi = 0 * ones(3,1);
    ma = [max(performanceMatrix(:,1:2),[],'all'),...
          max(performanceMatrix(:,1:2),[],'all'),...
          max(performanceMatrix(:,3),[],'all')];
%     ma = [40 40 25];

    for d = 1:3
        
        posAxes = [margin_left + (t-1)*(axes_width + space_horiz) margin_bottom + (3-d)*(axes_height + space_vert)];
        axes('Units','centimeters','Position',[posAxes axes_width axes_height])
        set(gca,'color',background_color)

        dPlot = performanceMatrix(:,d);
        if d < 3
            colorLimits = [0 3.5];
        else
            colorLimits = [0 2.5];
        end
        dPlot(dPlot<colorLimits(1)) = colorLimits(1);
        dPlot(dPlot>colorLimits(2)) = colorLimits(2);

        caxis(colorLimits)
        ranged = colorLimits(2) - colorLimits(1);
        
        if d < 3
        	colormap jet
            cmap = colormap;
            defCmap = cmap;
        else
            colormap jet
            cmap = colormap;
            defCmap = cmap;
        end
        
        set(gca,'colormap',defCmap)
        
        cd = 1 + floor(63*(dPlot - colorLimits(1))/ranged);
        
        
        paplot = gd.pix2mm * [td.roundGroundTruth(end,:); td.roundGroundTruth; td.roundGroundTruth(1,:)];
        paplotExtended = nan(2*size(paplot,1),size(paplot,2));
        paplotExtended(1:2:end-1,:) = paplot;
        paplotExtended(2:2:end,:) = paplot;
        
        z = zeros(size(paplotExtended,1), 1);
        
        col = nan(2,size(paplotExtended,1), 3);
        col(1,1:2:end-1,:) = [defCmap(cd(end),:); defCmap(cd,:); defCmap(cd(1),:)];
        col(1,2:2:end,:) = [defCmap(cd(end),:); defCmap(cd,:); defCmap(cd(1),:)];
        
        col(2,1:2:end-1,:) = [defCmap(cd(end),:); defCmap(cd,:); defCmap(cd(1),:)];
        col(2,2:2:end,:) = [defCmap(cd(end),:); defCmap(cd,:); defCmap(cd(1),:)];
        
        surface([paplotExtended(:,1)';paplotExtended(:,1)'],...
                [paplotExtended(:,2)';paplotExtended(:,2)'],[z';z'],col,...
                'facecol','no','edgecol','interp','linew',colorline_width);

        hold on
        
        if t == nTasks
            cbar = colorbar;
            cbarPos = get(cbar,'position');
            cbar.Position = [cbar_horiz cbarPos(2) 2.25*cbarPos(3) cbarPos(4)];
            cbar.Ticks = [0:colorLimits(2)-0.5 colorLimits(2)];
            cbar.TickLabels = {0:colorLimits(2)-0.5,['>' num2str(colorLimits(2))]};
            cbar.FontSize = cbar_fontsize;
            cbar.Label.Rotation = 270;
            cbar.Label.VerticalAlignment = 'bottom';
%             ylabel(cbar,'mm','fontsize',label_size);
            text(xLims(2)+0.35*range(xLims),yLims(1)+0.5*range(yLims),'mm',...
                   'verticalalignment','bottom','horizontalalignment','center',...
                   'rotation',270,'fontsize',label_size)
        end
        
        set(gca,'xtick',[],'ytick',[])
%         plot([10 20],[5 5],'k','linewidth',3)
%         text(15,6.5,'1 cm','fontsize',14,...
%             'horizontalalignment','center','verticalalignment','bottom')
        line([xLims(1) xLims(2)],[yLims(2) yLims(2)],'color','k')
        line([xLims(2) xLims(2)],[yLims(1) yLims(2)],'color','k')
        xlim(xLims)
        ylim(yLims)
%       
%         if t == 1
%             text(xLims(1)-0.08*range(xLims),yLims(1)+0.5*range(yLims),toYLabel{d},...
%                    'verticalalignment','bottom','horizontalalignment','center',...
%                    'rotation',90,'fontsize',label_size)
%         end
        if t == 3
            text(xLims(1)+0.5*range(xLims),yLims(1)-0.15*range(yLims),toXLabel{d},...
                   'verticalalignment','middle','horizontalalignment','center',...
                   'rotation',0,'fontsize',label_size)
        end

    end
end



%%

set(gcf,'units','centimeters')
posFig=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',posFig(3:4),'PaperPosition',[0 0 posFig(3:4)])
print('-djpeg','-r600','motorwoc_Fig02.jpeg')
% savefig('motorwoc_Fig02') % Too heavy!













