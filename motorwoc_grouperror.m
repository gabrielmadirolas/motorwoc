% This computes the distance to truth when aggregating 
% different number of subjects


clearvars
% close all

% if isempty(gcp('nocreate'))
%     tic 
%     parpool
%     toc
% end


load motorwoc_disttobins
load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);

% average distance to rounded ground truth from each trajectory made 
% using segments from different subjects
distToTruthEachGroup = cell(1,nTasks);
% average individual error across all the trajectories made 
% using segments from different subjects
distToTruthGroups = cell(1,nTasks);
% and the confidence intervales for the above quantities
confIntTruthGroups = cell(1,nTasks);
% number of randomizations to compute the confidence intervals
timBoot = 500;

% different group sizes to be analyzed
groupSizes = [1:8 10 12 15:5:50 nan];
nGroupSizes = length(groupSizes);
% number of random groups to be created for each size
nGroups = [10000*ones(1,nGroupSizes-1) 500]; 


for t = 1:nTasks
    disp(['task ' num2str(t)])
    tic
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nBins = length(td.roundGroundTruth);
    nSubj = length(td.iSubjOK); % total number of subjects
    groupSizes(end) = nSubj;
    
    trajectsThisTask = procTrajects{t};
    nSegments = size(trajectsThisTask,2);
  
    % average distance to rounded ground truth from each trajectory made 
    % using segments from different subjects
    dTTEachGroup = cell(1,nGroupSizes);
    % average individual error across all the trajectories made 
    % using segments from different subjects
    dTTGroups = nan(1,nGroupSizes);
    % number of randomizations to compute the confidence intervals
    cITGroups = nan(2,nGroupSizes);
    
    for s = 1:nGroupSizes
        
        groupSize = groupSizes(s);
        nGroupsThisSize = nGroups(s);
        % average distance of the aggregated trajectory to truth
        distToTruthThisGSize = nan(1,nGroupsThisSize);
        
        for g = 1:nGroupsThisSize
            
            iSelSubj = randperm(nSubj,groupSize); % subjects selected for current group
            iSelSegmGroup = randi(nSegments,1,groupSize); % selected segment of each subject's trajectory
            
            xSegm = nan(nBins,groupSize);
            ySegm = nan(nBins,groupSize);

            for k = 1:groupSize
                i = iSelSubj(k); % subject label
                iSegm = iSelSegmGroup(k); % selected segment
                
                xSegm(:,k) = trajectsThisTask{i,iSegm}(:,1);
                ySegm(:,k) = trajectsThisTask{i,iSegm}(:,2);
            end
            
            roundTraceGroup = [median(xSegm,2,'omitnan'), ...
                               median(ySegm,2,'omitnan')];
            
            % distance to each bin of the rounded ground truth
            % from the rounded aggregated trajectory
            distToBinsCurrent = sqrt((gd.pix2mm * td.roundGroundTruth(:,1)-roundTraceGroup(:,1)).^2 +...
                                     (gd.pix2mm * td.roundGroundTruth(:,2)-roundTraceGroup(:,2)).^2);
            % average distance of the aggregated trajectory to truth
            distToTruthThisGSize(g) = mean(distToBinsCurrent,'omitnan');
        end
        
        dTTEachGroup{s} = distToTruthThisGSize;
        dTTGroups(s) = mean(distToTruthThisGSize,'omitnan');
        
        
        distEachIteration = nan(1,timBoot);
        
        for tb = 1:timBoot
            
            distRandomExtract = nan(1,nGroupsThisSize); 
            subjCurrentIter = randi(nSubj,1,nSubj);  % subjects selected (with replacement) for current iteration 
            
            for g = 1:nGroupsThisSize
            
                iSelSubj = subjCurrentIter(randperm(length(subjCurrentIter),groupSize)); % subjects selected for current group
                iSelSegmGroup = randi(nSegments,1,groupSize); % selected segment of each subject's trajectory

                xSegm = nan(nBins,groupSize);
                ySegm = nan(nBins,groupSize);

                for k = 1:groupSize
                    i = iSelSubj(k); % subject label
                    iSegm = iSelSegmGroup(k); % selected segment

                    xSegm(:,k) = trajectsThisTask{i,iSegm}(:,1);
                    ySegm(:,k) = trajectsThisTask{i,iSegm}(:,2);
                end

                roundTraceGroup = [median(xSegm,2,'omitnan'), ...
                                   median(ySegm,2,'omitnan')];

                % distance to each bin of the rounded ground truth
                % from the rounded aggregated trajectory
                distToBinsCurrent = sqrt((gd.pix2mm * td.roundGroundTruth(:,1)-roundTraceGroup(:,1)).^2 +...
                                         (gd.pix2mm * td.roundGroundTruth(:,2)-roundTraceGroup(:,2)).^2);
                % average distance of the aggregated trajectory to truth

                distRandomExtract(g) = mean(distToBinsCurrent,'omitnan');
            end
            
            distEachIteration(tb) = mean(distRandomExtract,'omitnan');
        end

        cITGroups(:,s) = [prctile(distEachIteration,2.5);...
                                   prctile(distEachIteration,97.5)];

    end
    
    % average distance to rounded ground truth from each trajectory made 
    % using segments from different subjects
    distToTruthEachGroup{t} = dTTEachGroup;
    % average individual error across all the trajectories made 
    % using segments from different subjects
    distToTruthGroups{t} = dTTGroups;
    % and the confidence intervales for the above quantities
    confIntTruthGroups{t} = cITGroups;
    
    toc  
     
end


save('motorwoc_grouperror.mat','groupSizes','nGroups','timBoot',...
    'distToTruthEachGroup','distToTruthGroups','confIntTruthGroups')


% delete(gcp('nocreate'))



