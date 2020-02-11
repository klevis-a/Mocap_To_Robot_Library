function captureInfo=ndiMocapYxzEulerAccDiff(captureInfo,cs,rigidBody,warpPath,endPts,genericComputeDiffFun)
    statsPath={'mmdeg','acceleration','euler','yxz'};
    diffPathVec=statsPath;
    diffPathVec{end+1}='vector';
    diffPathScalar={'mmdeg','acceleration','angular','scalar'};
    captureInfo=genericComputeDiffFun(captureInfo,cs,rigidBody,warpPath,endPts,diffPathVec,diffPathScalar,statsPath,@warpedVectorDiff,@eulerScalarDiff);
end