function fileStats=postAnalyzeFile(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,poseCsRbs,velCsRbs,accCsRbs,...
    postAnalysisRepeatsAvail,postAnalysisPerformDtw,postAnalysisAngAccDtw,computeStats,postAnalysisOffsetEndpts,filterFunctions)

    %pick which functions to use based on whether we will use DTW or not
    if postAnalysisPerformDtw
        if postAnalysisOffsetEndpts
            computeEndPointsFunc=@computeEndPointsDtwOffset;
        else
            computeEndPointsFunc=@computeEndPointsDtw;
        end
        computeWarpPathsFunc=@computeWarpPathsDtw;
    else
        if postAnalysisOffsetEndpts
            computeEndPointsFunc=@computeEndPointsRegOffset;
        else
            computeEndPointsFunc=@computeEndPointsReg;
        end
        computeWarpPathsFunc=@computeWarpPathsReg;
    end
    
    %read and process the capture
    if postAnalysisRepeatsAvail
        [~,fileStats]=readAndProcessRepeatCaptures(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,postAnalysisRepeatsAvail,filterFunctions);
    else
        fileStats=readAndProcessCapture(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,filterFunctions);
    end
    
    %determine capture timing and endpoints
    fileStats=determineCaptureTimingXCorr(fileStats,samplingPeriods.mocapSamplingPeriod);
    fileStats=computeWarpPathsFunc(fileStats,poseCsRbs,velCsRbs,accCsRbs,postAnalysisAngAccDtw);
    fileStats=computeEndPointsFunc(fileStats,poseCsRbs,velCsRbs,accCsRbs);
    
    if computeStats
        fileStats=computeCaptureStatistics(fileStats,poseCsRbs,velCsRbs,accCsRbs);
    end
end
