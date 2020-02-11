function warpPath=warpPathFromNdiStartStop(mocapTime,ndiTime,ndiStart,ndiStop)
    %number of mocap points and ndiStart:ndiStop points should be the same
    numMocapPoints=length(mocapTime);
    numNdiPoints=length(ndiTime);
    assert(numMocapPoints==(ndiStop-ndiStart+1));
    warpPath=zeros(numNdiPoints,2);
    warpPath(:,2)=1:numNdiPoints;
    %map all of the points prior to ndiStart to the first mocap index
    warpPath(1:ndiStart-1,1)=1;
    %map all the points from ndiStart to ndiStop to the corresponding mocap
    %points
    warpPath(ndiStart:ndiStop,1)=1:numMocapPoints;
    %map the rest of the points to the last mocap index
    warpPath(ndiStop+1:end,1)=numMocapPoints;
end