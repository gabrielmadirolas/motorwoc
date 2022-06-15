% old figure 3, wiith the individual error respect to age, and the
% histogram of ages

clearvars
close all


load motorwoc_indiverror
load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);


%%

scale_factor = 1;

fig_pos = [10 5] * scale_factor;

fig_width = 11 * scale_factor;

margin_left = 1.75 * scale_factor;
margin_right = 0.5 * scale_factor;
margin_bottom = 1.5 * scale_factor;
margin_top = 0.75  * scale_factor;

space_vert = 1.5 * scale_factor;

axes_width = fig_width - margin_left - margin_right;
axes_height = 0.6 * axes_width;

fig_height = margin_bottom + 2 * axes_height + 1 * space_vert + margin_top ;

letter_size = 17 * scale_factor;
letter_horiz = 0.1 * margin_left;
letter_vert = 1 * axes_height; 
letter_weight = 'normal';
letter_angle = 'italic';

% colorline_width = 3 * scale_factor;
% background_color = 0.75*ones(1,3);

line_width = 2 * scale_factor;
marker_size = 5 * scale_factor;
label_size = 13 * scale_factor;
tick_size = 10 * scale_factor; 
legend_size = 12 * scale_factor;


%%

f = figure;
set(gcf,'Units','centimeters','Position',[fig_pos fig_width fig_height])
set(gcf, 'InvertHardcopy', 'off')
set(gcf,'Units','centimeters')
set(gcf,'color',[1 1 1])


annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 2*axes_height + 1*space_vert 0 0],...
    'String','(a)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)

annotation('textbox','Units','centimeters',...
    'Position',[letter_horiz  margin_bottom + 1*axes_height + 0*space_vert 0 0],...
    'String','(b)','FontSize',letter_size,...
    'FontWeight',letter_weight,'FontAngle',letter_angle,'LineStyle','none',...
    'horizontalalignment','left','verticalalignment','bottom','margin',0)



%% 

timBoot = 100000;
maxAge = 19;
minAge = 6;
stepAge = 1;
ageXAxis = minAge:stepAge:maxAge;
nAges = length(ageXAxis);
distByAge = nan(nAges-1,nTasks);
% confDistByAge = 
distRandomExtract = nan(timBoot,nAges-1,nTasks);
histAge = nan(nAges-1,nTasks);

for t = 1:nTasks
   tic
    taskName = motorwoc_cleaned_data.general_data.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    distToTruthAverEachSubj = mean(distToTruthEachTraject{t}{1},2,'omitnan');
    
    age = [td.subjectDataCleaned(:).age];
    
    for ag = 1:nAges-1
        
        distThisAge = distToTruthAverEachSubj(ageXAxis(ag)<=age & age<ageXAxis(ag+1));
        distByAge(ag,t) = mean((distThisAge),'omitnan');
% 
        for tb = 1:timBoot
            randSubj = datasample(distThisAge,length(distThisAge));
            distRandomExtract(tb,ag,t) = mean(randSubj(:),'omitnan');
        end
    end
    
    
    tempFig = figure;
    age = [td.subjectDataCleaned(:).age];
    ha = histogram(age,ageXAxis);
    histAge(:,t) = ha.Values;
    close(tempFig)
    toc
end

histAllTasks = mean(histAge,2,'omitnan');
distAllTasks = mean(distByAge,2,'omitnan');

distThisRandAndAge = nan(timBoot,nAges-1);
for tb = 1:timBoot
    
    for ag = 1:nAges-1
        distThisRandAndAge(tb,ag) = mean(distRandomExtract(tb,ag,:));
    end

% 
%         cITI(:,s) = [prctile(distRandomExtract,2.5);...
%                                prctile(distRandomExtract,97.5)];

end

confDistAllTasks = [prctile(distThisRandAndAge,2.5,1);...
                               prctile(distThisRandAndAge,97.5,1)];


%% Fig 4A

posAxes = [margin_left  margin_bottom + axes_height + space_vert];
axes('Units','centimeters','Position',[posAxes axes_width axes_height])

colors = get(gca,'colororder');
hold on

bar(ageXAxis(1:end-1)+0.5,histAllTasks,'facecolor',colors(1,:),'facealpha',0.8)

% set(gca,'xtick',[])
xlabel('age','fontsize',label_size)
ylabel('number of subjects','fontsize',label_size)


%% Fig 4B

posAxes = [margin_left  margin_bottom];
axes('Units','centimeters','Position',[posAxes axes_width axes_height])

colors = get(gca,'colororder');
hold on

% extAgeXAxis = [ageXAxis(1:end-1)+0.5 fliplr(ageXAxis(1:end-1))+0.5];
% repConfDist = [confDistAllTasks(1,:) fliplr(confDistAllTasks(2,:))];
% fi1 = fill(extAgeXAxis, repConfDist, colors(1,:),'edgecolor','none');
% set(fi1, 'facealpha', 0.3)
% plot(ageXAxis(1:end-1)+0.5,distAllTasks,'color',colors(1,:),'linewidth',line_width)

confInf = distAllTasks'-confDistAllTasks(1,:);
confSup = confDistAllTasks(2,:)-distAllTasks';
% confInf(confInf==confSup) = nan;
% confSup(isnan(confInf)) = nan;

eBar = errorbar(ageXAxis(1:end-1)+stepAge/2,distAllTasks,confInf,confSup);
eBar.Color = colors(1,:);                            
eBar.LineStyle = 'none';
eBar.LineWidth = line_width;

plot(ageXAxis(1:end-1)+stepAge/2,distAllTasks,'o','color',colors(1,:),'markerfacecolor',colors(1,:),'markersize',marker_size)

xlabel('age','fontsize',label_size)
ylabel('individual error (mm)','fontsize',label_size)

xlim([ageXAxis(1)-stepAge/2 ageXAxis(end)+stepAge/2])
% ylim([0 4])
% 
% % This is to add a vertical line between children and teens
% xLims = get(gca,'xlim');
% yLims = get(gca,'ylim');
% plot([10.5 10.5],[2 4],'k:','linewidth',0.75*line_width)
% ylim(yLims)
% plot(ageXAxis(1:end-1)+stepAge/2,distAllTasks,'o','color',colors(1,:),'markerfacecolor',colors(1,:),'markersize',marker_size)
% 
% 
% line([xLims(1) xLims(2)],[yLims(2) yLims(2)],'color','k')
% line([xLims(2) xLims(2)],[yLims(1) yLims(2)],'color','k')
% 
% % toXLabels = {'6','8','10','12','14','16','18'};
% toYLabels = {'0','50','100','150','2','2.5','3','3.5','4'};
% set(gca,'xtick',ageXAxis,'fontsize',15,...
%     'ytick',0:0.5:4,'yTickLabels',toYLabels)
% xlabel('age','fontsize',16)
%    
% text(xLims(1)-0.10*range(xLims),yLims(1)+0.045*range(yLims),'number of subjects',...
%                'verticalalignment','bottom','horizontalalignment','left',...
%                'rotation',90,'fontsize',17)
% 
% text(xLims(1)-0.10*range(xLims),yLims(1)+0.56*range(yLims),'individual error (mm)',...
%                'verticalalignment','bottom','horizontalalignment','left',...
%                'rotation',90,'fontsize',17)

           
           
%%
           
set(gcf,'units','centimeters')
pos=get(gcf,'Position');
set(gcf,'PaperUnits','centimeters','PaperSize',pos(3:4),'PaperPosition',[0 0 pos(3:4)])
print('-djpeg','-r300','motorwoc_Fig04.jpeg')
savefig('motorwoc_Fig04')





