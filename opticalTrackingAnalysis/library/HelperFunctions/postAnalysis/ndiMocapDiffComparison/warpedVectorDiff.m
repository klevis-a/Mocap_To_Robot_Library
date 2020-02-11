function vectorDiff=warpedVectorDiff(mocapData,ndiData,warpPath)
    vectorDiff=mocapData(warpPath(:,1),:)-ndiData(warpPath(:,2),:);
end