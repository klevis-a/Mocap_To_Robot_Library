function captureInfo=ndiMocapZyzEulerDiff(captureInfo,cs,rigidBody,warpPath,endPts,genericComputeDiffFun)
    statsPath={'mmdeg','pose','euler','zyz'};
    diffPathVec=statsPath;
    diffPathVec{end+1}='vector';
    diffPathScalar={'mmdeg','pose','rotation','scalar'};
    captureInfo=genericComputeDiffFun(captureInfo,cs,rigidBody,warpPath,endPts,diffPathVec,diffPathScalar,statsPath,@warpedVectorDiff,@eulerScalarDiff);
end