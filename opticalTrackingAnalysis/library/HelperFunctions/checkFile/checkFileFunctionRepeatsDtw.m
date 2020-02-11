function [captureInfoAvg,captureInfoInit]=checkFileFunctionRepeatsDtw(plotStyle,samplingPeriods,postAnalysisAngAccDtw,robotI,dataFolder,file,poseCsRbs,velCsRbs,accCsRbs,monitorNum,plotDiff,plotPer,postAnalysisRepeatsAvail,postAnalysisOffsetEndpts,filterFunctions)
    %read all captures
    [captureInfoInit,captureInfoAvg]=readAndProcessRepeatCaptures(samplingPeriods,robotI,dataFolder,file,postAnalysisRepeatsAvail,filterFunctions);
    %determine capture timing for the initial capture
    captureInfoInit = determineCaptureTimingXCorr(captureInfoInit,samplingPeriods.mocapSamplingPeriod);
    %determine capture timing for the average capture
    captureInfoAvg = determineCaptureTimingXCorr(captureInfoAvg,samplingPeriods.mocapSamplingPeriod);
    
    if postAnalysisOffsetEndpts
        endPointFunc=@computeEndPointsDtwOffset;
    else
        endPointFunc=@computeEndPointsDtw;
    end
    
    %compute statistics
    captureInfoAvg=computeWarpPathsDtw(captureInfoAvg,poseCsRbs,velCsRbs,accCsRbs,postAnalysisAngAccDtw);
    captureInfoAvg=endPointFunc(captureInfoAvg,poseCsRbs,velCsRbs,accCsRbs);
    captureInfoAvg=computeCaptureStatistics(captureInfoAvg,poseCsRbs,velCsRbs,accCsRbs);
    captureInfoInit=computeWarpPathsDtw(captureInfoInit,poseCsRbs,velCsRbs,accCsRbs,postAnalysisAngAccDtw);
    captureInfoInit=endPointFunc(captureInfoInit,poseCsRbs,velCsRbs,accCsRbs);
    captureInfoInit=computeCaptureStatistics(captureInfoInit,poseCsRbs,velCsRbs,accCsRbs);
    
    %find the start and stop of what to display on the graph - based on
    %ndiStart, ndiStop and and offset
    visiblePosEndPtsInit=computeVisibleEndPtsDtw(captureInfoInit.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB),...
        captureInfoInit.ndiStart,captureInfoInit.ndiStop,2,15);
    visibleVelEndPtsInit=computeVisibleEndPtsDtw(captureInfoInit.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB),...
        captureInfoInit.ndiStart,captureInfoInit.ndiStop,2,15);
    visibleAccEndPtsInit=computeVisibleEndPtsDtw(captureInfoInit.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB),...
        captureInfoInit.ndiStart,captureInfoInit.ndiStop,2,15);
    
    visiblePosEndPtsAvg=computeVisibleEndPtsDtw(captureInfoAvg.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB),...
        captureInfoAvg.ndiStart,captureInfoAvg.ndiStop,2,15);
    visibleVelEndPtsAvg=computeVisibleEndPtsDtw(captureInfoAvg.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB),...
        captureInfoAvg.ndiStart,captureInfoAvg.ndiStop,2,15);
    visibleAccEndPtsAvg=computeVisibleEndPtsDtw(captureInfoAvg.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB),...
        captureInfoAvg.ndiStart,captureInfoAvg.ndiStop,2,15);
    
    %screen info
    set(0,'units','pixels');
    screen_resolution = get(0,'MonitorPositions');
    screen_width=screen_resolution(monitorNum,3);
    screen_height=screen_resolution(monitorNum,4);
    graph_width = (screen_width+120)/3;
    graph_height = (screen_height-60)/2;
    xOffset=screen_resolution(monitorNum,1);
    yOffset=screen_resolution(monitorNum,2);

    if plotDiff
        graphFunc=@createCheckFileGraphDiff;
        if plotPer
            graphUnits = {'%','%','%','%','%','%'};
        else
            graphUnits = {'deg','deg/sec','deg/sec^2','mm','mm/sec','mm/sec^2'};
        end
    else
        graphFunc=@createCheckFileGraph;
        graphUnits = {'deg','deg/sec','deg/sec^2','mm','mm/sec','mm/sec^2'};
    end
    
    %Orientation Components Init
    graphFunc(4,plotStyle,'Time Warped Desired vs Achieved Orientation',sprintf('Orientation (%s)',graphUnits{1}),...
        captureInfoInit,{'pose','rotation'},poseCsRbs,visiblePosEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    %Angular Velocity Components Init
    graphFunc(5,plotStyle,'Time Warped Desired vs Achieved Angular Velocity',sprintf('Angular Velocity (%s)',graphUnits{2}),...
        captureInfoInit,{'velocity','angular'},velCsRbs,visibleVelEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    %Angular Acceleration Components Init
    graphFunc(6,plotStyle,'Time Warped Desired vs Achieved Angular Acceleration',sprintf('Angular Acceleration (%s)',graphUnits{3}),...
        captureInfoInit,{'acceleration','angular'},accCsRbs,visibleAccEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    %Position Components Init
    graphFunc(1,plotStyle,'Time Warped Desired vs Achieved Position',sprintf('Distance (%s)',graphUnits{4}),...
        captureInfoInit,{'pose','position'},poseCsRbs,visiblePosEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    %Linear Velocity Components Init
    graphFunc(2,plotStyle,'Time Warped Desired vs Achieved Linear Velocity',sprintf('Linear Velocity (%s)',graphUnits{5}),...
        captureInfoInit,{'velocity','linear'},velCsRbs,visibleVelEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])

    %Linear Acceleration Components Init
    graphFunc(3,plotStyle,'Time Warped Desired vs Achieved Linear Acceleration',sprintf('Linear Acceleration (%s)',graphUnits{6}),...
        captureInfoInit,{'acceleration','linear'},accCsRbs,visibleAccEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
    
    %Orientation Components Avg
    graphFunc(10,plotStyle,'Time Warped Desired vs Achieved Orientation',sprintf('Orientation (%s)',graphUnits{1}),...
        captureInfoAvg,{'pose','rotation'},poseCsRbs,visiblePosEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    %Angular Velocity Components Avg
    graphFunc(11,plotStyle,'Time Warped Desired vs Achieved Angular Velocity',sprintf('Angular Velocity (%s)',graphUnits{2}),...
        captureInfoAvg,{'velocity','angular'},velCsRbs,visibleVelEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    %Angular Acceleration Components Avg
    graphFunc(12,plotStyle,'Time Warped Desired vs Achieved Angular Acceleration',sprintf('Angular Acceleration (%s)',graphUnits{3}),...
        captureInfoAvg,{'acceleration','angular'},accCsRbs,visibleAccEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    %Position Components Avg
    graphFunc(7,plotStyle,'Time Warped Desired vs Achieved Position',sprintf('Distance (%s)',graphUnits{4}),...
        captureInfoAvg,{'pose','position'},poseCsRbs,visiblePosEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    %Linear Velocity Components Avg
    graphFunc(8,plotStyle,'Time Warped Desired vs Achieved Linear Velocity',sprintf('Linear Velocity (%s)',graphUnits{5}),...
        captureInfoAvg,{'velocity','linear'},velCsRbs,visibleVelEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])

    %Linear Acceleration Components Avg
    graphFunc(9,plotStyle,'Time Warped Desired vs Achieved Linear Acceleration',sprintf('Linear Acceleration (%s)',graphUnits{6}),...
        captureInfoAvg,{'acceleration','linear'},accCsRbs,visibleAccEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
end