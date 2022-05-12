% This computes the error (distance to bins and to truth)
% using one segment from each individual of the whole crowd.
% For collective error of a subset (i.e. 50 subjs), see motorwoc_wocvsindiv.m


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

% distance to each bin of the rounded ground truth from 
% each trajectory made using segments from different subjects
distToBinsEachGroup = cell(1,nTasks);
% average individual error per bin across 
% all the trajectories made using segments from different subjects
distToBinsGroups = cell(1,nTasks);
% and the confidence intervales for the above quantities
confIntBinsGroups = cell(1,nTasks);
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
% number of random groups to be created0
nGroups = 500; 


for t = 1:nTasks
    disp(['task ' num2str(t)])
    tic
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nBins = length(td.roundGroundTruth);
    nSubj = length(td.iSubjOK); % total number of subjects
    
    trajectsThisTask = procTrajects{t};
    nSegments = size(trajectsThisTask,2);
    
    % distance to each bin of the aggregated trajectory
    dTBEachGroup = nan(nBins,nGroups);
    % average distance to truth of the aggregated trajectory
    dTTEachGroup = nan(1,nGroups);

    for g = 1:nGroups

        iSelSubj = randperm(nSubj,nSubj); % subjects selected for current group
        iSelSegmGroup = randi(nSegments,1,nSubj); % selected segment of each subject's trajectory

        xSegm = nan(nBins,nSubj);
        ySegm = nan(nBins,nSubj);

        for k = 1:nSubj
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
        % distance to each bin of the aggregated trajectory
        dTBEachGroup(:,g) = distToBinsCurrent;
        % average distance to truth of the aggregated trajectory
        dTTEachGroup(g) = mean(distToBinsCurrent,'omitnan');
    end

    distToBinsEachIteration = nan(nBins,timBoot);
    distToTruthEachIteration = nan(1,timBoot);

    for tb = 1:timBoot

        dTBRandomExtract = nan(nBins,nGroups);
        dTTRandomExtract = nan(1,nGroups); 
        subjCurrentIter = randi(nSubj,1,nSubj);  % subjects selected (with replacement) for current iteration 

        for g = 1:nGroups

            iSelSubj = subjCurrentIter(randperm(length(subjCurrentIter),nSubj)); % subjects selected for current group
            iSelSegmGroup = randi(nSegments,1,nSubj); % selected segment of each subject's trajectory

            xSegm = nan(nBins,nSubj);
            ySegm = nan(nBins,nSubj);

            for k = 1:nSubj
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
            % distance to each bin of the aggregated trajectory
            dTBRandomExtract(:,g) = distToBinsCurrent;
            % average distance of the aggregated trajectory to truth
            dTTRandomExtract(g) = mean(distToBinsCurrent,'omitnan');
        end

        distToBinsEachIteration(:,tb) = mean(dTBRandomExtract,2,'omitnan');
        distToTruthEachIteration(tb) = mean(dTTRandomExtract,'omitnan');
    end
        
    
    % distance to each bin of the rounded ground truth from 
    % each trajectory made using segments from different subjects
    distToBinsEachGroup{t} =  dTBEachGroup;
    % average individual error per bin across 
    % all the trajectories made using segments from different subjects
    distToBinsGroups{t} = mean(dTBEachGroup,2,'omitnan');
    % and the confidence intervales for the above quantities
    confIntBinsGroups{t} = [prctile(distToBinsEachIteration,2.5,2),...
                                   prctile(distToBinsEachIteration,97.5,2)];
    % average distance to rounded ground truth from each trajectory made 
    % using segments from different subjects
    distToTruthEachGroup{t} = dTTEachGroup;
    % average individual error across all the trajectories made 
    % using segments from different subjects
    distToTruthGroups{t} = mean(dTTEachGroup,'omitnan');
    % and the confidence intervales for the above quantities
    confIntTruthGroups{t} = [prctile(distToTruthEachIteration,2.5);...
                                   prctile(distToTruthEachIteration,97.5)];
    
    toc  
     
end


save('motorwoc_crowderror.mat','nGroups','timBoot',...
    'distToBinsEachGroup','distToBinsGroups','confIntBinsGroups',...
    'distToTruthEachGroup','distToTruthGroups','confIntTruthGroups')


% delete(gcp('nocreate'))



