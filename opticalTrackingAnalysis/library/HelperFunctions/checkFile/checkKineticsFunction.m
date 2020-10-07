function fileStats=checkKineticsFunction(plotStyle,samplingPeriods,robotI,dataFolder,file,monitorNum,postAnalysisOffsetEndpts,filterFunctions,useDtw)
    if useDtw
        warpPathFun=@computeKineticsWarpPathsDtw;
        computeVisibleEndPtsFnc=@computeVisibleEndPtsDtw;
        if postAnalysisOffsetEndpts
            endPointFunc=@computeKineticsEndPointsDtwOffset;
        else
            endPointFunc=@computeKineticsEndPointsDtw;
        end
    else
        warpPathFun=@computeKineticsWarpPathsReg;
        computeVisibleEndPtsFnc=@computeVisibleEndPtsReg;
        if postAnalysisOffsetEndpts
            endPointFunc=@computeKineticsEndPointsRegOffset;
        else
            endPointFunc=@computeKineticsEndPointsReg;
        end
    end
    
    fileStats=readAndProcessCapture(samplingPeriods,robotI,dataFolder,file,filterFunctions);
    fileStats=determineCaptureTimingXCorr(fileStats,samplingPeriods.mocapSamplingPeriod);
    fileStats=warpPathFun(fileStats);
    fileStats=endPointFunc(fileStats);
    fileStats=computeKineticsStatistics(fileStats);
    
    %find the start and stop of what to display on the graph - based on
    %ndiStart, ndiStop and and offset
    visibleAxialForceEndPts=computeVisibleEndPtsFnc(fileStats.kinetics.warpPaths.axialForce,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleBendingMomentEndPts=computeVisibleEndPtsFnc(fileStats.kinetics.warpPaths.bendingMoment,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleAxialMomentEndPts=computeVisibleEndPtsFnc(fileStats.kinetics.warpPaths.axialMoment,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleForcesEndPts=computeVisibleEndPtsFnc(fileStats.kinetics.warpPaths.forces,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleMomentsEndPts=computeVisibleEndPtsFnc(fileStats.kinetics.warpPaths.moments,...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    
    %screen info
    set(0,'units','pixels');
    screen_resolution = get(0,'MonitorPositions');
    screen_width=screen_resolution(monitorNum,3);
    screen_height=screen_resolution(monitorNum,4);
    graph_width = (screen_width+120)/3;
    graph_height = (screen_height-60)/2;
    xOffset=screen_resolution(monitorNum,1);
    yOffset=screen_resolution(monitorNum,2);
    
    % Position 4  - Force Vector (Fig. 4)
    [~,subPlots]=kineticsGraphVector(4,plotStyle,'Forces','Force (N)',fileStats.kinetics.warpPaths.forces,fileStats.kinetics.mocap.forces.vector,fileStats.kinetics.ndi.forces.vector,visibleForcesEndPts);
    for n=1:3
        annotateKinetics(fileStats.kinetics.mocap.forces.vector(:,n),fileStats.kinetics.ndi.forces.vector(:,n),fileStats.kinetics.diff.forces(n),fileStats.kinetics.warpPaths.forces,plotStyle,fileStats.kinetics.endPts.forces,visibleForcesEndPts,subPlots(n));
    end
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    % Position 5 - Moments Vector (Fig. 5)
    [~,subPlots]=kineticsGraphVector(5,plotStyle,'Moments','Moment (Nm)',fileStats.kinetics.warpPaths.moments,fileStats.kinetics.mocap.moments.vector,fileStats.kinetics.ndi.moments.vector,visibleMomentsEndPts);
    for n=1:3
        annotateKinetics(fileStats.kinetics.mocap.moments.vector(:,n),fileStats.kinetics.ndi.moments.vector(:,n),fileStats.kinetics.diff.moments(n),fileStats.kinetics.warpPaths.moments,plotStyle,fileStats.kinetics.endPts.moments,visibleMomentsEndPts,subPlots(n));
    end
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])

    % Position 6 - Scalar Force (Fig. 7) and Moment (Fig. 6) on top of each other
    kineticsGraph(6,plotStyle,'Moment','Moment (Nm)',fileStats.kinetics.warpPaths.moments,fileStats.kinetics.mocap.moments.scalar,fileStats.kinetics.ndi.moments.scalar,visibleMomentsEndPts);
    annotateKinetics(fileStats.kinetics.mocap.moments.scalar,fileStats.kinetics.ndi.moments.scalar,fileStats.kinetics.diff.moments(4),fileStats.kinetics.warpPaths.moments,plotStyle,fileStats.kinetics.endPts.moments,visibleMomentsEndPts);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    kineticsGraph(7,plotStyle,'Force','Force (N)',fileStats.kinetics.warpPaths.forces,fileStats.kinetics.mocap.forces.scalar,fileStats.kinetics.ndi.forces.scalar,visibleForcesEndPts);
    annotateKinetics(fileStats.kinetics.mocap.forces.scalar,fileStats.kinetics.ndi.forces.scalar,fileStats.kinetics.diff.forces(4),fileStats.kinetics.warpPaths.forces,plotStyle,fileStats.kinetics.endPts.forces,visibleForcesEndPts);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    % Position 1 - Axial Force (Fig. 1)
    kineticsGraph(1,plotStyle,'Axial Force','Force (N)',fileStats.kinetics.warpPaths.axialForce,fileStats.kinetics.mocap.axialForce,fileStats.kinetics.ndi.axialForce,visibleAxialForceEndPts);
    if fileStats.activity==Activities.JO_free
        annotateKinetics_JO(fileStats.kinetics.mocap.axialForce,fileStats.kinetics.ndi.axialForce,fileStats.kinetics.diff.axialForce,fileStats.kinetics.warpPaths.axialForce,plotStyle,fileStats.kinetics.endPts.axialForce,visibleAxialForceEndPts);
    else
        annotateKinetics(fileStats.kinetics.mocap.axialForce,fileStats.kinetics.ndi.axialForce,fileStats.kinetics.diff.axialForce,fileStats.kinetics.warpPaths.axialForce,plotStyle,fileStats.kinetics.endPts.axialForce,visibleAxialForceEndPts);
    end
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    % Position 2 - Bending Moment (Fig. 2)
    kineticsGraph(2,plotStyle,'Bending Moment','Moment (Nm)',fileStats.kinetics.warpPaths.bendingMoment,fileStats.kinetics.mocap.bendingMoment,fileStats.kinetics.ndi.bendingMoment,visibleBendingMomentEndPts);
    annotateKinetics(fileStats.kinetics.mocap.bendingMoment,fileStats.kinetics.ndi.bendingMoment,fileStats.kinetics.diff.bendingMoment,fileStats.kinetics.warpPaths.bendingMoment,plotStyle,fileStats.kinetics.endPts.bendingMoment,visibleBendingMomentEndPts);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])
    
    % Position 2 - Bending Moment Thorax (Fig. 8)
    kineticsGraph(8,plotStyle,'Bending Moment Thorax','Moment (Nm)',fileStats.kinetics.warpPaths.thorax.bendingMoment,fileStats.kinetics.mocap.thorax.bendingMoment,fileStats.kinetics.ndi.thorax.bendingMoment,visibleBendingMomentEndPts);
    annotateKinetics(fileStats.kinetics.mocap.thorax.bendingMoment,fileStats.kinetics.ndi.thorax.bendingMoment,fileStats.kinetics.diff.thorax.bendingMoment,fileStats.kinetics.warpPaths.thorax.bendingMoment,plotStyle,fileStats.kinetics.endPts.bendingMoment,visibleBendingMomentEndPts);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])
    
    % Position 3 - Axial Moment (Fig. 3)
    kineticsGraph(3,plotStyle,'Axial Moment','Moment (Nm)',fileStats.kinetics.warpPaths.axialMoment,fileStats.kinetics.mocap.axialMoment,fileStats.kinetics.ndi.axialMoment,visibleAxialMomentEndPts);
    if fileStats.activity==Activities.IR90
        annotateKinetics_IR(fileStats.kinetics.mocap.axialMoment,fileStats.kinetics.ndi.axialMoment,fileStats.kinetics.diff.axialMoment,fileStats.kinetics.warpPaths.axialMoment,plotStyle,fileStats.kinetics.endPts.axialMoment,visibleAxialMomentEndPts);
    else
        annotateKinetics(fileStats.kinetics.mocap.axialMoment,fileStats.kinetics.ndi.axialMoment,fileStats.kinetics.diff.axialMoment,fileStats.kinetics.warpPaths.axialMoment,plotStyle,fileStats.kinetics.endPts.axialMoment,visibleAxialMomentEndPts);
    end
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
end
