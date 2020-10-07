function captureInfo=computeKineticsEndPointsDtw(captureInfo)
    %the warp paths allow you to find the end points for computing RMS
    %values. Note that we don't want to use the entire capture because
    %there is tons of zeros at the beginning and end which would skew the
    %statistics
    axialForceEndPts(1)=find(captureInfo.kinetics.warpPaths.axialForce(:,2)==captureInfo.ndiStart, 1, 'last');
    axialForceEndPts(2)=find(captureInfo.kinetics.warpPaths.axialForce(:,2)==captureInfo.ndiStop, 1, 'first');
    bendingMomentEndPts(1)=find(captureInfo.kinetics.warpPaths.bendingMoment(:,2)==captureInfo.ndiStart, 1, 'last');
    bendingMomentEndPts(2)=find(captureInfo.kinetics.warpPaths.bendingMoment(:,2)==captureInfo.ndiStop, 1, 'first');
    axialMomentEndPts(1)=find(captureInfo.kinetics.warpPaths.axialMoment(:,2)==captureInfo.ndiStart, 1, 'last');
    axialMomentEndPts(2)=find(captureInfo.kinetics.warpPaths.axialMoment(:,2)==captureInfo.ndiStop, 1, 'first');
    forcesEndPts(1)=find(captureInfo.kinetics.warpPaths.forces(:,2)==captureInfo.ndiStart, 1, 'last');
    forcesEndPts(2)=find(captureInfo.kinetics.warpPaths.forces(:,2)==captureInfo.ndiStop, 1, 'first');
    momentsEndPts(1)=find(captureInfo.kinetics.warpPaths.moments(:,2)==captureInfo.ndiStart, 1, 'last');
    momentsEndPts(2)=find(captureInfo.kinetics.warpPaths.moments(:,2)==captureInfo.ndiStop, 1, 'first');
    
    captureInfo.kinetics.endPts.axialForce=axialForceEndPts;
    captureInfo.kinetics.endPts.bendingMoment=bendingMomentEndPts;
    captureInfo.kinetics.endPts.axialMoment=axialMomentEndPts;
    captureInfo.kinetics.endPts.forces=forcesEndPts;
    captureInfo.kinetics.endPts.moments=momentsEndPts;
end
