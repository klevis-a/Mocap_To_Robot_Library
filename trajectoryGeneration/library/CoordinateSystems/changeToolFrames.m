function processedFrames=changeToolFrames(frames,currentToolFrame,newToolFrame)
    processedFrames=addToolFrame(frames,htInverse(currentToolFrame)*newToolFrame);
end