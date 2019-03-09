function [sFrames,diffV,diffVSmooth,fDiff,fDiffSmooth]=smoothTrajectory(frames,varargin)
    %establish the smoothing interval
    gauss_interval=15;
    padLength=10;
    if nargin>1
        gauss_interval=varargin{1};
        if nargin>2
            padLength=varargin{2};
        end
    end
    
    %create frame differences, and vector differences
    [fDiff,~]=cumFrameDiff(frames);
    fDiff = cat(3,repmat(eye(4),1,1,padLength),fDiff,repmat(squeeze(fDiff(:,:,end)),1,1,padLength));
    diffV=frameToVectorDiff(fDiff);
    
    %smooth the position and orientation differences
    diffVSmooth = smoothData(diffV, gauss_interval);
    
    %convert the smoothed differences back to frames
    fDiffSmooth = vectorDiffToFrame(diffVSmooth);
    
    %add the frame differences back to the original
    sFrames = createFrameTrajectory(squeeze(frames(:,:,1)), fDiffSmooth);
end
