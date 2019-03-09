function frames=createFrames(proximal,orientation)
    numFrames=size(orientation,3);
    frames=zeros(4,4,numFrames);
    for n=1:numFrames
        frames(:,:,n)=ht(squeeze(orientation(:,:,n)),proximal(n,:));
    end
end
