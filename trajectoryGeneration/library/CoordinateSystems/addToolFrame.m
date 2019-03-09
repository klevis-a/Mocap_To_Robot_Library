function framesT=addToolFrame(frames,toolframe)
    numFrames=size(frames,3);
    framesT=zeros(4,4,numFrames);
    for i=1:numFrames
        framesT(:,:,i)=squeeze(frames(:,:,i))*toolframe;
    end
end