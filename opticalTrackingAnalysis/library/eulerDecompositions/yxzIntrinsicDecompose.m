function eul=yxzIntrinsicDecompose(rotMat) 
    numFrames=size(rotMat,3); 
    eul=zeros(numFrames,3); 
    for n=1:numFrames 
        if(rotMat(2,3,n) < 1) 
            if(rotMat(2,3,n)>-1) 
                eul(n,2)=asin(-rotMat(2,3,n)); 
                eul(n,1)=atan2(rotMat(1,3,n),rotMat(3,3,n)); 
                eul(n,3)=atan2(rotMat(2,1,n),rotMat(2,2,n)); 
            else 
                eul(n,2)=pi/2; 
                eul(n,1)=-atan2(-rotMat(1,2,n),rotMat(1,1,n)); 
                eul(n,3)=0; 
            end 
        else 
                eul(n,2)=-pi/2; 
                eul(n,1)=atan2(-rotMat(1,2,n),rotMat(1,1,n)); 
                eul(n,3)=0; 
        end 
    end 
end