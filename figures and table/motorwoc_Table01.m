
close all
clearvars

load motorwoc_cleaned_data
gd = motorwoc_cleaned_data.general_data;
nTasks = length(gd.taskNames);

nColumns = 6;
tableResults = cell(nTasks+1,nColumns+1);

tableResults(:,1) = {'Template','Ellipse','Flat Ellipse','Flower 3','Flower 4','Lemniscate'};
tableResults(1,2:end) = {'Original number',...
    'Older than 18','Too short','Too narrow','Big jumps','Final number'};

for t = 1:nTasks
    disp(['task ' num2str(t)])
    tic
    
    taskName = gd.taskNames{t};
    eval(['td = motorwoc_cleaned_data.' taskName ';'])
    
    nSubjOriginal = td.nSubjOriginal;
    iSubjAdults = td.iSubjAdults;
    iSubjShort = td.iSubjShort;
    iSubjSmall = td.iSubjSmall;
    iSubjJumps = td.iSubjJumps;
    iSubjOK = td.iSubjOK;
    
    tableResults{t+1,2} = nSubjOriginal;  
    tableResults{t+1,3} = length(iSubjAdults); 
    tableResults{t+1,4} = length(iSubjShort); 
    tableResults{t+1,5} = length(iSubjSmall); 
    tableResults{t+1,6} = length(iSubjJumps); 
    tableResults{t+1,7} = length(iSubjOK); 
    
end


writecell(tableResults,'motorwoc_Table01.xlsx')

