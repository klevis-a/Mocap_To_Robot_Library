function endPts=endPointsJL(mocapTime,smoothingParams)
    %First we extend the capture by the gauss interval at the beginning and
    %end of a capture. Then we pad by the pad length at the beginning and
    %end, smooth, and remove the number of points specified by padRemoval.
    endPts(1)=(smoothingParams.padLength-smoothingParams.padRemoval)+smoothingParams.gaussInterval+1;
    endPts(2)=length(mocapTime)-((smoothingParams.padLength-smoothingParams.padRemoval)+smoothingParams.gaussInterval);
end