function [frames,smoothFrames,ndiTime]=processNdiFrames(ndiFile,opto_to_robot,ndiSamplingPeriod)
    %read the file and fill in gaps if necessary
    [ndiFrameIndex,data,numRigidBodies]=readNDI6D(ndiFile);
    if numRigidBodies>1
        [ndiPos,ndiOrient]=fillGaps(ndiFrameIndex,data,numRigidBodies);
    else
        ndiPos=data(:,1:3);
        ndiOrient=quat2rotm(data(:,4:7));
    end
    
    %convert position to meters since toolframe is in meters
    ndiPos=ndiPos/1000;
    
    %now create the frames
    numFrames=size(ndiPos,1);
    frames=zeros(4,4,numFrames);
    for i=1:numFrames
        ndiFrame=ht(squeeze(ndiOrient(:,:,i)),ndiPos(i,:));
        frames(:,:,i)=opto_to_robot*ndiFrame;
    end
    
    smoothFrames = smoothTrajectory(frames,15,0);
    ndiTime=(ndiFrameIndex-1)*ndiSamplingPeriod;
end