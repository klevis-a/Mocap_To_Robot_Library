function [proximal,distal,rotationM,rotv]=extractComponents(frames,frameDiff,humerusL)
    %proximal humeral position normalized by starting position
    proximal=squeeze(frames(1:3,4,:)-frames(1:3,4,1))';
    %distal humeral position
    distal=(proximal-squeeze(frames(1:3,3,:))'*humerusL);
    %rotation matrix
    rotationM=frameDiff(1:3,1:3,:);
    %rotation vector
    vectordx=frameToVectorDiff(frameDiff);
    rotv=vectordx(:,4:6);
end