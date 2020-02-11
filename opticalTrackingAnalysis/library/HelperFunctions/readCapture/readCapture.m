function captureInfo=readCapture(captureInfo,captureFiles,samplingPeriods,robotI,filterFunctions)
    %determine the activity we are dealing with
    [~,c3dName,~]=fileparts(captureFiles.c3dFile);
    [~,activity,~] = fileNameParser(c3dName);
    captureInfo.activity=Activities.parse(activity);
    
    %toolframes
    bonetoolframe=robotI.HumerusToolframe;
    hstoolframe=robotI.HSToolframe;
    
    %check to see if we need to override the humerus toolframe
    toolframeFile = fullfile(captureFiles.postAnalysisResultsFolder,strcat(captureInfo.programName,'_toolframe.xml'));
    if isfile(toolframeFile)
        humerusToolFrame=xml2struct(toolframeFile);
        x=str2num(humerusToolFrame.HumerusToolframe.x.Text);
        y=str2num(humerusToolFrame.HumerusToolframe.y.Text);
        z=str2num(humerusToolFrame.HumerusToolframe.z.Text);
        w=str2num(humerusToolFrame.HumerusToolframe.w.Text);
        p=str2num(humerusToolFrame.HumerusToolframe.p.Text);
        r=str2num(humerusToolFrame.HumerusToolframe.r.Text);
        bonetoolframe=ht(eul2rotm(fliplr(deg2rad([w p r]))), [x/1000 y/1000 z/1000]);
    end
    
    %determine the transformation matrix that will allow us to transform from
    %optotrak to robot coordinate systems
    captureInfo.transformations.ndi.OtoR=optoToRobot(captureFiles.transformFile);
    
    %read the original frames (before smoothing)
    [proximal,orientation,~,startEndIndices,~]=readV3DExport(captureFiles.c3dFile,samplingPeriods.mocapSamplingPeriod);
    captureInfo.startEndIndices=startEndIndices;
    captureInfo.mocapO.lab.bone.pose.frames=normalizeFrameDisplacements(createFrames(proximal(startEndIndices(1):startEndIndices(2),:),...
        orientation(:,:,startEndIndices(1):startEndIndices(2))));
    captureInfo.mocapO.time = (0:(size(captureInfo.mocapO.lab.bone.pose.frames,3)-1))*samplingPeriods.mocapSamplingPeriod;

    %first read the smooth frames file - bone frames in lab CS
    [c3dPath,c3dName,c3dExt]=fileparts(captureFiles.c3dFile);
    mocapBoneFrames=readFramesFile(smoothFramesFileName(c3dPath,strcat(c3dName,c3dExt)));
    captureInfo.mocap.time=(0:(size(mocapBoneFrames,3)-1))*samplingPeriods.mocapSamplingPeriod;
    mocapHSFrames=changeToolFrames(mocapBoneFrames,bonetoolframe,hstoolframe);
    captureInfo.mocap.lab.hs.pose.frames=normalizeFrameDisplacements(mocapHSFrames);
    captureInfo.mocap.lab.bone.pose.frames=normalizeFrameDisplacements(mocapBoneFrames);

    %now read the NDI capture - hemisphere frames in robot CS then compute the
    %bone frames
    [~,ndiHSFrames,captureInfo.ndi.time]=processNdiFrames(captureFiles.ndiFile,captureInfo.transformations.ndi.OtoR,samplingPeriods.ndiSamplingPeriod,filterFunctions.ndi);
    ndiBoneFrames=changeToolFrames(ndiHSFrames,hstoolframe,bonetoolframe);
    captureInfo.ndi.robot.hs.pose.frames=normalizeFrameDisplacements(ndiHSFrames);
    captureInfo.ndi.robot.bone.pose.frames=normalizeFrameDisplacements(ndiBoneFrames);
    
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

    if(~isempty(captureFiles.jointsFile))
        %create empty structs
        captureInfo.joints = struct;
        captureInfo.joints.bone = struct;
        captureInfo.joints.hs = struct;

        [captureInfo.joints.time,captureInfo.robotJoints]=readCapturedJoints(captureFiles.jointsFile,samplingPeriods.jointsSamplingPeriod);
        %robot end effector frames in robot CS
        jointFrames = createFramesFromJoints(robotI.robot, robotI.base, robotI.ee, captureInfo.robotJoints);
        jointFrames = smoothTrajectory(jointFrames,filterFunctions.joints,0);
        %bone and hemisphere frames in robot CS
        jointsBoneFrames = addToolFrame(jointFrames,bonetoolframe);
        jointsHSFrames = addToolFrame(jointFrames,hstoolframe);
        captureInfo.joints.robot.hs.pose.frames=normalizeFrameDisplacements(jointsHSFrames);
        captureInfo.joints.robot.bone.pose.frames=normalizeFrameDisplacements(jointsBoneFrames);
        
        %now calculate transformation from robot to lab CS
        %aligning jogging is best done with the last frame since the hemisphere
        %is closer to optotrak
        if captureInfo.activity==Activities.JO_free
            fDiff=orthoNormalProject(frameDiffZFree(jointsBoneFrames(1:3,1:3,end),mocapBoneFrames(1:3,1:3,end)));
        else
            fDiff=orthoNormalProject(frameDiffZFree(jointsBoneFrames(1:3,1:3,1),mocapBoneFrames(1:3,1:3,1)));
        end
        captureInfo.transformations.joints.RtoL=ht(fDiff,[0 0 0]);
        captureInfo.joints.lab.hs.pose.frames=normalizeFrameDisplacements(changeCS(jointsHSFrames,captureInfo.transformations.joints.RtoL));
        captureInfo.joints.lab.bone.pose.frames=normalizeFrameDisplacements(changeCS(jointsBoneFrames,captureInfo.transformations.joints.RtoL));
        
        captureInfo.sources{end+1}='joints';
    end
    
    captureInfo.referenceCS = {'robot','lab'};
    captureInfo.rigidBodies = {'hs','bone'};
end