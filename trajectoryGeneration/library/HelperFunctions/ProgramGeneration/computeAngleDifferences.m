function angleDiff=computeAngleDifferences(joints,robot,base,ee,toolframe)
    %create cartesian positions and add toolframe
    frames=createFramesFromJoints(robot,base,ee,joints);
    numFrames=size(frames,3);
    angleDiff=zeros(numFrames-1,1);
    for i=1:numFrames
        if i==1
            previousFrame=squeeze(frames(:,:,i))*toolframe;
            previousRotM=previousFrame(1:3,1:3);
        else
            currentFrame=squeeze(frames(:,:,i))*toolframe;
            currentRotM=currentFrame(1:3,1:3);
            rotDiff=rotm2axang(currentRotM*previousRotM');
            angleDiff(i-1)=abs(rad2deg(rotDiff(4)));
            previousRotM=currentRotM;
        end
    end
end
