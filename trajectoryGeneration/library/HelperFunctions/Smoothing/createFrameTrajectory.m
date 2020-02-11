function frames=createFrameTrajectory(firstFrame,framesDx)
    numFramesDx=size(framesDx,3);
    frames = zeros(4,4,numFramesDx+1);
    frames(:,:,1)=firstFrame;
    for i=1:numFramesDx
        %note that we post-multiply by the frame here because the first
        %frame is considered our reference frame
        frames(:,:,i+1)=firstFrame*squeeze(framesDx(:,:,i));
    end
end