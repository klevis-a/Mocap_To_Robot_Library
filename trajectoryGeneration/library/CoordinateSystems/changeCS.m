function framesT=changeCS(frames,T)
    numFrames=size(frames,3);
    framesT=zeros(4,4,numFrames);
    for i=1:numFrames
        framesT(:,:,i)=T*squeeze(frames(:,:,i));
    end
end