function [frameNum,data,numRigidBodies]=readFirstPrinciplesQuat(file)
    %read the file and remove columns of all zeros
    content=csvread(file,5,0);
    content=content(:,any(content));
    %determine number of columns and make sure that it conforms to
    %expectations
    numColumns=size(content,2);
    numRows=size(content,1);
    assert(numColumns>1 && mod(numColumns,8)==1);
    %determine number of rigid bodies
    numRigidBodies = (numColumns-1)/8;
    
    data = zeros(numRows,7,numRigidBodies);
    for n=1:numRigidBodies
        data(:,:,n) = content(:,2+(n-1)*8:8+(n-1)*8);
    end
    frameNum=content(:,1);
end