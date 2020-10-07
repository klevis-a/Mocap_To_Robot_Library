function captureInfo=computeKineticsEndPointsDtwOffset(captureInfo)
    %determine endpoints based on activity
    endPts=determineEndPts(captureInfo.activity,captureInfo.mocap.time);
    
    %the warp paths allow you to find the end points for computing RMS
    %values. Note that we don't want to use the entire capture because
    %there is tons of zeros at the beginning and end which would skew the
    %statistics
    axialForceEndPts(1)=find(captureInfo.kinetics.warpPaths.axialForce(:,1)==endPts(1), 1, 'last');
    axialForceEndPts(2)=find(captureInfo.kinetics.warpPaths.axialForce(:,1)==endPts(2), 1, 'first');
    bendingMomentEndPts(1)=find(captureInfo.kinetics.warpPaths.bendingMoment(:,1)==endPts(1), 1, 'last');
    bendingMomentEndPts(2)=find(captureInfo.kinetics.warpPaths.bendingMoment(:,1)==endPts(2), 1, 'first');
    axialMomentEndPts(1)=find(captureInfo.kinetics.warpPaths.axialMoment(:,1)==endPts(1), 1, 'last');
    axialMomentEndPts(2)=find(captureInfo.kinetics.warpPaths.axialMoment(:,1)==endPts(2), 1, 'first');
    forcesEndPts(1)=find(captureInfo.kinetics.warpPaths.forces(:,1)==endPts(1), 1, 'last');
    forcesEndPts(2)=find(captureInfo.kinetics.warpPaths.forces(:,1)==endPts(2), 1, 'first');
    momentsEndPts(1)=find(captureInfo.kinetics.warpPaths.moments(:,1)==endPts(1), 1, 'last');
    momentsEndPts(2)=find(captureInfo.kinetics.warpPaths.moments(:,1)==endPts(2), 1, 'first');
    
    if captureInfo.activity==Activities.JJ_free || captureInfo.activity==Activities.JL
        %the warp paths allow you to find the end points for computing RMS
        %values. Note that we don't want to use the entire capture because
        %there is tons of zeros at the beginning and end which would skew the
        %statistics
        axialForceEndPts_startStop(1)=find(captureInfo.kinetics.warpPaths.axialForce(:,2)==captureInfo.ndiStart, 1, 'last');
        axialForceEndPts_startStop(2)=find(captureInfo.kinetics.warpPaths.axialForce(:,2)==captureInfo.ndiStop, 1, 'first');
        bendingMomentEndPts_startStop(1)=find(captureInfo.kinetics.warpPaths.bendingMoment(:,2)==captureInfo.ndiStart, 1, 'last');
        bendingMomentEndPts_startStop(2)=find(captureInfo.kinetics.warpPaths.bendingMoment(:,2)==captureInfo.ndiStop, 1, 'first');
        axialMomentEndPts_startStop(1)=find(captureInfo.kinetics.warpPaths.axialMoment(:,2)==captureInfo.ndiStart, 1, 'last');
        axialMomentEndPts_startStop(2)=find(captureInfo.kinetics.warpPaths.axialMoment(:,2)==captureInfo.ndiStop, 1, 'first');
        forcesEndPts_startStop(1)=find(captureInfo.kinetics.warpPaths.forces(:,2)==captureInfo.ndiStart, 1, 'last');
        forcesEndPts_startStop(2)=find(captureInfo.kinetics.warpPaths.forces(:,2)==captureInfo.ndiStop, 1, 'first');
        momentsEndPts_startStop(1)=find(captureInfo.kinetics.warpPaths.moments(:,2)==captureInfo.ndiStart, 1, 'last');
        momentsEndPts_startStop(2)=find(captureInfo.kinetics.warpPaths.moments(:,2)==captureInfo.ndiStop, 1, 'first');

        captureInfo.kinetics.endPts.axialForce(1)=max(axialForceEndPts(1),axialForceEndPts_startStop(1));
        captureInfo.kinetics.endPts.axialForce(2)=min(axialForceEndPts(2),axialForceEndPts_startStop(2));
        captureInfo.kinetics.endPts.bendingMoment(1)=max(bendingMomentEndPts(1),bendingMomentEndPts_startStop(1));
        captureInfo.kinetics.endPts.bendingMoment(2)=min(bendingMomentEndPts(2),bendingMomentEndPts_startStop(2));
        captureInfo.kinetics.endPts.axialMoment(1)=max(axialMomentEndPts(1), axialMomentEndPts_startStop(1));
        captureInfo.kinetics.endPts.axialMoment(2)=min(axialMomentEndPts(2), axialMomentEndPts_startStop(2));
        captureInfo.kinetics.endPts.forces(1)=max(forcesEndPts(1), forcesEndPts_startStop(1));
        captureInfo.kinetics.endPts.forces(2)=min(forcesEndPts(2), forcesEndPts_startStop(2));
        captureInfo.kinetics.endPts.moments(1)=max(momentsEndPts(1), momentsEndPts_startStop(1));
        captureInfo.kinetics.endPts.moments(2)=min(momentsEndPts(2), momentsEndPts_startStop(2));
    else
        captureInfo.kinetics.endPts.axialForce=axialForceEndPts;
        captureInfo.kinetics.endPts.bendingMoment=bendingMomentEndPts;
        captureInfo.kinetics.endPts.axialMoment=axialMomentEndPts;
        captureInfo.kinetics.endPts.forces=forcesEndPts;
        captureInfo.kinetics.endPts.moments=momentsEndPts;
    end
end