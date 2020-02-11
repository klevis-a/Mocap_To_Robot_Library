function sseFile=subsamplingErrorsFileName(directory,c3dFile,ssMethod)
    if ssMethod==0
        sseFile=alterFileName(directory,c3dFile, '.ssErrorsUniform.txt');
    else
        sseFile=alterFileName(directory,c3dFile, '.ssErrors.txt');
    end
end