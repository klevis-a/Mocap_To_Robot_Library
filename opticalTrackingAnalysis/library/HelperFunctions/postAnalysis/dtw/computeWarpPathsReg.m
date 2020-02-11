function captureInfo=computeWarpPathsReg(captureInfo,poseWarpPath,velWarpPath,accWarpPath,~)
    %warp path for pose
    captureInfo.warpPaths.pose.(poseWarpPath.linCS).(poseWarpPath.linRB).(poseWarpPath.rotCS).(poseWarpPath.rotRB) = ...
        warpPathFromNdiStartStop(captureInfo.mocap.time,captureInfo.ndi.time,captureInfo.ndiStart,captureInfo.ndiStop);
    %warp path for velocity
    captureInfo.warpPaths.velocity.(velWarpPath.linCS).(velWarpPath.linRB).(velWarpPath.rotCS).(velWarpPath.rotRB) = ...
        captureInfo.warpPaths.pose.(poseWarpPath.linCS).(poseWarpPath.linRB).(poseWarpPath.rotCS).(poseWarpPath.rotRB);
    %warp path for acceleration
    captureInfo.warpPaths.acceleration.(accWarpPath.linCS).(accWarpPath.linRB).(accWarpPath.rotCS).(accWarpPath.rotRB) = ...
        captureInfo.warpPaths.pose.(poseWarpPath.linCS).(poseWarpPath.linRB).(poseWarpPath.rotCS).(poseWarpPath.rotRB);
end