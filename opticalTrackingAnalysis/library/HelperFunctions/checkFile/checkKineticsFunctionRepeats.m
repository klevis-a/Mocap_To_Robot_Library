function [fileStatsAvg,fileStatsInit]=checkKineticsFunctionRepeats(plotStyle,samplingPeriods,robotI,dataFolder,file,monitorNum,postAnalysisOffsetEndpts,filterFunctions,useDtw,postAnalysisRepeatsAvail)
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
    
    
    [fileStatsInit,fileStatsAvg]=readAndProcessRepeatCaptures(samplingPeriods,robotI,dataFolder,file,postAnalysisRepeatsAvail,filterFunctions);

    fileStatsInit=determineCaptureTimingXCorr(fileStatsInit);
    fileStatsInit=warpPathFun(fileStatsInit);
    fileStatsInit=endPointFunc(fileStatsInit);
    fileStatsInit=computeKineticsStatistics(fileStatsInit);
    
    fileStatsAvg=determineCaptureTimingXCorr(fileStatsAvg);
    fileStatsAvg=warpPathFun(fileStatsAvg);
    fileStatsAvg=endPointFunc(fileStatsAvg);
    fileStatsAvg=computeKineticsStatistics(fileStatsAvg);
    
    %find the start and stop of what to display on the graph - based on
    %ndiStart, ndiStop and and offset
    visibleAxialForceEndPtsInit=computeVisibleEndPtsFnc(fileStatsInit.kinetics.warpPaths.axialForce,...
        fileStatsInit.ndiStart,fileStatsInit.ndiStop,2,15);
    visibleBendingMomentEndPtsInit=computeVisibleEndPtsFnc(fileStatsInit.kinetics.warpPaths.bendingMoment,...
        fileStatsInit.ndiStart,fileStatsInit.ndiStop,2,15);
    visibleAxialMomentEndPtsInit=computeVisibleEndPtsFnc(fileStatsInit.kinetics.warpPaths.axialMoment,...
        fileStatsInit.ndiStart,fileStatsInit.ndiStop,2,15);
    visibleForcesEndPtsInit=computeVisibleEndPtsFnc(fileStatsInit.kinetics.warpPaths.forces,...
        fileStatsInit.ndiStart,fileStatsInit.ndiStop,2,15);
    visibleMomentsEndPtsInit=computeVisibleEndPtsFnc(fileStatsInit.kinetics.warpPaths.moments,...
        fileStatsInit.ndiStart,fileStatsInit.ndiStop,2,15);
    
    visibleAxialForceEndPtsAvg=computeVisibleEndPtsFnc(fileStatsAvg.kinetics.warpPaths.axialForce,...
        fileStatsAvg.ndiStart,fileStatsAvg.ndiStop,2,15);
    visibleBendingMomentEndPtsAvg=computeVisibleEndPtsFnc(fileStatsAvg.kinetics.warpPaths.bendingMoment,...
        fileStatsAvg.ndiStart,fileStatsAvg.ndiStop,2,15);
    visibleAxialMomentEndPtsAvg=computeVisibleEndPtsFnc(fileStatsAvg.kinetics.warpPaths.axialMoment,...
        fileStatsAvg.ndiStart,fileStatsAvg.ndiStop,2,15);
    visibleForcesEndPtsAvg=computeVisibleEndPtsFnc(fileStatsAvg.kinetics.warpPaths.forces,...
        fileStatsAvg.ndiStart,fileStatsAvg.ndiStop,2,15);
    visibleMomentsEndPtsAvg=computeVisibleEndPtsFnc(fileStatsAvg.kinetics.warpPaths.moments,...
        fileStatsAvg.ndiStart,fileStatsAvg.ndiStop,2,15);
    
    %screen info
    set(0,'units','pixels');
    screen_resolution = get(0,'MonitorPositions');
    screen_width=screen_resolution(monitorNum,3);
    screen_height=screen_resolution(monitorNum,4);
    graph_width = (screen_width+120)/3;
    graph_height = (screen_height-60)/2;
    xOffset=screen_resolution(monitorNum,1);
    yOffset=screen_resolution(monitorNum,2);
    
    % Position 4 - Axial Force (Average of Captures) Fig. 4
    kineticsGraph(4,plotStyle,'Axial Force','Force (N)',fileStatsAvg.kinetics.warpPaths.axialForce,fileStatsAvg.kinetics.mocap.axialForce,fileStatsAvg.kinetics.ndi.axialForce,visibleAxialForceEndPtsAvg);
    annotateKinetics(fileStatsAvg.kinetics.mocap.axialForce,fileStatsAvg.kinetics.ndi.axialForce,fileStatsAvg.kinetics.diff.axialForce,fileStatsAvg.kinetics.warpPaths.axialForce,plotStyle,fileStatsAvg.kinetics.endPts.axialForce,visibleAxialForceEndPtsAvg);
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    % Position 5 - Bending Moment (Average of Captures) Fig. 5
    kineticsGraph(5,plotStyle,'Bending Moment','Moment (Nm)',fileStatsAvg.kinetics.warpPaths.bendingMoment,fileStatsAvg.kinetics.mocap.bendingMoment,fileStatsAvg.kinetics.ndi.bendingMoment,visibleBendingMomentEndPtsAvg);
    annotateKinetics(fileStatsAvg.kinetics.mocap.bendingMoment,fileStatsAvg.kinetics.ndi.bendingMoment,fileStatsAvg.kinetics.diff.bendingMoment,fileStatsAvg.kinetics.warpPaths.bendingMoment,plotStyle,fileStatsAvg.kinetics.endPts.bendingMoment,visibleBendingMomentEndPtsAvg);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    % Position 6 - Axial Moment (Average of Captures) Fig. 6
    kineticsGraph(6,plotStyle,'Axial Moment','Moment (Nm)',fileStatsAvg.kinetics.warpPaths.axialMoment,fileStatsAvg.kinetics.mocap.axialMoment,fileStatsAvg.kinetics.ndi.axialMoment,visibleAxialMomentEndPtsAvg);
    annotateKinetics(fileStatsAvg.kinetics.mocap.axialMoment,fileStatsAvg.kinetics.ndi.axialMoment,fileStatsAvg.kinetics.diff.axialMoment,fileStatsAvg.kinetics.warpPaths.axialMoment,plotStyle,fileStatsAvg.kinetics.endPts.axialMoment,visibleAxialMomentEndPtsAvg);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    % Position 1 - Axial Force (Init Capture) Fig. 1
    kineticsGraph(1,plotStyle,'Axial Force','Force (N)',fileStatsInit.kinetics.warpPaths.axialForce,fileStatsInit.kinetics.mocap.axialForce,fileStatsInit.kinetics.ndi.axialForce,visibleAxialForceEndPtsInit);
    annotateKinetics(fileStatsInit.kinetics.mocap.axialForce,fileStatsInit.kinetics.ndi.axialForce,fileStatsInit.kinetics.diff.axialForce,fileStatsInit.kinetics.warpPaths.axialForce,plotStyle,fileStatsInit.kinetics.endPts.axialForce,visibleAxialForceEndPtsInit);
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    % Position 2 - Bending Moment (Init Capture) Fig. 2
    kineticsGraph(2,plotStyle,'Bending Moment','Moment (Nm)',fileStatsInit.kinetics.warpPaths.bendingMoment,fileStatsInit.kinetics.mocap.bendingMoment,fileStatsInit.kinetics.ndi.bendingMoment,visibleBendingMomentEndPtsInit);
    annotateKinetics(fileStatsInit.kinetics.mocap.bendingMoment,fileStatsInit.kinetics.ndi.bendingMoment,fileStatsInit.kinetics.diff.bendingMoment,fileStatsInit.kinetics.warpPaths.bendingMoment,plotStyle,fileStatsInit.kinetics.endPts.bendingMoment,visibleBendingMomentEndPtsInit);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])
    
    % Position 3 - Axial Moment (Init Capture) Fig. 3
    kineticsGraph(3,plotStyle,'Axial Moment','Moment (Nm)',fileStatsInit.kinetics.warpPaths.axialMoment,fileStatsInit.kinetics.mocap.axialMoment,fileStatsInit.kinetics.ndi.axialMoment,visibleAxialMomentEndPtsInit);
    annotateKinetics(fileStatsInit.kinetics.mocap.axialMoment,fileStatsInit.kinetics.ndi.axialMoment,fileStatsInit.kinetics.diff.axialMoment,fileStatsInit.kinetics.warpPaths.axialMoment,plotStyle,fileStatsInit.kinetics.endPts.axialMoment,visibleAxialMomentEndPtsInit);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
    
    % Position 4 - Force Vector (Average of Captures) Fig. 11
    [~,subPlots]=kineticsGraphVector(11,plotStyle,'Forces','Force (N)',fileStatsAvg.kinetics.warpPaths.forces,fileStatsAvg.kinetics.mocap.forces.vector,fileStatsAvg.kinetics.ndi.forces.vector,visibleForcesEndPtsAvg);
    for n=1:3
        annotateKinetics(fileStatsAvg.kinetics.mocap.forces.vector(:,n),fileStatsAvg.kinetics.ndi.forces.vector(:,n),fileStatsAvg.kinetics.diff.forces(n),fileStatsAvg.kinetics.warpPaths.forces,plotStyle,fileStatsAvg.kinetics.endPts.forces,visibleForcesEndPtsAvg,subPlots(n));
    end
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    % Position 5 - Moment Vector (Average of Captures) Fig. 12
    [~,subPlots]=kineticsGraphVector(12,plotStyle,'Moments','Moment (Nm)',fileStatsAvg.kinetics.warpPaths.moments,fileStatsAvg.kinetics.mocap.moments.vector,fileStatsAvg.kinetics.ndi.moments.vector,visibleMomentsEndPtsAvg);
    for n=1:3
        annotateKinetics(fileStatsAvg.kinetics.mocap.moments.vector(:,n),fileStatsAvg.kinetics.ndi.moments.vector(:,n),fileStatsAvg.kinetics.diff.moments(n),fileStatsAvg.kinetics.warpPaths.moments,plotStyle,fileStatsAvg.kinetics.endPts.moments,visibleMomentsEndPtsAvg,subPlots(n));
    end
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    % Position 6 - Force (Fig. 13) and Moment (Fig. 14) Scalar on top of each other (Average Capture)
    kineticsGraph(14,plotStyle,'Moment','Moment (Nm)',fileStatsAvg.kinetics.warpPaths.moments,fileStatsAvg.kinetics.mocap.moments.scalar,fileStatsAvg.kinetics.ndi.moments.scalar,visibleMomentsEndPtsAvg);
    annotateKinetics(fileStatsAvg.kinetics.mocap.moments.scalar,fileStatsAvg.kinetics.ndi.moments.scalar,fileStatsAvg.kinetics.diff.moments(4),fileStatsAvg.kinetics.warpPaths.moments,plotStyle,fileStatsAvg.kinetics.endPts.moments,visibleMomentsEndPtsAvg);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    kineticsGraph(13,plotStyle,'Force','Force (N)',fileStatsAvg.kinetics.warpPaths.forces,fileStatsAvg.kinetics.mocap.forces.scalar,fileStatsAvg.kinetics.ndi.forces.scalar,visibleForcesEndPtsAvg);
    annotateKinetics(fileStatsAvg.kinetics.mocap.forces.scalar,fileStatsAvg.kinetics.ndi.forces.scalar,fileStatsAvg.kinetics.diff.forces(4),fileStatsAvg.kinetics.warpPaths.forces,plotStyle,fileStatsAvg.kinetics.endPts.forces,visibleForcesEndPtsAvg);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    % Position 1 - Force Vector (Init Capture) Fig. 7
    [~,subPlots]=kineticsGraphVector(7,plotStyle,'Forces','Force (N)',fileStatsInit.kinetics.warpPaths.forces,fileStatsInit.kinetics.mocap.forces.vector,fileStatsInit.kinetics.ndi.forces.vector,visibleForcesEndPtsInit);
    for n=1:3
        annotateKinetics(fileStatsInit.kinetics.mocap.forces.vector(:,n),fileStatsInit.kinetics.ndi.forces.vector(:,n),fileStatsInit.kinetics.diff.forces(n),fileStatsInit.kinetics.warpPaths.forces,plotStyle,fileStatsInit.kinetics.endPts.forces,visibleForcesEndPtsInit,subPlots(n));
    end
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    % Position 2 - Moment Vector (Init Capture) Fig. 8
    [~,subPlots]=kineticsGraphVector(8,plotStyle,'Moments','Moment (Nm)',fileStatsInit.kinetics.warpPaths.moments,fileStatsInit.kinetics.mocap.moments.vector,fileStatsInit.kinetics.ndi.moments.vector,visibleMomentsEndPtsInit);
    for n=1:3
        annotateKinetics(fileStatsInit.kinetics.mocap.moments.vector(:,n),fileStatsInit.kinetics.ndi.moments.vector(:,n),fileStatsInit.kinetics.diff.moments(n),fileStatsInit.kinetics.warpPaths.moments,plotStyle,fileStatsInit.kinetics.endPts.moments,visibleMomentsEndPtsInit,subPlots(n));
    end
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])
    
    % Position 3 - Force (Fig. 10) and Moment (Fig. 9) Scalar on top of each other (Init Capture)
    kineticsGraph(10,plotStyle,'Moment','Moment (Nm)',fileStatsInit.kinetics.warpPaths.moments,fileStatsInit.kinetics.mocap.moments.scalar,fileStatsInit.kinetics.ndi.moments.scalar,visibleMomentsEndPtsInit);
    annotateKinetics(fileStatsInit.kinetics.mocap.moments.scalar,fileStatsInit.kinetics.ndi.moments.scalar,fileStatsInit.kinetics.diff.moments(4),fileStatsInit.kinetics.warpPaths.moments,plotStyle,fileStatsInit.kinetics.endPts.moments,visibleMomentsEndPtsInit);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
    
    kineticsGraph(9,plotStyle,'Force','Force (N)',fileStatsInit.kinetics.warpPaths.forces,fileStatsInit.kinetics.mocap.forces.scalar,fileStatsInit.kinetics.ndi.forces.scalar,visibleForcesEndPtsInit);
    annotateKinetics(fileStatsInit.kinetics.mocap.forces.scalar,fileStatsInit.kinetics.ndi.forces.scalar,fileStatsInit.kinetics.diff.forces(4),fileStatsInit.kinetics.warpPaths.forces,plotStyle,fileStatsInit.kinetics.endPts.forces,visibleForcesEndPtsInit);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
end
