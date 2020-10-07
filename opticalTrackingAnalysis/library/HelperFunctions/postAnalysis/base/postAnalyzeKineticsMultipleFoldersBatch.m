function folderStats=postAnalyzeKineticsMultipleFoldersBatch(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisMainResultsFolder,...
    postAnalysisRepeatsAvail,postAnalysisPerformDtw,computeStats,plotOptions,postAnalysisPrintDir,postAnalysisOffsetEndpts,filterFunctions)

    assert(length(plotOptions)==length(postAnalysisPrintDir));

    %read the directories (each directory corresponds to a day of data collection)
    dirBrowser=DirectoryBrowserNoRepeats(postAnalysisMainResultsFolder);
    
    %since we don't know how many files to process create a counter
    counter=1;
    
    %first just create a listing of the files that we need to process
    for i=1:dirBrowser.numFolders
        fileBrowser=FileBrowser(dirBrowser.folderFullPath(i), '\*_sum.txt');
        for j=1:fileBrowser.numFiles
            filesToProcess{counter}=fileBrowser.fileFullPath(j);
            counter=counter+1;
        end
    end
    
    numFilesToProcess=length(filesToProcess);
    fileStatsCellArray=cell(numFilesToProcess,1);
    %Now go through a parallel for loop and process all of the files
    parfor (n=1:numFilesToProcess,4)
        fileStatsCellArray{n}=postAnalyzeKinetics(samplingPeriods,robotI,postAnalysisDataFolder,filesToProcess{n},...
            postAnalysisRepeatsAvail,postAnalysisPerformDtw,computeStats,postAnalysisOffsetEndpts,filterFunctions);
        for i=1:length(postAnalysisPrintDir)
            createKineticsGraphs(fileStatsCellArray{n},plotOptions{i},postAnalysisPerformDtw,postAnalysisPrintDir{i});
        end
    end
    
    %compile results
    folderStats=convertFileStatsArrayToFolderStatsKinetics(fileStatsCellArray);
end