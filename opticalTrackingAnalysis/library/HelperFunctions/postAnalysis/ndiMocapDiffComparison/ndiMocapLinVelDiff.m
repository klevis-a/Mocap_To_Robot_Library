function captureInfo=ndiMocapLinVelDiff(captureInfo,cs,rigidBody,warpPath,endPts,genericComputeDiffFun)
    statsPath={'mmdeg','velocity','linear'};
    diffPathVec=statsPath;
    diffPathVec{end+1}='vector';
    diffPathScalar=statsPath;
    diffPathScalar{end+1}='scalar';
    captureInfo=genericComputeDiffFun(captureInfo,cs,rigidBody,warpPath,endPts,diffPathVec,diffPathScalar,statsPath,@warpedVectorDiff,@warpedScalarDiff);
end