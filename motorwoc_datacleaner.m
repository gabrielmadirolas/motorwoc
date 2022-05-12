
% Script to reject weird trajectories. More specifically, founds the
% indexes of those subjects whose trajectories were either too short, too
% stretched, or centered too far from the center of the template. These
% criteria are selected to find subjects that might have encountered
% problems to trace the trajectories whilee performing the task.
% Also rejects repeated data from same subject and task

clearvars
close all

taskNames = {'tracing_ellipse','tracing_ellipse_long',...
    'tracing_flower3','tracing_flower4','tracing_lemniscate'};
nTasks = length(taskNames);

nBinsAllTasks = [50 50 100 100 100];

pixelsXScreen = 1920;
pixelsYScreen = 1200;
mmXScreen = 216;
mmYScreen = 135;
pix2mm = mean([mmXScreen / pixelsXScreen, mmYScreen / pixelsYScreen]);
pixelsDiagScreen = sqrt(pixelsXScreen^2+pixelsYScreen^2);

% limLowSpeed = 20;
% limMidSpeed = 100;
limHighSpeed = 2000;
limJumpLength = 1/4;

% % maximum distance between the center of the figure and the mean of 
% % the trajectory coordinates, normalized to distance from the center to
% % max or min of ground truth
% meanFactor = 1/2;
% minimum std of both coordinates of the trajectory, normalized to ground truth
stdFactor = 1/2;
% minimum length of the trajectory in seconds
minTime = 25;
% maximum age
maxAge = 18.99;

firstFrame = 11;

general_data.taskNames = taskNames;
general_data.nBinsAllTasks = nBinsAllTasks;
general_data.pixelsXScreen = pixelsXScreen;  
general_data.pixelsYScreen = pixelsYScreen; 
general_data.mmXScreen = mmXScreen;  
general_data.mmYScreen = mmYScreen; 
general_data.pix2mm = pix2mm; 
general_data.limJumpLength = limJumpLength; 
general_data.stdFactor = stdFactor; 
general_data.minTime = minTime; 
general_data.firstFrame = firstFrame;

motorwoc_cleaned_data.general_data = general_data;


for t = 1:nTasks

    toDataLoadName = [taskNames{t} '_data.mat'];
    load(toDataLoadName)
    toStructSaveName = taskNames{t};
    
    toAllFigNames = extractBefore(truthFile,'.txt');

    fileID = fopen(truthFile,'r'); % ID assigned to the ground truth file
    truthCoords = fscanf(fileID,'%f',[2 inf]); % coordinates of the ground truth
    groundTruth = truthCoords'; % ground truth
    
    meanTruth = mean(groundTruth,'omitnan');
    meanToLeft = meanTruth(1) - min(groundTruth(:,1)); 
    meanToRight =  max(groundTruth(:,1)) - meanTruth(1); 
    meanToBottom = meanTruth(2) - min(groundTruth(:,2)); 
    meanToTop =  max(groundTruth(:,2)) - meanTruth(2); 
    stdTruth = std(groundTruth,'omitnan');
    
    nPointsTruth = size(groundTruth,1); % number of points in the ground truth
    nBins = nBinsAllTasks(t);
    
    % even bins
    xTruth = groundTruth(:,1);
    yTruth = groundTruth(:,2);
    lengthBinsTruth = sqrt((diff(xTruth([1:end 1]))).^2 + (diff(yTruth([1:end 1]))).^2);
    lengthWholeTruth = sum(lengthBinsTruth);
    limsBinsTruth = linspace(0,lengthWholeTruth,nBins+1);
    indTruth = cell(1,nBins);
    iT = 1:nPointsTruth;
    for n = 1:nBins
        indTruth{n} = iT(cumsum(lengthBinsTruth)>limsBinsTruth(n) & cumsum(lengthBinsTruth)<=limsBinsTruth(n+1));
    end
    
    extGroundTruth = [groundTruth; groundTruth(1,:)]; % append initial point at end
    roundGroundTruth = nan(nBins,2); % average coordinates of the ground truth points inside each bin
    for n = 1:nBins
        roundGroundTruth(n,:) = median(groundTruth(indTruth{n},:),1);
    end
    
% %     uneven bins       
%     indRound = round(linspace(1,nPointsTruth+1,nBins+1)); % index of the limits of the bins
%     extGroundTruth = [groundTruth; groundTruth(1,:)]; % append initial point at end
%     
%     roundGroundTruth = nan(nBins,2); % average coordinates of the ground truth points inside each bin
%     for n = 1:nBins
%         roundGroundTruth(n,:) = median(extGroundTruth(indRound(n):indRound(n+1),:),1);
%     end
% 
%     % x and y coordinates of rounded ground truth
%     xGT = roundGroundTruth(:,1);
%     yGT = roundGroundTruth(:,2);
% 
%     % as there are more points in the regions of the truth with higher
%     % curvature, the following weights are going to store the length of
%     % each bin of the rounded ground truth, so the weigth is the length of
%     % the bin normalized to the total length of the template
%     lenRoundTruthBins = sqrt((diff(xGT([end 1:end 1]))).^2 + (diff(yGT([end 1:end 1]))).^2);
%     weightsTruth = (lenRoundTruthBins(1:end-1) + lenRoundTruthBins(2:end)) / 2;
%     weightsTruth = weightsTruth/sum(weightsTruth);
    

    xCell = cellfun(@round,{subjectData(:).x},'UniformOutput',false);
    xStr = cellfun(@char, xCell,'uni',0);
    [~,iUnique,iWithRep] = unique(xStr,'stable');
%     iSubjRepeat = setdiff((1:nSubj)',iUnique);

    subjectDataCleaned = subjectData(iUnique);
    nSubj = length(subjectDataCleaned);
    
    age = [subjectDataCleaned(:).age];
    iSubjAdults = find(age' > maxAge);
    
    % too short trajectories
    iSubjShort = [];
    % too small trajectories
    iSubjSmall = [];
    % trajectories with jumps
    iSubjJumps = [];
    
    for i = 1:nSubj
        
        xSubj = subjectDataCleaned(i).x;
        ySubj = subjectDataCleaned(i).y;
        
        xSubj = xSubj(firstFrame:end);
        ySubj = ySubj(firstFrame:end);
        
        originalLength = length(xSubj);
        
        diffX = diff(xSubj);
        diffY = diff(ySubj);
        diffR = sqrt(diffX.^2+diffY.^2);
        
        zeroDiffR = diffR == 0;
        xSubj(zeroDiffR) = nan;
        ySubj(zeroDiffR) = nan;
        xSubj = xSubj(~isnan(xSubj));
        ySubj = ySubj(~isnan(ySubj));
        
        tim = subjectDataCleaned(i).t;
        tim = tim(firstFrame:end);
        tim(zeroDiffR) = nan;
        tim = tim(~isnan(tim));
        
        newLength = length(xSubj);
        propNonZeros = newLength/originalLength;
        
        meanSubj = mean([xSubj' ySubj'],1,'omitnan');
        stdSubj = std([xSubj' ySubj'],1,'omitnan');
        
        diffX = diff(xSubj);
        diffY = diff(ySubj);
        diffR = sqrt(diffX.^2+diffY.^2);
        
        diffTim = diff(tim);
        speedPix = diffR./diffTim;
        speedMm = speedPix * pix2mm;
        
        if isempty(tim) || propNonZeros * tim(end) < minTime
            iSubjShort = cat(1,iSubjShort,i);
        end
        
        if stdSubj(1) < stdFactor * stdTruth(1) || ...
           stdSubj(2) < stdFactor * stdTruth(2) %|| ...
%            meanSubj(1) < meanTruth(1) - meanFactor*meanToLeft || ...
%            meanSubj(1) > meanTruth(1) + meanFactor*meanToRight || ...
%            meanSubj(2) < meanTruth(2) - meanFactor*meanToBottom || ...
%            meanSubj(2) > meanTruth(2) + meanFactor*meanToTop 
            
            iSubjSmall = cat(1,iSubjSmall,i);
        end
        
        if  any(abs(diffX) > limJumpLength * pixelsXScreen) || ... 
            any(abs(diffY) > limJumpLength * pixelsYScreen) %|| ...
%             any(speedMm > limHighSpeed) || ...
%             any(diffR > limJumpLength * pixelsDiagScreen) 
            
        
            iSubjJumps = [iSubjJumps; i]; %#ok<AGROW>
            
%             [sortDiffR, indSort] = sort(diffR);
%             sortDiffX = xSubj(indSort);
%             sortDiffY = ySubj(indSort);
%             sortCoords = [sortDiffX; sortDiffY];
%             sortSpeed = speedMm(indSort);
%             h = figure;
%             plot(xSubj,ySubj)
%             hold on
% %             plot(xSubj(speedMm<limLowSpeed),ySubj(speedMm<limLowSpeed),'.g','markersize',18)
% %             plot(xSubj(speedMm>limLowSpeed&speedMm<limMidSpeed),...
% %                     ySubj(speedMm>limLowSpeed&speedMm<limMidSpeed),'om')
%             plot(xSubj(speedMm>limHighSpeed),ySubj(speedMm>limHighSpeed),'*k')
%             plot(xSubj(diffR > limJumpLength * pixelsDiagScreen),...
%                 ySubj(diffR > limJumpLength * pixelsDiagScreen),'sqk')
%             plot(groundTruth(:,1),groundTruth(:,2),'linewidth',2)
%             xlim([0 pixelsXScreen])
%             ylim([0 pixelsYScreen])
%             title(int2str(i))
% %             figure;plot(diffR./diffTim)
% %             figure;plot(diffTim/max(diffTim));hold on;plot(diffR/max(diffR))
%             keyboard
%             close
        end
        
        subjectDataCleaned(i).x = xSubj;
        subjectDataCleaned(i).y = ySubj;
        subjectDataCleaned(i).t = tim;
    end
%             keyboard
%     close all

    iSubjOut = unique([iSubjAdults; iSubjJumps; iSubjShort; iSubjSmall]);
    iSubjOK = setdiff(1:nSubj,iSubjOut);
    
    subjectDataCleaned = subjectDataCleaned(iSubjOK);
    
%     keyboard
    % % Plot the rejected trajectories:
    % for op = 1:length(iSubjOut)
    %     i = iSubjOut(op);
    %     xSubj = subjectData(i).x;
    %     ySubj = subjectData(i).y;
    %     lenX = length(xSubj);
    %     h = figure;
    %     hold on
    %     plot(xSubj,ySubj)
    %     plot(xTruth,yTruth,'k','linewidth',2)
    %     title([num2str(i) ',  ' num2str(lenX)])
    % %     waitfor(h)
    % end
     
    strupi.subjectDataCleaned = subjectDataCleaned;
    strupi.toAllFigNames = toAllFigNames;
    strupi.groundTruth = groundTruth;
    strupi.roundGroundTruth = roundGroundTruth;
    strupi.nSubjOriginal = nSubj;
    strupi.iSubjOK = iSubjOK;
    strupi.iSubjAdults = iSubjAdults;
    strupi.iSubjShort = iSubjShort;
    strupi.iSubjSmall = iSubjSmall;
    strupi.iSubjJumps = iSubjJumps;
%     strupi.iSubjRepeat = iSubjRepeat;
    
    eval([toStructSaveName,'= strupi;'])
    eval(['motorwoc_cleaned_data.' toStructSaveName '=' toStructSaveName ';']);

end

save('motorwoc_cleaned_data.mat','motorwoc_cleaned_data')

