function linearDiff=computeLinearDifferences(joints,robot,base,ee,toolframe)
    %create cartesian positions and add toolframe
    frames=createFramesFromJoints(robot,base,ee,joints);
    numFrames=size(frames,3);
    linearDiff=zeros(numFrames-1,1);
    for i=1:numFrames
        if i==1
            previousFrame=squeeze(frames(:,:,i))*toolframe;
            previousDist=squeeze(previousFrame(1:3,4));
        else
            currentFrame=squeeze(frames(:,:,i))*toolframe;
            currentDist=squeeze(currentFrame(1:3,4));
            linDiff=currentDist-previousDist;
            linearDiff(i-1)=sqrt(dot(linDiff,linDiff))*1000;
            previousDist=currentDist;
        end
    end
end
