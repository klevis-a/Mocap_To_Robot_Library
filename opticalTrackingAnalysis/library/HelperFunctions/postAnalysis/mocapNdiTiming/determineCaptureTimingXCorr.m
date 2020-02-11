function [captureInfo,ndiEndPts,jointsEndPts]=determineCaptureTimingXCorr(captureInfo,mocapSamplingPeriod)

    switch captureInfo.activity
        case Activities.JJ_free
            cs='lab';
            linRigidBody='bone';
            rotRigidBody='bone';
        case Activities.JL
            cs='lab';
            linRigidBody='hs';
            rotRigidBody='bone';
        case Activities.JO_free
            cs='lab';
            linRigidBody='hs';
            rotRigidBody='bone';
        case Activities.IR90
            cs='lab';
            linRigidBody='hs';
            rotRigidBody='bone';
    end
    
    %how many points do we have for each capture
    numNdiPts=length(captureInfo.ndi.time);
    numMocapPts=length(captureInfo.mocap.time);
    
    %difference in the number of points between mocap and ndi
    mocapNdiDiff=(numNdiPts-numMocapPts+1);
    mocapNdiXCorr=zeros(8,mocapNdiDiff);
    
    %iterate through ndi offset indices and compute the cross-correlation
    for n=1:mocapNdiDiff
        mocapNdiXCorr(1,n)=xcorr(captureInfo.mocap.(cs).(linRigidBody).pose.position.scalar,...
            captureInfo.ndi.(cs).(linRigidBody).pose.position.scalar(n:n+numMocapPts-1),0,'coeff');
        for i=1:3
            mocapNdiXCorr(i+1,n)=xcorr(captureInfo.mocap.(cs).(linRigidBody).pose.position.vector(:,i),...
                captureInfo.ndi.(cs).(linRigidBody).pose.position.vector(n:n+numMocapPts-1,i),0,'coeff');
        end
        mocapNdiXCorr(5,n)=xcorr(captureInfo.mocap.(cs).(rotRigidBody).pose.rotation.scalar,...
            captureInfo.ndi.(cs).(rotRigidBody).pose.rotation.scalar(n:n+numMocapPts-1),0,'coeff');
        for i=1:3
            mocapNdiXCorr(i+5,n)=xcorr(captureInfo.mocap.(cs).(rotRigidBody).pose.rotation.vector(:,i),...
                captureInfo.ndi.(cs).(rotRigidBody).pose.rotation.vector(n:n+numMocapPts-1,i),0,'coeff');
        end
    end
    
    %the offset index occurs where the maximum cross-correlation occurs -
    %we just average amongst all the signals
    ndiEndPts=zeros(1,2);
    [~,maxCorrINdi]=max(mocapNdiXCorr,[],2);
    ndiEndPts(1)=round(median(maxCorrINdi),0);
    ndiEndPts(2)=ndiEndPts(1)+numMocapPts-1;
    
    captureInfo.ndiStart=ndiEndPts(1);
    captureInfo.ndiStop=ndiEndPts(2);
    
    if nargout > 2
        %doing the above procedure with joints is a bit more tedious because we
        %need to resample the signal to be the same period as the mocap data

        %resample time and the appropriate signals
        jointsNewTime=0:mocapSamplingPeriod:captureInfo.joints.time(end);
        jointsPosScalarInterp=interp1(captureInfo.joints.time,captureInfo.joints.(cs).(linRigidBody).pose.position.scalar,jointsNewTime);
        jointsPosVectorInterp=interp1(captureInfo.joints.time,captureInfo.joints.(cs).(linRigidBody).pose.position.vector,jointsNewTime);
        jointsRotScalarInterp=interp1(captureInfo.joints.time,captureInfo.joints.(cs).(rotRigidBody).pose.rotation.scalar,jointsNewTime);
        jointsRotVectorInterp=interp1(captureInfo.joints.time,captureInfo.joints.(cs).(rotRigidBody).pose.rotation.vector,jointsNewTime);

        %difference in number of points between the resampled joints time and
        %the mocap time
        jointsNdiDiff=(length(jointsNewTime)-numMocapPts+1);

        %compute cross correlation but with the resampled signal
        mocapJointsXCorr=zeros(8,jointsNdiDiff);
        for n=1:jointsNdiDiff
            mocapJointsXCorr(1,n)=xcorr(captureInfo.mocap.(cs).(linRigidBody).pose.position.scalar,...
                jointsPosScalarInterp(n:n+numMocapPts-1),0,'coeff');
            for i=1:3
                mocapJointsXCorr(i+1,n)=xcorr(captureInfo.mocap.(cs).(linRigidBody).pose.position.vector(:,i),...
                    jointsPosVectorInterp(n:n+numMocapPts-1,i),0,'coeff');
            end
            mocapJointsXCorr(5,n)=xcorr(captureInfo.mocap.(cs).(rotRigidBody).pose.rotation.scalar,...
                jointsRotScalarInterp(n:n+numMocapPts-1),0,'coeff');
            for i=1:3
                mocapJointsXCorr(i+5,n)=xcorr(captureInfo.mocap.(cs).(rotRigidBody).pose.rotation.vector(:,i),...
                    jointsRotVectorInterp(n:n+numMocapPts-1,i),0,'coeff');
            end
        end

        %same for joints but again we have to account for the fact that the
        %index that we want to output now needs to be back in the original
        %joints sampling period
        jointsEndPts=zeros(1,2);
        [~,maxCorrIJoints]=max(mocapJointsXCorr,[],2);
        startIdxJoints=round(median(maxCorrIJoints),0);
        jointsEndPts(1)=determineOffsetIndex(captureInfo.joints.time,jointsNewTime(startIdxJoints));
        jointsEndPts(2)=determineOffsetIndex(captureInfo.joints.time,jointsNewTime(startIdxJoints+numMocapPts-1));
    end
end