function captureInfo=ndiMocapRotDiff(captureInfo,cs,rigidBody,warpPath,endPts,genericComputeDiffFun)
    statsPath={'mmdeg','pose','rotation'};
    diffPath={'pose','frames'};
    diffPathScalar=statsPath;
    diffPathScalar{end+1}='scalar';
    xcorrPath=statsPath;
    xcorrPath{end+1}='vector';
    captureInfo=genericComputeDiffFun(captureInfo,cs,rigidBody,warpPath,endPts,diffPath,diffPathScalar,statsPath,@warpedRotFrameDiff,@warpedScalarDiff,xcorrPath);
end