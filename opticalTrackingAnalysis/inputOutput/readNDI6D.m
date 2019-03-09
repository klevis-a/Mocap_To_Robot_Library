function [frameNum,data,numRigidBodies]=readNDI6D(file)
    %read the file
    content=csvread(file,1,0);
    %determine number of columns and make sure that it conforms to
    %expectations
    numColumns=size(content,2);
    numRows=size(content,1);
    assert(numColumns>1 && mod(numColumns,7)==1);
    %determine number of rigid bodies
    numRigidBodies = (numColumns-1)/7;
    
    data = zeros(numRows,7,numRigidBodies);
    for n=1:numRigidBodies
        data(:,:,n) = content(:,2+(n-1)*7:8+(n-1)*7);
    end
    frameNum=content(:,1);
end