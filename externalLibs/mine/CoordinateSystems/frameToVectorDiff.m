function vectorDiff = frameToVectorDiff(framesDx)
    %converts a frame difference into a 6 element vector, the first 3 are
    %the positional differences, the second 3 comprise the scaled axis of
    %rotation
    
    %the scaled axis of rotation is derived from the axis angle
    %representation. The axis angle representation is a 4-element vector,
    %the first 3 comprise the unit vector representing the axis of
    %rotation, while the 4th is the angle by which we rotate around this
    %axis. The scaled axis of rotation vector is a 3-element vector derived
    %by multiplying the axis angle unit vector by the axis angle rotation
    %angle
    numFrameDiffs=size(framesDx,3);
    vectorDiff=zeros(numFrameDiffs,6);
    for i=1:numFrameDiffs
        vectorDiff(i,1:3)=squeeze(framesDx(1:3,4,i));
        axangDiff = rotm2axang(squeeze(framesDx(1:3,1:3,i)));
        vectorDiff(i,4:6)=axangDiff(1:3).*axangDiff(4);
    end
end