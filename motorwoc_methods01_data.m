
close all
clearvars

load motorwoc_disttobins
load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;


t = 5; % which task use for the plot

taskName = gd.taskNames{t};
eval(['td = motorwoc_cleaned_data.' taskName ';'])

nBins = length(td.roundGroundTruth);
% groupSize = length(td.iSubjOK); % total number of subjects

trajectsThisTask = procTrajects{t};
nSegments = size(trajectsThisTask,2);

groundTruth = gd.pix2mm * td.groundTruth;
x = groundTruth(:,1);
y = groundTruth(:,2);

xGroundTruth = [x; x(1)]; % repeat x to avoid holes in the plot
yGroundTruth = [y; y(1)]; % same with y as above

roundGroundTruth = gd.pix2mm * td.roundGroundTruth;

% tangential segments
extRGT = [roundGroundTruth; roundGroundTruth(1,:)];
propLine = 3.5;
newVerts = nan(nBins,4);

for n = 1:nBins
    midVerts = mean(extRGT(n:n+1,:),1);
    midToVert = extRGT(n+1,:) - midVerts;
    rotMat = [cos(pi/2) -sin(pi/2); sin(pi/2) cos(pi/2)];
    newVerts(n,1:2) = midVerts + propLine*(midToVert * rotMat');
    newVerts(n,3:4) = midVerts + propLine*(midToVert * rotMat);
end



% subjects
% previously [1 3 4 7 6 ], with iSelSegmGroup = [1 1 1 3 1]
% also [1 3 4 13 6 ], with iSelSegmGroup = [1 1 1 5 1]
% iSelSubj = [1 3 4 15 6 ]; % previously [1 3 4 7 6 ], with iSelSegmGroup = [1 1 1 3 1]
iSelSubj = [4 3 15 6 ]; % remove traj #1, it was [4 3 1 15 6 ], with [1 1 1 3 1]
groupSize = length(iSelSubj);
iSelSegmGroup = [1 8 3 1]; % selected segment of each subject's trajectory
iExaSubj = 1; % example subject to show how to create individual trajectories


subjects = td.subjectDataCleaned(iSelSubj);
    
% for each trajectory, assigns one average point per bin of the rounded
% ground truth
roundTrajecSubj = cell(groupSize,nSegments);
for i = 1:groupSize
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
        
        if i == iExaSubj && s == iSelSegmGroup(i)
            xExaTrajec = gd.pix2mm * xSegm;
            yExaTrajec = gd.pix2mm * ySegm;
        end

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
    end
end


xIndivTrajec = nan(nBins,groupSize);
yIndivTrajec = nan(nBins,groupSize);

for i = 1:groupSize
    iSegm = iSelSegmGroup(i); % selected segment

    xIndivTrajec(:,i) = roundTrajecSubj{i,iSegm}(:,1);
    yIndivTrajec(:,i) = roundTrajecSubj{i,iSegm}(:,2);
end

roundTrajecGroup = [median(xIndivTrajec,2,'omitnan'), ...
                   median(yIndivTrajec,2,'omitnan')];



clear motorwoc_cleaned_data procTrajects td distToBins trajectsThisTask
save motorwoc_methods01_data

