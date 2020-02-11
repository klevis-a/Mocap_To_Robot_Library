function createGraphs(fileStats,poseCsRbs,velCsRbs,accCsRbs,plotOptions,postAnalysisPerformDtw,postAnalysisPrintDir)

    %pick which functions to use based on whether we will use DTW or not
    if postAnalysisPerformDtw
        computeVisibleEndPtsFunc=@computeVisibleEndPtsDtw;
    else
        computeVisibleEndPtsFunc=@computeVisibleEndPtsReg;
    end
    
    %compute visible endpoints
    visiblePosEndPts=computeVisibleEndPtsFunc(fileStats.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB),...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleVelEndPts=computeVisibleEndPtsFunc(fileStats.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB),...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleAccEndPts=computeVisibleEndPtsFunc(fileStats.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB),...
        fileStats.ndiStart,fileStats.ndiStop,2,15);

    if plotOptions.createGraphsBool && plotOptions.printGraphsBool
        createSimpleGraphs(fileStats,poseCsRbs,velCsRbs,accCsRbs,visiblePosEndPts,visibleVelEndPts,visibleAccEndPts,...
            postAnalysisPrintDir,plotOptions.postAnalysisPlotDiff,plotOptions.postAnalysisPlotPercentage,postAnalysisPerformDtw);
    elseif plotOptions.createGraphsBool && ~plotOptions.printGraphsBool
        createSimpleGraphs(fileStats,poseCsRbs,velCsRbs,accCsRbs,visiblePosEndPts,visibleVelEndPts,visibleAccEndPts,...
            '',plotOptions.postAnalysisPlotDiff,plotOptions.postAnalysisPlotPercentage,postAnalysisPerformDtw);
    elseif ~plotOptions.createGraphsBool && plotOptions.printGraphsBool
        set(0, 'DefaultFigureVisible', 'off')
        createSimpleGraphs(fileStats,poseCsRbs,velCsRbs,accCsRbs,visiblePosEndPts,visibleVelEndPts,visibleAccEndPts,...
            postAnalysisPrintDir,plotOptions.postAnalysisPlotDiff,plotOptions.postAnalysisPlotPercentage,postAnalysisPerformDtw);
        set(0, 'DefaultFigureVisible', 'on')
    else
    end
end