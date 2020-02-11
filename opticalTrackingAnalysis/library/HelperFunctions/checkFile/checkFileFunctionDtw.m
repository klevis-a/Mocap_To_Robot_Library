function fileStats=checkFileFunctionDtw(plotStyle,samplingPeriods,postAnalysisAngAccDtw,robotI,dataFolder,file,poseCsRbs,velCsRbs,accCsRbs,monitorNum,plotDiff,plotPer,~,postAnalysisOffsetEndpts,filterFunctions)

    if postAnalysisOffsetEndpts
        endPointFunc=@computeEndPointsDtwOffset;
    else
        endPointFunc=@computeEndPointsDtw;
    end
    
    fileStats=readAndProcessCapture(samplingPeriods,robotI,dataFolder,file,filterFunctions);
    fileStats=determineCaptureTimingXCorr(fileStats,samplingPeriods.mocapSamplingPeriod);
    fileStats=computeWarpPathsDtw(fileStats,poseCsRbs,velCsRbs,accCsRbs,postAnalysisAngAccDtw);
    fileStats=endPointFunc(fileStats,poseCsRbs,velCsRbs,accCsRbs);
    fileStats=computeCaptureStatistics(fileStats,poseCsRbs,velCsRbs,accCsRbs);
    
    %find the start and stop of what to display on the graph - based on
    %ndiStart, ndiStop and and offset
    visiblePosEndPts=computeVisibleEndPtsDtw(fileStats.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB),...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleVelEndPts=computeVisibleEndPtsDtw(fileStats.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB),...
        fileStats.ndiStart,fileStats.ndiStop,2,15);
    visibleAccEndPts=computeVisibleEndPtsDtw(fileStats.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB),...
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
    
    %Orientation Components
    graphFunc(4,plotStyle,'Time Warped Desired vs Achieved Orientation',sprintf('Orientation (%s)',graphUnits{1}),...
        fileStats,{'pose','rotation'},poseCsRbs,visiblePosEndPts,plotPer);
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    %Angular Velocity Components
    graphFunc(5,plotStyle,'Time Warped Desired vs Achieved Angular Velocity',sprintf('Angular Velocity (%s)',graphUnits{2}),...
        fileStats,{'velocity','angular'},velCsRbs,visibleVelEndPts,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    %Angular Acceleration Components
    graphFunc(6,plotStyle,'Time Warped Desired vs Achieved Angular Acceleration',sprintf('Angular Acceleration (%s)',graphUnits{3}),...
        fileStats,{'acceleration','angular'},accCsRbs,visibleAccEndPts,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    %Position Components
    graphFunc(1,plotStyle,'Time Warped Desired vs Achieved Position',sprintf('Distance (%s)',graphUnits{4}),...
        fileStats,{'pose','position'},poseCsRbs,visiblePosEndPts,plotPer);
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    %Linear Velocity Components
    graphFunc(2,plotStyle,'Time Warped Desired vs Achieved Linear Velocity',sprintf('Linear Velocity (%s)',graphUnits{5}),...
        fileStats,{'velocity','linear'},velCsRbs,visibleVelEndPts,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])

    %Linear Acceleration Components
    graphFunc(3,plotStyle,'Time Warped Desired vs Achieved Linear Acceleration',sprintf('Linear Acceleration (%s)',graphUnits{6}),...
        fileStats,{'acceleration','linear'},accCsRbs,visibleAccEndPts,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
end
