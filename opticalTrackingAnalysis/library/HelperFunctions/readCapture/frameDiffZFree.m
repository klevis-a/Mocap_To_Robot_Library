function frameDiff = frameDiffZFree(ndiFirstFrame,mocapFirstFrame)
    %first find the rotation matrix that separates them
    R = mocapFirstFrame*ndiFirstFrame';
    %now remove the z rotation
    %first take the xaxis and rotate it using the given rotation - note
    %that we choose the xaxis here because it's in the plane of the
    %rotation. The yaxis could work just as well
    xaxis=[1 0 0];
    xaxisRot=R*xaxis';
    %project the rotated vector onto the xy plane
    xaxisRot(3)=0;
    xaxisRot = xaxisRot/norm(xaxisRot);
    %the rotation angle is then simply the dot product of the two vectors
    rotAngle=acos(dot(xaxis,xaxisRot));
    %now determine if the rotation angle is positive or negative
    multiplier=1;
    if xaxisRot(2)<0
        multiplier=-1;
    end
    rotAngle=multiplier*rotAngle;
    %using the calculated z-rotation calculate the rotation between the two
    %frames
    frameDiff=axang2rotm([0 0 1 rotAngle]);
end