function newFile=alterFileName(directory,c3dFile, newFileName)
    trialDescription = extractBefore(c3dFile,'._V3D');
    nFileName=strcat(trialDescription, newFileName);
    newFile=fullfile(directory,nFileName);
end