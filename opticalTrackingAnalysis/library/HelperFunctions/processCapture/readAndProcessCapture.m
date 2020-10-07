function captureInfo=readAndProcessCapture(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisFile,filterFunctions)
    %read input file - this has information regarding the capture that was
    %recorded while running processNdiCapture.m
    [postAnalysisResultsFolder,fileName,fileExt]=fileparts(postAnalysisFile);
    captureInfo.programName=extractBefore(strcat(fileName,fileExt), '_sum.txt');
    inputFile = fullfile(postAnalysisResultsFolder,strcat(captureInfo.programName,'.csv'));
    captureInfo.inputTable = readtable(inputFile);
    %this is a 1x1 table
    c3dFile = captureInfo.inputTable{1,'c3dFile'};

    %capture files
    captureFiles.postAnalysisResultsFolder=postAnalysisResultsFolder;
    captureFiles.ndiFile=ndiFile(postAnalysisResultsFolder,captureInfo.programName);
    captureFiles.c3dFile=fullfile(postAnalysisDataFolder, c3dFile{1});
    captureFiles.transformFile=transformationFile(postAnalysisResultsFolder);
    captureFiles.jointsFile=capturedJointsFile(postAnalysisResultsFolder,captureInfo.programName);

    %process the capture
    captureInfo=readCapture(captureInfo,captureFiles,samplingPeriods,robotI,filterFunctions);
    
    %before proceeding we should fix the position of the bone as described
    %by NDI. Because of the noise added by the rotation component we can
    %simply compute the position from the mocap data (i.e. assume that the
    %rotation was perfect)
%     mocapBoneQuat=rotm2quat(captureInfo.mocap.lab.bone.pose.frames(1:3,1:3,:));
%     ndiBoneQuat=rotm2quat(captureInfo.ndi.lab.bone.pose.frames(1:3,1:3,:));
%     [~,warpPath] = dtwK(mocapBoneQuat',ndiBoneQuat',@quatDistance);
%     TBtoH=htInverse(robotI.HStoolframe)*robotI.toolframe;
%     for n=1:size(captureInfo.ndi.lab.bone.pose.frames,3)
%         warpPathInd=find(warpPath(:,2)==n);
%         quatAvg=quatWAvgMarkley(mocapBoneQuat(warpPath(warpPathInd,1),:), ones(length(warpPathInd),1));
%         captureInfo.ndi.lab.bone.pose.frames(1:3,4,n)=...
%             quat2rotm(quatAvg')*TBtoH(1:3,1:3)'*TBtoH(1:3,4)+captureInfo.ndi.lab.hs.pose.frames(1:3,4,n);
%     end
%     captureInfo.ndi.lab.bone.pose.frames=normalizeFrameDisplacements(captureInfo.ndi.lab.bone.pose.frames);
    
    %calculate other useful reference frames
    captureInfo=addThoraxCS(captureInfo,captureFiles.c3dFile,samplingPeriods.mocapSamplingPeriod);
    captureInfo=addEigenPosCS(captureInfo);
    %captureInfo=addEigenRotCS(captureInfo);
    
    %calculate kinematics for all current sources and coordinate sytems
    kinOpts.zeroRot=1;
    captureInfo=calcAllKinematics(captureInfo,captureInfo.sources,captureInfo.referenceCS,captureInfo.rigidBodies,kinOpts);
    captureInfo=calcAllBodyKinematics(captureInfo);
    captureInfo.kinetics=calcAllKinetics(captureInfo);
end