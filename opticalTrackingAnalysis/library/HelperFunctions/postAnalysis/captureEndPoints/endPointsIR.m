function endPts=endPointsIR(mocapTime,~)
    %internal rotation movements are extended by 10 points in each
    %direction to allow for any speed-up/slow-down.
    endPts(1)=11;
    endPts(2)=length(mocapTime)-10;
end