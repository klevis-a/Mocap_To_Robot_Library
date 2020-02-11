function [captureInfoAvg,captureInfoInit]=checkFileFunctionRepeats(plotStyle,samplingPeriods,postAnalysisAngAccDtw,robotI,dataFolder,file,poseCsRbs,velCsRbs,accCsRbs,monitorNum,plotDiff,plotPer,postAnalysisRepeatsAvail,postAnalysisOffsetEndpts,filterFunctions)
    %read all captures
    [captureInfoInit,captureInfoAvg]=readAndProcessRepeatCaptures(samplingPeriods,robotI,dataFolder,file,postAnalysisRepeatsAvail,filterFunctions);
    %determine capture timing for the initial capture
    captureInfoInit = determineCaptureTimingXCorr(captureInfoInit,samplingPeriods.mocapSamplingPeriod);
    %determine capture timing for the average capture
    captureInfoAvg = determineCaptureTimingXCorr(captureInfoAvg,samplingPeriods.mocapSamplingPeriod);
    
    if postAnalysisOffsetEndpts
        endPointFunc=@computeEndPointsRegOffset;
    else
        endPointFunc=@computeEndPointsReg;
    end
    
    %compute statistics
    captureInfoAvg=computeWarpPathsReg(captureInfoAvg,poseCsRbs,velCsRbs,accCsRbs,postAnalysisAngAccDtw);
    captureInfoAvg=endPointFunc(captureInfoAvg,poseCsRbs,velCsRbs,accCsRbs);
    captureInfoAvg=computeCaptureStatistics(captureInfoAvg,poseCsRbs,velCsRbs,accCsRbs);
    captureInfoInit=computeWarpPathsReg(captureInfoInit,poseCsRbs,velCsRbs,accCsRbs,postAnalysisAngAccDtw);
    captureInfoInit=endPointFunc(captureInfoInit,poseCsRbs,velCsRbs,accCsRbs);
    captureInfoInit=computeCaptureStatistics(captureInfoInit,poseCsRbs,velCsRbs,accCsRbs);
    
    %find the start and stop of what to display on the graph - based on
    %ndiStart, ndiStop and and offset
    visiblePosEndPtsInit=computeVisibleEndPtsReg(captureInfoInit.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB),...
        captureInfoInit.ndiStart,captureInfoInit.ndiStop,2,15);
    visibleVelEndPtsInit=visiblePosEndPtsInit;
    visibleAccEndPtsInit=visiblePosEndPtsInit;
    
    visiblePosEndPtsAvg=computeVisibleEndPtsReg(captureInfoAvg.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB),...
        captureInfoAvg.ndiStart,captureInfoAvg.ndiStop,2,15);
    visibleVelEndPtsAvg=visiblePosEndPtsAvg;
    visibleAccEndPtsAvg=visiblePosEndPtsAvg;
    
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
    
    %initial capture
    %Orientation Components
    graphFunc(4,plotStyle,'Desired vs Achieved Orientation',sprintf('Orientation (%s)',graphUnits{1}),...
        captureInfoInit,{'pose','rotation'},poseCsRbs,visiblePosEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    %Angular Velocity Components
    graphFunc(5,plotStyle,'Desired vs Achieved Angular Velocity',sprintf('Angular Velocity (%s)',graphUnits{2}),...
        captureInfoInit,{'velocity','angular'},velCsRbs,visibleVelEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    %Angular Acceleration Components
    graphFunc(6,plotStyle,'Desired vs Achieved Angular Acceleration',sprintf('Angular Acceleration (%s)',graphUnits{3}),...
        captureInfoInit,{'acceleration','angular'},accCsRbs,visibleAccEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    %Position Components
    graphFunc(1,plotStyle,'Desired vs Achieved Position',sprintf('Distance (%s)',graphUnits{4}),...
        captureInfoInit,{'pose','position'},poseCsRbs,visiblePosEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    %Linear Velocity Components
    graphFunc(2,plotStyle,'Desired vs Achieved Linear Velocity',sprintf('Linear Velocity (%s)',graphUnits{5}),...
        captureInfoInit,{'velocity','linear'},velCsRbs,visibleVelEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])

    %Linear Acceleration Components
    graphFunc(3,plotStyle,'Desired vs Achieved Linear Acceleration',sprintf('Linear Acceleration (%s)',graphUnits{6}),...
        captureInfoInit,{'acceleration','linear'},accCsRbs,visibleAccEndPtsInit,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
    
    %average capture
    %Orientation Components
    graphFunc(10,plotStyle,'Desired vs Achieved Orientation',sprintf('Orientation (%s)',graphUnits{1}),...
        captureInfoAvg,{'pose','rotation'},poseCsRbs,visiblePosEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset yOffset graph_width graph_height])
    
    %Angular Velocity Components
    graphFunc(11,plotStyle,'Desired vs Achieved Angular Velocity',sprintf('Angular Velocity (%s)',graphUnits{2}),...
        captureInfoAvg,{'velocity','angular'},velCsRbs,visibleVelEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset graph_width graph_height])
    
    %Angular Acceleration Components
    graphFunc(12,plotStyle,'Desired vs Achieved Angular Acceleration',sprintf('Angular Acceleration (%s)',graphUnits{3}),...
        captureInfoAvg,{'acceleration','angular'},accCsRbs,visibleAccEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset graph_width graph_height])
    
    %Position Components
    graphFunc(7,plotStyle,'Desired vs Achieved Position',sprintf('Distance (%s)',graphUnits{4}),...
        captureInfoAvg,{'pose','position'},poseCsRbs,visiblePosEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset yOffset+graph_height graph_width graph_height])
    
    %Linear Velocity Components
    graphFunc(8,plotStyle,'Desired vs Achieved Linear Velocity',sprintf('Linear Velocity (%s)',graphUnits{5}),...
        captureInfoAvg,{'velocity','linear'},velCsRbs,visibleVelEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+graph_width-60 yOffset+graph_height graph_width graph_height])

    %Linear Acceleration Components
    graphFunc(9,plotStyle,'Desired vs Achieved Linear Acceleration',sprintf('Linear Acceleration (%s)',graphUnits{6}),...
        captureInfoAvg,{'acceleration','linear'},accCsRbs,visibleAccEndPtsAvg,plotPer);
    set(gcf,'Position',[xOffset+2*graph_width-60 yOffset+graph_height graph_width graph_height])
end