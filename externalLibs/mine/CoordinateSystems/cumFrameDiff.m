function [framesDx,framesDxActive] = cumFrameDiff(frames)
    %computes both the active vector linear combination difference - see my
    %lab notebook for differences. Note that this function cumputes the
    %cumulative difference, not the difference between each frame but the
    %difference of each frame from the initial frame
    numFrames=size(frames,3);
    framesDx = zeros(4,4,numFrames-1);
    framesDxActive = zeros(4,4,numFrames-1);
    initFrameInverse = zeros(4,4);
    for i=1:numFrames
        if i>1
            framesDx(:,:,i-1)=initFrameInverse*squeeze(frames(:,:,i));
            framesDxActive(:,:,i-1)=squeeze(frames(:,:,i))*initFrameInverse;
        else
            initFrameInverse = htInverse(squeeze(frames(:,:,i)));
        end
    end
end