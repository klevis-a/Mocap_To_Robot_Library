function captureInfo=computeKineticsEndPointsRegOffset(captureInfo)
    %determine endpoints based on activity
    endPts=determineEndPts(captureInfo.activity,captureInfo.mocap.time);
    
    captureInfo.kinetics.endPts.axialForce=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
    captureInfo.kinetics.endPts.bendingMoment=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
    captureInfo.kinetics.endPts.axialMoment=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
    captureInfo.kinetics.endPts.forces=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
    captureInfo.kinetics.endPts.moments=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
end
