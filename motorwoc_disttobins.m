
clearvars
% close all


load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);

distToBins = cell(1,nTasks);
procTrajects = cell(1,nTasks);

% size of the selected segment of the trajectories, normalized to the
% full size of the trajectory:
nSegments = 8;
propSegm = 1/nSegments;


for t = 1:nTasks
    disp(['task ' num2str(t)])
    tic
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nBins = length(td.roundGroundTruth);

    nSubj = length(td.iSubjOK); % total number of subjects
    subjects = td.subjectDataCleaned;
    
    % for each trajectory, assigns one average point per bin of the rounded
    % ground truth
    roundTrajecSubj = cell(nSubj,nSegments);
    % distance to each bin of the rounded ground truth from 
    % the rounded selected segment of the subject
    distToBinsSubj = cell(nSubj,nSegments);
    for i = 1:nSubj
        x = subjects(i).x';
        y = subjects(i).y';
        lenTraj = length(x);
        limInfSegm = ceil(linspace(1,lenTraj,nSegments+1));
        limSupSegm = limInfSegm-1;
        limInfSegm = limInfSegm(1:end-1);
        limSupSegm = limSupSegm(2:end);
        limSupSegm(end) = limSupSegm(end)+1;
        
        for s = 1:nSegments
            
            xSegm = x(limInfSegm(s):limSupSegm(s));
            ySegm = y(limInfSegm(s):limSupSegm(s));
            lenSegm = length(xSegm);
            
            distPointsToTruth = nan(lenSegm,2); % for each point in the trajectory drawn, computes
                                    % to which bin of the averaged ground truth it is closer
            for j = 1:lenSegm
                [minDist, posMin] = distToLine([xSegm(j) ySegm(j)],td.roundGroundTruth);
                distPointsToTruth(j,:) = [minDist posMin];
            end

            roundTraceSubj = nan(nBins,2); 
            for j =1:nBins
                try 
                    roundTraceSubj(j,:) = gd.pix2mm * median([xSegm(distPointsToTruth(:,2)==j),...
                                            ySegm(distPointsToTruth(:,2)==j)],1,'omitnan');
                catch
                    roundTraceSubj(j,:) = [nan, nan];
                end
            end
            
            roundTrajecSubj{i,s} = roundTraceSubj;
            distToBinsSubj{i,s} = sqrt((gd.pix2mm * td.roundGroundTruth(:,1)-roundTraceSubj(:,1)).^2 +...
                                     (gd.pix2mm * td.roundGroundTruth(:,2)-roundTraceSubj(:,2)).^2);
        end
    end
    
    distToBins{t} = distToBinsSubj; 
    procTrajects{t} = roundTrajecSubj;
    
    toc  
   
end

save('motorwoc_disttobins.mat','distToBins','procTrajects')




