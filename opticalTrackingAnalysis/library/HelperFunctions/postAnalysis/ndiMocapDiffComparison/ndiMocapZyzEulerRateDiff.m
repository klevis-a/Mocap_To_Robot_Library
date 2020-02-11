function captureInfo=ndiMocapZyzEulerRateDiff(captureInfo,cs,rigidBody,warpPath,endPts,genericComputeDiffFun)
    statsPath={'mmdeg','velocity','euler','zyz'};
    diffPathVec=statsPath;
    diffPathVec{end+1}='vector';
    diffPathScalar={'mmdeg','velocity','angular','scalar'};
    captureInfo=genericComputeDiffFun(captureInfo,cs,rigidBody,warpPath,endPts,diffPathVec,diffPathScalar,statsPath,@warpedVectorDiff,@eulerScalarDiff);
end