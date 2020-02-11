function [framesSmooth,errorsP,errorsO]=smoothAndPlot(proximal,orient,period,plotBool,varargin)
    %create frames from rotation matrix and proximal position
    frames=createFrames(proximal,orient);
    
    %smooth the data
    if nargin>4
        gauss_interval=varargin{1};
        padLength=varargin{2};
        padRemoval=varargin{3};
    else
        gauss_interval=15;
        padLength=10;
        padRemoval=3;
    end
    
    %create gaussian smoothing function and use it to smooth
    smoothDataFunction = @(x) smoothdata(x,'gaussian',gauss_interval);
    [framesSmooth,diffV,diffVSmooth,fDiff,fDiffSmooth]=smoothTrajectory(frames,smoothDataFunction,padLength);

    %removing padding
    [diffV,diffVSmooth,fDiff,fDiffSmooth,framesSmooth]=removePadding(diffV,diffVSmooth,fDiff,fDiffSmooth,framesSmooth,padRemoval);

    %convert to mm and degrees
    diffmd=tommdeg(diffV);
    diffsmoothmd=tommdeg(diffVSmooth);
    diffBetween=diffmd-diffsmoothmd;
    
    %compute errors
    diffBPos=diffBetween(:,1:3);
    diffBOrient=diffBetween(:,4:6);
    diffBPosS=sqrt(dot(diffBPos,diffBPos,2));
    diffBOrientS=sqrt(dot(diffBOrient,diffBOrient,2));
    [errorsP,errorsO]=computeSmoothingErrors(diffBPosS,diffBOrientS);
    
    %plot if needed
    if plotBool
        plotSmoothTraj(diffmd,diffsmoothmd,fDiff,fDiffSmooth,diffBPosS,diffBOrientS,errorsP,errorsO,period);
    end
end
