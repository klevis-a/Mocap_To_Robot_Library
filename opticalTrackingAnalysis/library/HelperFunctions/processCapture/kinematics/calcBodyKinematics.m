function axialVectorBody=calcBodyKinematics(axialVector,frames)
    numFrames=size(frames,3);
    axialVectorBody = zeros(numFrames,3);
    for n=1:numFrames
        %express axial vector with respect to body frame
        axialVectorBody(n,:) = squeeze(frames(1:3,1:3,n))'*axialVector(n,:)';
    end
end