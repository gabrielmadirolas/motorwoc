% this script computes distance to bins for single individuals and for woc


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

groupSize = 50; % for error using all subjects, see motorwoc_crowderror.m
% number of random groups to be created for woc error
nGroups = 100000; 

% average distance to rounded ground truth from the trajectories made 
% using one segment from one single subject
distToBinsIndivs = cell(1,nTasks);
% average distance to each bin of the rounded ground truth
% from the rounded aggregated trajectory
distToBinsGroup = cell(1,nTasks);


for t = 1:nTasks
    disp(['task ' num2str(t)])
    tic
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nBins = length(td.roundGroundTruth);
    nSubj = length(td.iSubjOK); % total number of subjects
    
    trajectsThisTask = procTrajects{t};
    nSegments = size(trajectsThisTask,2);
       
    % average distance to rounded ground truth from the trajectories made 
    % one segment from one single subject
    dTBI = nan(nBins,1);
    
    for n = 1:nBins
        distsCurrentBin = cellfun(@(v)v(n),distToBins{t});
        dTBI(n) = mean(distsCurrentBin(:),'omitnan');
    end
    
    distToBinsIndivs{t} = dTBI;
    
    distToBinsAllGroups = nan(nBins,nGroups);
    for g = 1:nGroups
            
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
        distToBinsAllGroups(:,g) = sqrt((gd.pix2mm*td.roundGroundTruth(:,1)-roundTraceGroup(:,1)).^2 +...
                                 (gd.pix2mm*td.roundGroundTruth(:,2)-roundTraceGroup(:,2)).^2);
    end


    distToBinsGroup{t} = mean(distToBinsAllGroups,2,'omitnan');
    
    toc  
    
end

save('motorwoc_wocvsindiv.mat','groupSize','nGroups',...
    'distToBinsIndivs','distToBinsGroup')


% delete(gcp('nocreate'))
