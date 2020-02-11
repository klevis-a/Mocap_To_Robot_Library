function captureInfo=embellishRepeatCapture(ndiHSFrames, initCaptureInfo, robotI)
    captureInfo.activity=initCaptureInfo.activity;
    captureInfo.programName=initCaptureInfo.programName;
    %toolframes
    bonetoolframe=robotI.HumerusToolframe;
    hstoolframe=robotI.HSToolframe;
    
    %determine the transformation matrix that will allow us to transform from
    %optotrak to robot coordinate systems
    captureInfo.transformations.ndi.OtoR=initCaptureInfo.transformations.ndi.OtoR;
    
    %read the original frames (before smoothing)
    captureInfo.startEndIndices = initCaptureInfo.startEndIndices;
    captureInfo.mocapO.lab.bone.pose.frames = initCaptureInfo.mocapO.lab.bone.pose.frames;
    captureInfo.mocapO.time = initCaptureInfo.mocapO.time;

    %first read the smooth frames file - bone frames in lab CS
    captureInfo.mocap.lab.hs.pose.frames = initCaptureInfo.mocap.lab.hs.pose.frames;
    mocapHSFrames = captureInfo.mocap.lab.hs.pose.frames;
    captureInfo.mocap.lab.bone.pose.frames = initCaptureInfo.mocap.lab.bone.pose.frames;
    mocapBoneFrames = captureInfo.mocap.lab.bone.pose.frames;
    captureInfo.mocap.time = initCaptureInfo.mocap.time;

    %now read the NDI capture - hemisphere frames in robot CS then compute the
    %bone frames
    ndiBoneFrames=changeToolFrames(ndiHSFrames,hstoolframe,bonetoolframe);
    captureInfo.ndi.robot.hs.pose.frames=normalizeFrameDisplacements(ndiHSFrames);
    captureInfo.ndi.robot.bone.pose.frames=normalizeFrameDisplacements(ndiBoneFrames);
    captureInfo.ndi.time = initCaptureInfo.ndi.time(1:size(ndiHSFrames,3));
    
    %now calculate transformation from robot to lab CS
    %aligning jogging is best done with the last frame since the hemisphere
    %is closer to optotrak
    if captureInfo.activity==Activities.JO_free
        fDiff=orthoNormalProject(frameDiffZFree(ndiHSFrames(1:3,1:3,end),mocapHSFrames(1:3,1:3,end)));
    else
        fDiff=orthoNormalProject(frameDiffZFree(ndiHSFrames(1:3,1:3,1),mocapHSFrames(1:3,1:3,1)));
    end
    
    captureInfo.transformations.ndi.RtoL=ht(fDiff,[0 0 0]);
    captureInfo.transformations.ndi.LtoR=htInverse(captureInfo.transformations.ndi.RtoL);
    captureInfo.ndi.lab.hs.pose.frames=normalizeFrameDisplacements(changeCS(ndiHSFrames,captureInfo.transformations.ndi.RtoL));
    captureInfo.ndi.lab.bone.pose.frames=normalizeFrameDisplacements(changeCS(ndiBoneFrames,captureInfo.transformations.ndi.RtoL));
    
    captureInfo.mocap.robot.hs.pose.frames=normalizeFrameDisplacements(changeCS(mocapHSFrames,captureInfo.transformations.ndi.LtoR));
    captureInfo.mocap.robot.bone.pose.frames=normalizeFrameDisplacements(changeCS(mocapBoneFrames,captureInfo.transformations.ndi.LtoR));
    
    captureInfo.sources = {'mocap','mocapO','ndi'};
    
    captureInfo.referenceCS = {'robot','lab'};
    captureInfo.rigidBodies = {'hs','bone'};
end