function endPts=endPointsJJ(mocapTime,smoothingParams)
    %for a JJ we pad by padLength, smooth using gaussInterval, and remove
    %the number of points specified by padRemoval. This means that the
    %number of points that are affected in terms of velocity and
    %acceleration at the beginning and end of a capture are
    %(padLength-padRemoval)+gaussInterval/2
    endPts(1)=smoothingParams.padLength-smoothingParams.padRemoval+floor(smoothingParams.gaussInterval/2)+1;
    endPts(2)=length(mocapTime)-(smoothingParams.padLength-smoothingParams.padRemoval+floor(smoothingParams.gaussInterval/2));
end