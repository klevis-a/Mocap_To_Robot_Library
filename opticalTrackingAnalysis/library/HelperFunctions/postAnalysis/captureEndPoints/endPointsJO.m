function endPts=endPointsJO(mocapTime,~)
    %jogging movements are extended by 30 points in each
    %direction to allow for any speed-up/slow-down.
    endPts(1)=31;
    endPts(2)=length(mocapTime)-30;
end