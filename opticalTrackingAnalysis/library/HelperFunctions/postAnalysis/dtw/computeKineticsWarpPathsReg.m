function captureInfo=computeKineticsWarpPathsReg(captureInfo)
    %warp path for axial force
    captureInfo.kinetics.warpPaths.axialForce = ...
        warpPathFromNdiStartStop(captureInfo.mocap.time,captureInfo.ndi.time,captureInfo.ndiStart,captureInfo.ndiStop);
    %warp path for bending moment
    captureInfo.kinetics.warpPaths.bendingMoment = captureInfo.kinetics.warpPaths.axialForce;
    captureInfo.kinetics.warpPaths.thorax.bendingMoment = captureInfo.kinetics.warpPaths.axialForce;
    %warp path for axial moment
    captureInfo.kinetics.warpPaths.axialMoment = captureInfo.kinetics.warpPaths.axialForce;
    %warp path for forces
    captureInfo.kinetics.warpPaths.forces= captureInfo.kinetics.warpPaths.axialForce;
    %warp path for moments
    captureInfo.kinetics.warpPaths.moments= captureInfo.kinetics.warpPaths.axialForce;
end