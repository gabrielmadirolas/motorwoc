% Computes the expected error for groups of 50, for age thresholds that
% will range from all the values that allow to have at least 50 subjects
% of each class. Then, for Fig 02G, threshold of 10.5 will be selected

clearvars
% close all

% if isempty(gcp('nocreate'))
%     tic 
%     parpool
%     toc
% end


load motorwoc_disttobins
load motorwoc_indiverror
load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);

% threshold to separate child (low-skilled) from teens (high-skilled)
stepThres = 0.5; % ideal is 0.5
ageThresValues = 10:stepThres:17.5;
nThres = length(ageThresValues);

% number of subjects of woc
groupSize = 50;
% number of random groups to be created
nGroups = 1000; % Final value must be 10000 

timBootIndivs = 10000; % This was 100000, but can be set to 10000
timBootGroups = 200; % Final value must be 500

distToTruthClassIndivs = cell(1,nTasks);
confIntTruthClassIndivs = cell(1,nTasks);
    
distToTruthClassGroups = cell(1,nTasks);
confIntTruthClassGroups = cell(1,nTasks);

age = cell(1,nTasks);
iClass = cell(1,nTasks);
nClasses = 2;


for t = 1:nTasks
    disp(['task ' num2str(t)])
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nBins = length(td.roundGroundTruth);
    
    distsIndivs = distToTruthEachTraject{t}{1};
    
    ageThisTask = [td.subjectDataCleaned(:).age]';
    age{t} = ageThisTask;
    
    iClassThisTask = cell(1,nThres);
    
    dTTI_ThisTask = cell(1,nThres);
    cITI_ThisTask = cell(1,nThres);
    
    dTTG_ThisTask = cell(1,nThres);
    cITG_ThisTask = cell(1,nThres);
    
    for a = 1:nThres
        tic

        % average distance to rounded ground truth from the trajectories
        % for each class
        dTTI = nan(1,nClasses);
        cITI = nan(2,nClasses);

        dTTG = nan(1,nClasses);
        cITG = nan(2,nClasses);
        
        ageThreshold = ageThresValues(a);
        iChild = find(ageThisTask<ageThreshold);
        iTeen = find(ageThisTask>=ageThreshold);

        iClassThisThres = {iChild, iTeen};
        iClassThisTask{a} = iClassThisThres;
%         nClasses = length(iClassThisTask);
        nSubjClass = cellfun('length',iClassThisThres);

        if nSubjClass >= 50
            for s = 1:nClasses

                % individuals

                distsThisClass = distsIndivs(iClassThisThres{s},:);
                dTTI(s) = mean(distsThisClass(:),'omitnan');

                distRandomExtract = nan(timBootIndivs,1);

                for tb = 1:timBootIndivs
                    randSubj = datasample(distsThisClass,nSubjClass(s),1);
                    distRandomExtract(tb) = mean(randSubj(:),'omitnan');
                end

                cITI(:,s) = [prctile(distRandomExtract,2.5);...
                                           prctile(distRandomExtract,97.5)];


                % crowd

                trajectsThisTask = procTrajects{t};
                nSegments = size(trajectsThisTask,2);

                groupSizeTrunc = min(nSubjClass(s),groupSize);
                distToTruthAllGroups = nan(1,nGroups);

                for g = 1:nGroups

                    iSelSubj = randperm(nSubjClass(s),groupSizeTrunc); % subjects selected for current group
                    iSelSegmGroup = randi(nSegments,1,groupSizeTrunc); % selected segment of each subject's trajectory

                    xSegm = nan(nBins,groupSizeTrunc);
                    ySegm = nan(nBins,groupSizeTrunc);

                    for k = 1:groupSizeTrunc
                        i = iClassThisThres{s}(iSelSubj(k)); % subject label
                        iSegm = iSelSegmGroup(k); % selected segment

                        xSegm(:,k) = trajectsThisTask{i,iSegm}(:,1);
                        ySegm(:,k) = trajectsThisTask{i,iSegm}(:,2);
                    end

                    roundTraceGroup = [median(xSegm,2,'omitnan'), ...
                                       median(ySegm,2,'omitnan')];

                    % distance to each bin of the rounded ground truth
                    % from the rounded aggregated trajectory
                    distToBinsCurrent = sqrt((gd.pix2mm*td.roundGroundTruth(:,1)-roundTraceGroup(:,1)).^2 +...
                                             (gd.pix2mm*td.roundGroundTruth(:,2)-roundTraceGroup(:,2)).^2);
                    % average distance of the aggregated trajectory to truth
                    distToTruthAllGroups(g) = mean(distToBinsCurrent,'omitnan');
                end


                dTTG(s) = mean(distToTruthAllGroups,'omitnan');


                distEachIteration = nan(1,timBootGroups);

                for tb = 1:timBootGroups

                    distRandomExtract = nan(1,nGroups); 
                    % subjects selected (with replacement) for current iteration 
                    subjCurrentIter = iClassThisThres{s}(randi(nSubjClass(s),1,nSubjClass(s)));  

                    for g = 1:nGroups

                        iSelSubj = subjCurrentIter(randperm(nSubjClass(s),groupSizeTrunc)); % subjects selected for current group
                        iSelSegmGroup = randi(nSegments,1,groupSizeTrunc); % selected segment of each subject's trajectory

                        xSegm = nan(nBins,groupSizeTrunc);
                        ySegm = nan(nBins,groupSizeTrunc);

                        for k = 1:groupSizeTrunc
                            i = iSelSubj(k); % subject label
                            iSegm = iSelSegmGroup(k); % selected segment

                            xSegm(:,k) = trajectsThisTask{i,iSegm}(:,1);
                            ySegm(:,k) = trajectsThisTask{i,iSegm}(:,2);
                        end

                        roundTraceGroup = [median(xSegm,2,'omitnan'), ...
                                           median(ySegm,2,'omitnan')];

                        % distance to each bin of the rounded ground truth
                        % from the rounded aggregated trajectory
                        distToBinsCurrent = sqrt((gd.pix2mm*td.roundGroundTruth(:,1)-roundTraceGroup(:,1)).^2 +...
                                                 (gd.pix2mm*td.roundGroundTruth(:,2)-roundTraceGroup(:,2)).^2);
                        % average distance of the aggregated trajectory to truth

                        distRandomExtract(g) = mean(distToBinsCurrent,'omitnan');
                    end

                    distEachIteration(tb) = mean(distRandomExtract,'omitnan');
                end

                cITG(:,s) = [prctile(distEachIteration,2.5);...
                                           prctile(distEachIteration,97.5)];
            end
        end
        
        dTTI_ThisTask{a} = dTTI;
        cITI_ThisTask{a} = cITI;
    
        dTTG_ThisTask{a} = dTTG;
        cITG_ThisTask{a} = cITG;
    
        toc
    end
    
    iClass{t} = iClassThisTask;
        
    distToTruthClassIndivs{t} = dTTI_ThisTask;
    confIntTruthClassIndivs{t} = cITI_ThisTask;

    distToTruthClassGroups{t} = dTTG_ThisTask;
    confIntTruthClassGroups{t} = cITG_ThisTask;
     
end

save('motorwoc_classerror.mat','age','ageThresValues','iClass',...
    'groupSize','nGroups','timBootIndivs','timBootGroups',...
    'distToTruthClassIndivs','confIntTruthClassIndivs',...
    'distToTruthClassGroups','confIntTruthClassGroups')
% delete(gcp('nocreate'))



