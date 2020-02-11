function captureInfo=ndiMocapYxzEulerRateDiff(captureInfo,cs,rigidBody,warpPath,endPts,genericComputeDiffFun)
    statsPath={'mmdeg','velocity','euler','yxz'};
    diffPathVec=statsPath;
    diffPathVec{end+1}='vector';
    diffPathScalar={'mmdeg','velocity','angular','scalar'};
    captureInfo=genericComputeDiffFun(captureInfo,cs,rigidBody,warpPath,endPts,diffPathVec,diffPathScalar,statsPath,@warpedVectorDiff,@eulerScalarDiff);
end