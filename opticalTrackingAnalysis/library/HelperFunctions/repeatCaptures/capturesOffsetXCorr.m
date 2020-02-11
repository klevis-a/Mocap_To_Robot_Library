function offsetArray=capturesOffsetXCorr(capture1,capture2)
    offsetArray=zeros(1,6);
    for n=1:3
        offsetArray(n)=capturesOffsetXCorrPos(capture1,capture2,n);
        offsetArray(n+3)=capturesOffsetXCorrRot(capture1,capture2,n);
    end
end