function allCaptures=readRepeatCaptures(programName,postAnalysisResultsFolder,captureFiles,samplingPeriods,robotI,numRepeats,kinOpts,filterFunctions)
    %process the capture
    captureInfo.programName = programName;
    captureInfo=readCapture(captureInfo,captureFiles,samplingPeriods,robotI,filterFunctions);
    %we must calculate kinematics now (and later) because they are needed
    %to average the captures later
    captureInfo=calcAllKinematics(captureInfo,captureInfo.sources,captureInfo.referenceCS,captureInfo.rigidBodies,kinOpts);
    allCaptures(1)=captureInfo;

    %set the new folder, should now have a _repeat added to it
    postAnalysisResultsFolder=strcat(postAnalysisResultsFolder, '_repeat');

    %now process the rest of the captures
    for n=1:numRepeats
        %set the program name in the newCaptureInfo
        newCaptureInfo=struct;
        newCaptureInfo.programName=programName;
        %update the capture files as well
        captureFiles.ndiFile=ndiFile(postAnalysisResultsFolder,newCaptureInfo.programName);
        [fPath,fName,fExt]=fileparts(captureFiles.ndiFile);
        captureFiles.ndiFile=fullfile(fPath,strcat(fName,'_',num2str(n),fExt));
        captureFiles.jointsFile=capturedJointsFile(postAnalysisResultsFolder,newCaptureInfo.programName);
        [fPath,fName,fExt]=fileparts(captureFiles.jointsFile);
        captureFiles.jointsFile=fullfile(fPath,strcat(fName,'_',num2str(n),fExt));
        %process the capture and store it
        newCaptureInfo=readCapture(newCaptureInfo,captureFiles,samplingPeriods,robotI,filterFunctions);
        %we must calculate kinematics now (and later) because they are needed
        %to average the captures later
        newCaptureInfo=calcAllKinematics(newCaptureInfo,newCaptureInfo.sources,newCaptureInfo.referenceCS,newCaptureInfo.rigidBodies,kinOpts);
        allCaptures(n+1)=newCaptureInfo;
    end
end