function fileStats=postAnalyzeKinetics(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,...
    postAnalysisRepeatsAvail,useDtw,computeStats,postAnalysisOffsetEndpts,filterFunctions)

    %pick which functions to use based on whether we will use DTW or not
    if useDtw
        warpPathFun=@computeKineticsWarpPathsDtw;
        if postAnalysisOffsetEndpts
            endPointFunc=@computeKineticsEndPointsDtwOffset;
        else
            endPointFunc=@computeKineticsEndPointsDtw;
        end
    else
        warpPathFun=@computeKineticsWarpPathsReg;
        if postAnalysisOffsetEndpts
            endPointFunc=@computeKineticsEndPointsRegOffset;
        else
            endPointFunc=@computeKineticsEndPointsReg;
        end
    end
    
    %read and process the capture
    if postAnalysisRepeatsAvail
        [~,fileStats]=readAndProcessRepeatCaptures(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,postAnalysisRepeatsAvail,filterFunctions);
    else
        fileStats=readAndProcessCapture(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,filterFunctions);
    end
    
    %determine capture timing and endpoints
    fileStats=determineCaptureTimingXCorr(fileStats);
    fileStats=warpPathFun(fileStats);
    fileStats=endPointFunc(fileStats);
    
    if computeStats
        fileStats=computeKineticsStatistics(fileStats);
    end
end
