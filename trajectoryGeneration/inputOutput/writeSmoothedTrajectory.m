function writeSmoothedTrajectory(smoothFrames,period,file)
    numFrames=size(smoothFrames,3);
    
    %create a vector the time between each frame and the first frame, it
    %should look like 0 period period period ...
    tb=ones(numFrames-1,1)*period;
    tb=[0;tb];
    
    %write to file
    writeFramesFile(tb,smoothFrames,file);
end