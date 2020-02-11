function [captureInfoInit,captureInfoAvg]=readAndProcessRepeatCaptures(samplingPeriods,robotI,postAnalysisDataFolder,postAnalysisResultsFile,postAnalysisRepeatsAvail,filterFunctions)
    kinOpts.zeroRot=1;
    
    %extract file information
    [postAnalysisResultsFolder,fileName,fileExt]=fileparts(postAnalysisResultsFile);
    programName=extractBefore(strcat(fileName,fileExt), '_sum.txt');
    inputFile = fullfile(postAnalysisResultsFolder,strcat(programName,'.csv'));
    inputTable = readtable(inputFile);
    c3dFile = inputTable{1,'c3dFile'};

    %capture files
    captureFiles.ndiFile=ndiFile(postAnalysisResultsFolder,programName);
    captureFiles.c3dFile=fullfile(postAnalysisDataFolder, c3dFile{1});
    captureFiles.transformFile=transformationFile(postAnalysisResultsFolder);
    captureFiles.jointsFile=capturedJointsFile(postAnalysisResultsFolder,programName);
    captureFiles.postAnalysisResultsFolder=postAnalysisResultsFolder;
    
    %read all captures
    allCaptures=readRepeatCaptures(programName,postAnalysisResultsFolder,captureFiles,samplingPeriods,robotI,postAnalysisRepeatsAvail,kinOpts,filterFunctions);
    %single out the first one since it's one that we know works
    captureInfoInit=allCaptures(1);
    captureInfoInit.inputTable=inputTable;
    
    %average the frames of the captures
    averagedFrames=compressRepeatCaptures(allCaptures);
    
    %now add all the extra bells and whistles that all regular captures
    %would have
    captureInfoAvg=embellishRepeatCapture(averagedFrames,captureInfoInit,robotI);
    
    %add thorax and eigenpos CS
    captureInfoAvg=addThoraxCS(captureInfoAvg,captureFiles.c3dFile,samplingPeriods.mocapSamplingPeriod);
    captureInfoAvg=addEigenPosCS(captureInfoAvg);
    captureInfoInit=addThoraxCS(captureInfoInit,captureFiles.c3dFile,samplingPeriods.mocapSamplingPeriod);
    captureInfoInit=addEigenPosCS(captureInfoInit);
    
    %calc kinematics
    captureInfoInit=calcAllKinematics(captureInfoInit,captureInfoInit.sources,captureInfoInit.referenceCS,captureInfoInit.rigidBodies,kinOpts);
    captureInfoAvg=calcAllKinematics(captureInfoAvg,captureInfoAvg.sources,captureInfoAvg.referenceCS,captureInfoAvg.rigidBodies,kinOpts);
    captureInfoInit=calcAllBodyKinematics(captureInfoInit);
    captureInfoAvg=calcAllBodyKinematics(captureInfoAvg);
end