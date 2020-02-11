function [pos,orient]=frameToEuler(frames)
    %converts homogeneous transformation matrices to XYZ extrinsic euler
    %angles
    numFrames=size(frames,3);
    pos=zeros(numFrames,3);
    orient=zeros(numFrames,3);
    for i=1:numFrames
        pos(i,:)=squeeze(frames(1:3,4,i));
        orient(i,:)=fliplr(rotm2eul(squeeze(frames(1:3,1:3,i))));
    end
end