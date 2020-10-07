function createKineticsGraphs(fileStats,plotOptions,postAnalysisPerformDtw,postAnalysisPrintDir)

    %pick which functions to use based on whether we will use DTW or not
    if postAnalysisPerformDtw
        computeVisibleEndPtsFunc=@computeVisibleEndPtsDtw;
    else
        computeVisibleEndPtsFunc=@computeVisibleEndPtsReg;
    end
    
    %compute visible endpoints
    visibleAxialForceEndPts=computeVisibleEndPtsFunc(fileStats.kinetics.warpPaths.axialForce,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleBendingMomentEndPts=computeVisibleEndPtsFunc(fileStats.kinetics.warpPaths.bendingMoment,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleAxialMomentEndPts=computeVisibleEndPtsFunc(fileStats.kinetics.warpPaths.axialMoment,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleForcesEndPts=computeVisibleEndPtsFunc(fileStats.kinetics.warpPaths.forces,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleMomentsEndPts=computeVisibleEndPtsFunc(fileStats.kinetics.warpPaths.moments,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);

    if plotOptions.createGraphsBool && plotOptions.printGraphsBool
        createSimpleKineticsGraphs(fileStats,visibleAxialForceEndPts,visibleBendingMomentEndPts,visibleAxialMomentEndPts,visibleForcesEndPts,visibleMomentsEndPts,postAnalysisPrintDir);
    elseif plotOptions.createGraphsBool && ~plotOptions.printGraphsBool
        createSimpleKineticsGraphs(fileStats,visibleAxialForceEndPts,visibleBendingMomentEndPts,visibleAxialMomentEndPts,visibleForcesEndPts,visibleMomentsEndPts,'');
    elseif ~plotOptions.createGraphsBool && plotOptions.printGraphsBool
        set(0, 'DefaultFigureVisible', 'off')
        createSimpleKineticsGraphs(fileStats,visibleAxialForceEndPts,visibleBendingMomentEndPts,visibleAxialMomentEndPts,visibleForcesEndPts,visibleMomentsEndPts,postAnalysisPrintDir);
        set(0, 'DefaultFigureVisible', 'on')
    else
    end
end