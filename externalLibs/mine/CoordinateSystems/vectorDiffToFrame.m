function frameDiff = vectorDiffToFrame(v)
    %converts a vector difference into a frame difference. This is the
    %reverse operation of frameToVectorDiff.m
    numVectorDiffs=size(v,1);
    frameDiff=zeros(4,4,numVectorDiffs);
    for i=1:numVectorDiffs
        pos = v(i,1:3);
        orient = v(i,4:6);
        orientM = norm(orient);
        orientU = [0 0 1];
        if(orientM ~= 0)
            orientU = orient/norm(orient);
        end
        orientAxang = [orientU orientM];
        rotm = axang2rotm(orientAxang);
        frameDiff(:,:,i)=ht(rotm,pos);
    end
end