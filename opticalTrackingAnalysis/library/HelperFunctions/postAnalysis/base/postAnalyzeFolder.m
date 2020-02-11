function folderStats=postAnalyzeFolder(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFolder,poseCsRbs,velCsRbs,accCsRbs,...
    postAnalysisRepeatsAvail,postAnalysisPerformDtw,postAnalysisAngAccDtw,computeStats,plotOptions,postAnalysisPrintDir,postAnalysisOffsetEndpts,filterFunctions)
    
    fileBrowser=FileBrowser(postAnalysisResultsFolder, '\*_sum.txt');
    fileStatsCellArray=cell(fileBrowser.numFiles,1);
    
    parfor (j=1:fileBrowser.numFiles,4)
        fileStatsCellArray{j}=postAnalyzeFile(samplingPeriods,robotI,postAnalysisDataFolder,fileBrowser.fileFullPath(j),poseCsRbs,velCsRbs,accCsRbs,...
            postAnalysisRepeatsAvail,postAnalysisPerformDtw,postAnalysisAngAccDtw,computeStats,postAnalysisOffsetEndpts,filterFunctions);
        createGraphs(fileStatsCellArray{j},poseCsRbs,velCsRbs,accCsRbs,plotOptions,postAnalysisPerformDtw,postAnalysisPrintDir);
    end
    
    folderStats=convertFileStatsArrayToFolderStats(fileStatsCellArray,poseCsRbs,velCsRbs,accCsRbs);
end
