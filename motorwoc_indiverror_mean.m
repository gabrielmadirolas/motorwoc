% this script computes the average error for 
% every segment combination of each subject


clearvars
% close all

if isempty(gcp('nocreate'))
    tic 
    parpool
    toc
end


load motorwoc_disttobins
load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);

% average distance to rounded ground truth from each trajectory made 
% using a number of segments from one single subject a time
distToTruthEachTraject = cell(1,nTasks);
% average individual error across all the trajectories made using a
% number of segments from one single subject a time
distToTruthIndivs = cell(1,nTasks);
% and the confidence intervales for the above quantities
confIntTruthIndivs = cell(1,nTasks);
% number of randomizations to compute the confidence intervals
timBoot = 100000;


for t = 1:nTasks
    disp(['task ' num2str(t)])
    tic
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nBins = length(td.roundGroundTruth);
    nSubj = length(td.iSubjOK); % total number of subjects
    
    trajectsThisTask = procTrajects{t};
    nSegments = size(trajectsThisTask,2);

    % number of segments of the same individual to test wisdom of one signle
    % individual drawing several times
    indivSizes = 1:nSegments; % max must be nSegments
    % indivSizes = [1 8]; % max must be nSegments
    nIndivSizes = length(indivSizes);
       
    % average distance to rounded ground truth from each trajectory made 
    % using a number of segments from one single subject a time
    dTTEachTraject = cell(1,nIndivSizes);
    % average individual error across all the trajectories made using a
    % number of segments from one single subject a time
    dTTIndivs = nan(1,nIndivSizes);
    % and the confidence intervale for the above quantities
    cITIndivs = nan(2,nIndivSizes);

    for s = 1:nIndivSizes
    
        nSelSegm = indivSizes(s);
        nSegmCombin = nchoosek(nSegments,nSelSegm);
        allSegmCombin = nchoosek(1:nSegments,nSelSegm);
        
        distToTruthThisSize = nan(nSubj,nSegmCombin);
        
        for i = 1:nSubj
            for c = 1:nSegmCombin
                
                % which segments take from the current subject
                iSelSegmIndiv = allSegmCombin(c,:);
                
                xSegm = nan(nBins,nSelSegm);
                ySegm = nan(nBins,nSelSegm);

                for k = 1:nSelSegm
                    iSegm = iSelSegmIndiv(k); % selected segment
                    
                    xSegm(:,k) = trajectsThisTask{i,iSegm}(:,1);
                    ySegm(:,k) = trajectsThisTask{i,iSegm}(:,2);
                end

                roundTraceCurrent = [mean(xSegm,2,'omitnan'), ...
                               mean(ySegm,2,'omitnan')];
                           
                % distance to each bin of ground truth from the trajectories made 
                % using a number of segments from one single subject
                distToBinsCurrent = ...
                    sqrt((gd.pix2mm * td.roundGroundTruth(:,1) - roundTraceCurrent(:,1)).^2 + ...
                         (gd.pix2mm * td.roundGroundTruth(:,2) - roundTraceCurrent(:,2)).^2);
                distToTruthThisSize(i,c) = mean(distToBinsCurrent,'omitnan');

            end
        end
        
        dTTEachTraject{s} = distToTruthThisSize;
        dTTIndivs(s) = mean(distToTruthThisSize(:),'omitnan');
        
        distRandomExtract = nan(timBoot,1);
        
        parfor tb = 1:timBoot
            randSubj = datasample(distToTruthThisSize,nSubj,1);
            distRandomExtract(tb) = mean(randSubj(:),'omitnan');
        end
        
        cITIndivs(:,s) = [prctile(distRandomExtract,2.5);...
                                   prctile(distRandomExtract,97.5)];

    end
    
    % average distance to rounded ground truth from each trajectory made 
    % using a number of segments from one single subject a time
    distToTruthEachTraject{t} = dTTEachTraject;
    % average individual error across all the trajectories made using a
    % number of segments from one single subject a time
    distToTruthIndivs{t} = dTTIndivs;
    % and the confidence intervale for the above quantities
    confIntTruthIndivs{t} = cITIndivs;
 
    toc  

end


save('motorwoc_indiverror_mean.mat',...
    'timBoot','distToTruthEachTraject','distToTruthIndivs','confIntTruthIndivs')


delete(gcp('nocreate'))




