function endPts=determineEndPts(activity,mocapTime)
    %These are the parameters that were used while smoothing. Ideally these
    %would be tied with each capture and read in on a capture by capture
    %basis but the structure of the current workflow doesn't allow for
    %that. But the parameters below were used universally.
    smoothingParams.gaussInterval=15;
    smoothingParams.padLength=10;
    smoothingParams.padRemoval=7;

    switch activity
        case Activities.JJ_free
            endPointFunc=@endPointsJJ;
        case Activities.JL
            endPointFunc=@endPointsJL;
        case Activities.JO_free
            endPointFunc=@endPointsJO;
        case Activities.IR90
            endPointFunc=@endPointsIR;
    end
    
    endPts=endPointFunc(mocapTime,smoothingParams);
end