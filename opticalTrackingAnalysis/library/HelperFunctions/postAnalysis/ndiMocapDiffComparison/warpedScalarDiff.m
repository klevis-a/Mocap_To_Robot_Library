function scalarDiff=warpedScalarDiff(mocapData,ndiData,warpPath)
    scalarDiff=mocapData(warpPath(:,1))-ndiData(warpPath(:,2));
end