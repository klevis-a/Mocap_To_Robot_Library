function frames=eulerToFrame(eulXYZ, trans)
    %converts XYZ extrinsic Euler angles to homogeneous frames
    numEulerPos=size(eulXYZ,1);
    frames=zeros(4,4,numEulerPos);
    for i=1:numEulerPos
        frames(:,:,i)=ht(eul2rotm(fliplr(eulXYZ(i,:))), trans(i,:));
    end
end