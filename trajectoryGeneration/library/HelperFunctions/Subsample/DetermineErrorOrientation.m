function error=DetermineErrorOrientation(s_i,e_i,rotationM)
    %locations of previous two points
    s_p=rotationM(:,:,s_i);
    e_p=rotationM(:,:,e_i);
    %rotation matrix that allows to rotate between these two orientations
    R = e_p*s_p';
    %number of rotations between these two points
    numRotations = e_i-s_i;
    %convert rotation matrix to axis angle representation
    axangle = rotm2axang(R);
    %break it up into individual rotations
    indRotAngle = axangle(4)/numRotations;
    numRotVector = 1:numRotations;
    axangleRotations = repmat(axangle,numRotations,1);
    axangleRotations(:,4) = (numRotVector*indRotAngle)';
    rotations = axang2rotm(axangleRotations);
    
    error = zeros(1,numRotations-1);
    for n=1:numRotations-1
        linearProjection = squeeze(rotations(:,:,n))*s_p;
        actualQuatValue = rotm2quat(rotationM(:,:,s_i+n));
        projectedQuatValue = rotm2quat(linearProjection);
        error(n) = 1-dot(actualQuatValue,projectedQuatValue)^2;
        %this can be simplified to use the trace of the rotation matrix
        %this doesn't work for some reason - it gives negative numbers
        %rot=squeeze(rotationM(:,:,s_i+n))*linearProjection';
        %error(n)=trace(rot)*(-0.25)+0.75;
    end
end