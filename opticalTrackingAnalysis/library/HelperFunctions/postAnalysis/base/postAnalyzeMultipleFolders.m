function folderStats=postAnalyzeMultipleFolders(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisMainResultsFolder,poseCsRbs,velCsRbs,accCsRbs,...
    postAnalysisRepeatsAvail,postAnalysisPerformDtw,postAnalysisAngAccDtw,computeStats,plotOptions,postAnalysisPrintDir,postAnalysisOffsetEndpts,filterFunction)

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
        fileStatsCellArray{n}=postAnalyzeFile(samplingPeriods,robotI,postAnalysisDataFolder,filesToProcess{n},poseCsRbs,velCsRbs,accCsRbs,...
            postAnalysisRepeatsAvail,postAnalysisPerformDtw,postAnalysisAngAccDtw,computeStats,postAnalysisOffsetEndpts,filterFunction);
        createGraphs(fileStatsCellArray{n},poseCsRbs,velCsRbs,accCsRbs,plotOptions,postAnalysisPerformDtw,postAnalysisPrintDir);
    end
    
    %compile results
    folderStats=convertFileStatsArrayToFolderStats(fileStatsCellArray,poseCsRbs,velCsRbs,accCsRbs);
end