function [frames,smoothFrames,ndiTime]=processNdiFrames(ndiFile,opto_to_robot,ndiSamplingPeriod,filterFunction)
    %read the file and fill in gaps if necessary
    [ndiFrameIndex,data,numRigidBodies]=readNDI6D(ndiFile);
    if numRigidBodies>1
        [ndiPos,ndiOrient]=fillGaps(ndiFrameIndex,data,numRigidBodies);
    else
        ndiPos=data(:,1:3);
        ndiOrient=quat2rotm(data(:,4:7));
    end
    
    %add an additional 0.2 seconds of stationary values - these could be used
    %for cross correlation purposes
    numSamplesIn1Sec=round(0.2/ndiSamplingPeriod,0);
    ndiPos(end+1:end+numSamplesIn1Sec,:)=repmat(ndiPos(end,:),numSamplesIn1Sec,1);
    ndiOrient(:,:,end+1:end+numSamplesIn1Sec)=repmat(ndiOrient(:,:,end),1,1,numSamplesIn1Sec);
    ndiFrameIndex(end+1:end+numSamplesIn1Sec)=ndiFrameIndex(end)+(1:numSamplesIn1Sec);
    
    %convert position to meters since toolframe is in meters
    ndiPos=ndiPos/1000;
    
    %now create the frames
    numFrames=size(ndiPos,1);
    frames=zeros(4,4,numFrames);
    for i=1:numFrames
        ndiFrame=ht(squeeze(ndiOrient(:,:,i)),ndiPos(i,:));
        frames(:,:,i)=opto_to_robot*ndiFrame;
    end

    smoothFrames = smoothTrajectory(frames,filterFunction,0);
    ndiTime=(ndiFrameIndex-1)*ndiSamplingPeriod;
end