function captureInfo=computeKineticsStatistics(captureInfo)
    %shorten the warp path names to make it easier
    warpPathAxialForce=captureInfo.kinetics.warpPaths.axialForce;
    warpPathBendingMoment=captureInfo.kinetics.warpPaths.bendingMoment;
    warpPathBendingMoment_thorax=captureInfo.kinetics.warpPaths.thorax.bendingMoment;
    warpPathAxialMoment=captureInfo.kinetics.warpPaths.axialMoment;
    warpPathForces=captureInfo.kinetics.warpPaths.forces;
    warpPathMoments=captureInfo.kinetics.warpPaths.moments;
    
    %endpoints
    axialForceEndPts=captureInfo.kinetics.endPts.axialForce;
    bendingMomentEndPts=captureInfo.kinetics.endPts.bendingMoment;
    axialMomentEndPts=captureInfo.kinetics.endPts.axialMoment;
    forcesEndPts=captureInfo.kinetics.endPts.forces;
    momentsEndPts=captureInfo.kinetics.endPts.moments;
    
    %axial force
    axialForceDiff=warpedScalarDiff(captureInfo.kinetics.mocap.axialForce,captureInfo.kinetics.ndi.axialForce,warpPathAxialForce);
    warpedMocapAxialForce=captureInfo.kinetics.mocap.axialForce(warpPathAxialForce(:,1));
    warpedNdiAxialForce=captureInfo.kinetics.ndi.axialForce(warpPathAxialForce(:,2));
    axialForceSpan=max(warpedMocapAxialForce(axialForceEndPts(1):axialForceEndPts(2)))-min(warpedMocapAxialForce(axialForceEndPts(1):axialForceEndPts(2)));
    
    %bending moment
    bendingMomentDiff=warpedScalarDiff(captureInfo.kinetics.mocap.bendingMoment,captureInfo.kinetics.ndi.bendingMoment,warpPathBendingMoment);
    warpedMocapBendingMoment=captureInfo.kinetics.mocap.bendingMoment(warpPathBendingMoment(:,1));
    warpedNdiBendingMoment=captureInfo.kinetics.ndi.bendingMoment(warpPathBendingMoment(:,2));
    bendingMomentSpan=max(warpedMocapBendingMoment(bendingMomentEndPts(1):bendingMomentEndPts(2)));
    
    %bending moment thorax
    bendingMomentDiff_thorax=warpedScalarDiff(captureInfo.kinetics.mocap.thorax.bendingMoment,captureInfo.kinetics.ndi.thorax.bendingMoment,warpPathBendingMoment_thorax);
    warpedMocapBendingMoment_thorax=captureInfo.kinetics.mocap.thorax.bendingMoment(warpPathBendingMoment_thorax(:,1));
    warpedNdiBendingMoment_thorax=captureInfo.kinetics.ndi.thorax.bendingMoment(warpPathBendingMoment_thorax(:,2));
    bendingMomentSpan_thorax=max(warpedMocapBendingMoment_thorax(bendingMomentEndPts(1):bendingMomentEndPts(2)));
    
    %axial moment
    axialMomentDiff=warpedScalarDiff(captureInfo.kinetics.mocap.axialMoment,captureInfo.kinetics.ndi.axialMoment,warpPathAxialMoment);
    warpedMocapAxialMoment=captureInfo.kinetics.mocap.axialMoment(warpPathAxialMoment(:,1));
    warpedNdiAxialMoment=captureInfo.kinetics.ndi.axialMoment(warpPathAxialMoment(:,2));
    axialMomentSpan=max(warpedMocapAxialMoment(axialMomentEndPts(1):axialMomentEndPts(2)))-min(warpedMocapAxialMoment(axialMomentEndPts(1):axialMomentEndPts(2)));
    
    %forces vector
    forcesDiffVector=warpedVectorDiff(captureInfo.kinetics.mocap.forces.vector,captureInfo.kinetics.ndi.forces.vector,warpPathForces);
    warpedMocapForcesVector=captureInfo.kinetics.mocap.forces.vector(warpPathForces(:,1),:);
    warpedNdiForcesVector=captureInfo.kinetics.ndi.forces.vector(warpPathForces(:,2),:);
    forcesSpanVector=max(warpedMocapForcesVector(forcesEndPts(1):forcesEndPts(2),:))-min(warpedMocapForcesVector(forcesEndPts(1):forcesEndPts(2),:),[],1);
    
    %moments vector
    momentsDiffVector=warpedVectorDiff(captureInfo.kinetics.mocap.moments.vector,captureInfo.kinetics.ndi.moments.vector,warpPathMoments);
    warpedMocapMomentsVector=captureInfo.kinetics.mocap.moments.vector(warpPathMoments(:,1),:);
    warpedNdiMomentsVector=captureInfo.kinetics.ndi.moments.vector(warpPathMoments(:,2),:);
    momentsSpanVector=max(warpedMocapMomentsVector(momentsEndPts(1):momentsEndPts(2),:))-min(warpedMocapMomentsVector(momentsEndPts(1):momentsEndPts(2),:),[],1);
    
    %forces scalar
    forcesDiffScalar=warpedScalarDiff(captureInfo.kinetics.mocap.forces.scalar,captureInfo.kinetics.ndi.forces.scalar,warpPathForces);
    warpedMocapForcesScalar=captureInfo.kinetics.mocap.forces.scalar(warpPathForces(:,1));
    warpedNdiForcesScalar=captureInfo.kinetics.ndi.forces.scalar(warpPathForces(:,2));
    forcesSpanScalar=max(warpedMocapForcesScalar(forcesEndPts(1):forcesEndPts(2),:))-min(warpedMocapForcesScalar(forcesEndPts(1):forcesEndPts(2),:));
    
    %moments scalar
    momentsDiffScalar=warpedScalarDiff(captureInfo.kinetics.mocap.moments.scalar,captureInfo.kinetics.ndi.moments.scalar,warpPathMoments);
    warpedMocapMomentsScalar=captureInfo.kinetics.mocap.moments.scalar(warpPathMoments(:,1));
    warpedNdiMomentsScalar=captureInfo.kinetics.ndi.moments.scalar(warpPathMoments(:,2));
    momentsSpanScalar=max(warpedMocapMomentsScalar(momentsEndPts(1):momentsEndPts(2),:))-min(warpedMocapMomentsScalar(momentsEndPts(1):momentsEndPts(2),:));
    
    if captureInfo.activity==Activities.IR90
        minPeakProminence=0.2;
        meanPeakWidth=2;
    else
        minPeakProminence=1;
        meanPeakWidth=5;
    end
    
    %axial force
    captureInfo.kinetics.diff.axialForce=computeScalarStats(axialForceDiff,axialForceEndPts,axialForceSpan,warpedMocapAxialForce,warpedNdiAxialForce,minPeakProminence,meanPeakWidth);
    captureInfo.kinetics.diff.axialForce.diff=axialForceDiff;
    captureInfo.kinetics.diff.axialForce.span=axialForceSpan;

    %bending moment
    if captureInfo.activity==Activities.JJ_free
        captureInfo.kinetics.diff.bendingMoment=computeScalarStats(bendingMomentDiff,bendingMomentEndPts,bendingMomentSpan,warpedMocapBendingMoment,warpedNdiBendingMoment,minPeakProminence,meanPeakWidth,1,15);
    else
        captureInfo.kinetics.diff.bendingMoment=computeScalarStats(bendingMomentDiff,bendingMomentEndPts,bendingMomentSpan,warpedMocapBendingMoment,warpedNdiBendingMoment,minPeakProminence,meanPeakWidth);
    end
    captureInfo.kinetics.diff.bendingMoment.diff=bendingMomentDiff;
    captureInfo.kinetics.diff.bendingMoment.span=bendingMomentSpan;
    
    %bending moment thorax
    if captureInfo.activity==Activities.JJ_free
        captureInfo.kinetics.diff.thorax.bendingMoment=computeScalarStats(bendingMomentDiff_thorax,bendingMomentEndPts,bendingMomentSpan_thorax,warpedMocapBendingMoment_thorax,warpedNdiBendingMoment_thorax,minPeakProminence,meanPeakWidth,1,15);
    else
        captureInfo.kinetics.diff.thorax.bendingMoment=computeScalarStats(bendingMomentDiff_thorax,bendingMomentEndPts,bendingMomentSpan_thorax,warpedMocapBendingMoment_thorax,warpedNdiBendingMoment_thorax,minPeakProminence,meanPeakWidth);
    end
    captureInfo.kinetics.diff.thorax.bendingMoment.diff=bendingMomentDiff_thorax;
    captureInfo.kinetics.diff.thorax.bendingMoment.span=bendingMomentSpan_thorax;
    
    %axial moment
    captureInfo.kinetics.diff.axialMoment=computeScalarStats(axialMomentDiff,axialMomentEndPts,axialMomentSpan,warpedMocapAxialMoment,warpedNdiAxialMoment,minPeakProminence,meanPeakWidth);
    captureInfo.kinetics.diff.axialMoment.diff=axialMomentDiff;
    captureInfo.kinetics.diff.axialMoment.span=axialMomentSpan;
    
    for n=1:3
        %forces vector
        tempForces=computeScalarStats(forcesDiffVector(:,n),forcesEndPts,forcesSpanVector(n),warpedMocapForcesVector(:,n),warpedNdiForcesVector(:,n),minPeakProminence,meanPeakWidth);
        tempForces.diff=forcesDiffVector(:,n);
        tempForces.span=forcesSpanVector(n);
        captureInfo.kinetics.diff.forces(n)=tempForces;
        
        %moment vector
        tempMoments=computeScalarStats(momentsDiffVector(:,n),momentsEndPts,momentsSpanVector(n),warpedMocapMomentsVector(:,n),warpedNdiMomentsVector(:,n),minPeakProminence,meanPeakWidth);
        tempMoments.diff=momentsDiffVector(:,n);
        tempMoments.span=momentsSpanVector(n);
        captureInfo.kinetics.diff.moments(n)=tempMoments;
    end
    
    %forces scalar
    tempForces=computeScalarStats(forcesDiffScalar,forcesEndPts,forcesSpanScalar,warpedMocapForcesScalar,warpedNdiForcesScalar,minPeakProminence,meanPeakWidth);
    tempForces.diff=forcesDiffScalar;
    tempForces.span=forcesSpanScalar;
    captureInfo.kinetics.diff.forces(4)=tempForces;

    %moments scalar
    tempMoments=computeScalarStats(momentsDiffScalar,momentsEndPts,momentsSpanScalar,warpedMocapMomentsScalar,warpedNdiMomentsScalar,minPeakProminence,meanPeakWidth);
    tempMoments.diff=momentsDiffScalar;
    tempMoments.span=momentsSpanScalar;
    captureInfo.kinetics.diff.moments(4)=tempMoments;
    
    if captureInfo.activity==Activities.IR90
        [maxMocap,maxMocapI]=max(warpedMocapAxialMoment(axialMomentEndPts(1):axialMomentEndPts(2)));
        [minMocap,minMocapI]=min(warpedMocapAxialMoment(axialMomentEndPts(1):axialMomentEndPts(2)));
        [maxNdi,maxNdiI]=max(warpedNdiAxialMoment(axialMomentEndPts(1):axialMomentEndPts(2)));
        [minNdi,minNdiI]=min(warpedNdiAxialMoment(axialMomentEndPts(1):axialMomentEndPts(2)));
        
        if maxMocap>=maxNdi
            maxI=maxMocapI;
        else
            maxI=maxNdiI;
        end
        
        if minMocap<=minNdi
            minI=minMocapI;
        else
            minI=minNdiI;
        end
        
        maxI = maxI + axialMomentEndPts(1) -1;
        minI = minI + axialMomentEndPts(1) -1;
        assert(maxI<minI);
        captureInfo.kinetics.diff.axialMoment.firstHalf.maxI = maxI;
        captureInfo.kinetics.diff.axialMoment.firstHalf.max = abs(warpedNdiAxialMoment(maxI)-warpedMocapAxialMoment(maxI));
        captureInfo.kinetics.diff.axialMoment.secondHalf.maxI = minI;
        captureInfo.kinetics.diff.axialMoment.secondHalf.max = abs(warpedNdiAxialMoment(minI)-warpedMocapAxialMoment(minI));
        captureInfo.kinetics.diff.axialMoment.percentage.firstHalf.max=captureInfo.kinetics.diff.axialMoment.firstHalf.max/axialMomentSpan*100;
        captureInfo.kinetics.diff.axialMoment.percentage.secondHalf.max=captureInfo.kinetics.diff.axialMoment.secondHalf.max/axialMomentSpan*100;
    end
end