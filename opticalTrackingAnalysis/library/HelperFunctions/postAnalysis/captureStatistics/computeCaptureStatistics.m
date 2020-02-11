function captureInfo=computeCaptureStatistics(captureInfo,poseCsRbs,velCsRbs,accCsRbs,varargin)
    if nargin>4
        genericComputeDiffFun=varargin{1};
    else
        genericComputeDiffFun=@ndiMocapGenericComputeDiff;
    end
    
    %shorten the warp path names to make it easier
    warpPathPose=captureInfo.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB);
    warpPathVelocity=captureInfo.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB);
    warpPathAcceleration=captureInfo.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB);
    
    posEndPts=captureInfo.endPts.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB);
    velEndPts=captureInfo.endPts.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB);
    accEndPts=captureInfo.endPts.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB);
    
    %Position Statistics
    captureInfo=ndiMocapPosDiff(captureInfo,poseCsRbs.linCS,poseCsRbs.linRB,warpPathPose,posEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','pose','position'},poseCsRbs.linCS,poseCsRbs.linRB);

    %Orientation Statistics
    captureInfo=ndiMocapRotDiff(captureInfo,poseCsRbs.rotCS,poseCsRbs.rotRB,warpPathPose,posEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','pose','rotation'},poseCsRbs.rotCS,poseCsRbs.rotRB);

    %Euler Statistics
    captureInfo=ndiMocapZyzEulerDiff(captureInfo,poseCsRbs.eulerCS,poseCsRbs.eulerRB,warpPathPose,posEndPts,genericComputeDiffFun);
    captureInfo=ndiMocapYxzEulerDiff(captureInfo,poseCsRbs.eulerCS,poseCsRbs.eulerRB,warpPathPose,posEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','pose','euler','zyz'},poseCsRbs.eulerCS,poseCsRbs.eulerRB);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','pose','euler','yxz'},poseCsRbs.eulerCS,poseCsRbs.eulerRB);

    %Linear Velocity Statistics
    captureInfo=ndiMocapLinVelDiff(captureInfo,velCsRbs.linCS,velCsRbs.linRB,warpPathVelocity,velEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','velocity','linear'},velCsRbs.linCS,velCsRbs.linRB);

    %Angular Velocity Statistics
    captureInfo=ndiMocapRotVelDiff(captureInfo,velCsRbs.rotCS,velCsRbs.rotRB,warpPathVelocity,velEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','velocity','angular'},velCsRbs.rotCS,velCsRbs.rotRB);

    %Euler Rate Statistics
    captureInfo=ndiMocapZyzEulerRateDiff(captureInfo,velCsRbs.eulerCS,velCsRbs.eulerRB,warpPathVelocity,velEndPts,genericComputeDiffFun);
    captureInfo=ndiMocapYxzEulerRateDiff(captureInfo,velCsRbs.eulerCS,velCsRbs.eulerRB,warpPathVelocity,velEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','velocity','euler','zyz'},velCsRbs.eulerCS,velCsRbs.eulerRB);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','velocity','euler','yxz'},velCsRbs.eulerCS,velCsRbs.eulerRB);

    %Linear Acceleration Statistics
    captureInfo=ndiMocapLinAccDiff(captureInfo,accCsRbs.linCS,accCsRbs.linRB,warpPathAcceleration,accEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','acceleration','linear'},accCsRbs.linCS,accCsRbs.linRB);

    %Angular Acceleration Statistics
    captureInfo=ndiMocapRotAccDiff(captureInfo,accCsRbs.rotCS,accCsRbs.rotRB,warpPathAcceleration,accEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','acceleration','angular'},accCsRbs.rotCS,accCsRbs.rotRB);

    %Euler Acceleration Statistics
    captureInfo=ndiMocapZyzEulerAccDiff(captureInfo,accCsRbs.eulerCS,accCsRbs.eulerRB,warpPathAcceleration,accEndPts,genericComputeDiffFun);
    captureInfo=ndiMocapYxzEulerAccDiff(captureInfo,accCsRbs.eulerCS,accCsRbs.eulerRB,warpPathAcceleration,accEndPts,genericComputeDiffFun);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','acceleration','euler','zyz'},accCsRbs.eulerCS,accCsRbs.eulerRB);
    captureInfo=computeIndividualPercentages(captureInfo,{'mmdeg','acceleration','euler','yxz'},accCsRbs.eulerCS,accCsRbs.eulerRB);
end