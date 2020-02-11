function frames=compressRepeatCaptures(allCaptures)
    %first determine offsets
    offsets=zeros(length(allCaptures),1);
    offsets(1)=0;
    for n=2:length(allCaptures)
        offsetArray=capturesOffsetXCorr(allCaptures(1),allCaptures(n))
        offsets(n)=mode(offsetArray);
    end

    %shift all offsets so we start at 0, this avoids negative indices
    %and add 1 so we are correctly indexing according to Matlab
    minOffset=min(offsets);
    offsets=offsets-minOffset+1;
    
    %determine length of sequence - start with a guess that's fairly large and
    %just make sure you don't exceed the max
    captureLength = length(allCaptures(1).ndi.time);
    numPoints = captureLength-max(offsets)+1;

    %array that will allow us to perform the quaternion average
    quatAll=zeros(length(allCaptures),4,numPoints);
    %array for computing position average
    posAll=zeros(length(allCaptures),3,numPoints);
    for n=1:length(allCaptures)
        quatAll(n,:,:)=allCaptures(n).ndi.robot.hs.pose.quaternion(offsets(n):offsets(n)+numPoints-1,:)';
        posAll(n,:,:)=allCaptures(n).ndi.robot.hs.pose.position.vector(offsets(n):offsets(n)+numPoints-1,:)';
    end

    quatAvg=zeros(numPoints,4);
    posAvg=zeros(numPoints,3);
    for i=1:numPoints
        quatAvg(i,:)=wavg_quaternion_markley(squeeze(quatAll(:,:,i)), ones(length(allCaptures),1));
        posAvg(i,:)=mean(squeeze(posAll(:,:,i)),1);
    end

    frames=createFrames(posAvg,quat2rotm(quatAvg));
end