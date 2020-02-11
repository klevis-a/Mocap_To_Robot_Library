function [errorS,errorX,errorY]=checkErrorUsingJoints(joints,smoothFrames,robot,base,ee,toolframe)    
    %create frames using given joints
    framesJoints=createFramesFromJoints(robot,base,ee,joints);
    framesJoints=addToolFrame(framesJoints,toolframe);
    
    %compute differences between frames
    [jointFramesDx,~]=cumFrameDiff(framesJoints);
    [smoothFramesDx,~]=cumFrameDiff(smoothFrames);
    
    %convert to vector form
    jointsDx = frameToVectorDiff(jointFramesDx);
    smoothDx = frameToVectorDiff(smoothFramesDx);
    
    %find the scalar difference between the two
    difference = jointsDx-smoothDx;
    errorS = sum(dot(difference,difference,2));
    
    %find the differences in the initial orientation about x and y
    initFrameJoints = squeeze(framesJoints(:,:,1));
    initFrameSmooth = squeeze(smoothFrames(:,:,1));
    
    %now find differences in orientation between the two
    initDiff=initFrameJoints(1:3,1:3)*initFrameSmooth(1:3,1:3)';
    diffAxAng = quat2axang(rotm2quat(initDiff));
    errorX = dot(diffAxAng(1:3), [1 0 0]);
    errorY = dot(diffAxAng(1:3), [0 1 0]);
end
