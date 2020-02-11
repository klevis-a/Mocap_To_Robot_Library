function allFolderStats=determineOutliers(allFolderStats,measure)
    statsStruct=getfield(allFolderStats,measure{:});
    statsStruct.outliers.max=findOutliers(allFolderStats.programNames,statsStruct.max);
    statsStruct.outliers.mean=findOutliers(allFolderStats.programNames,statsStruct.mean);
    statsStruct.outliers.median=findOutliers(allFolderStats.programNames,statsStruct.median);
    statsStruct.outliers.rms=findOutliers(allFolderStats.programNames,statsStruct.rms);
    statsStruct.outliers.span=findOutliers(allFolderStats.programNames,statsStruct.span);
    statsStruct.outliers.percentage.max=findOutliers(allFolderStats.programNames,statsStruct.percentage.max);
    statsStruct.outliers.percentage.rms=findOutliers(allFolderStats.programNames,statsStruct.percentage.rms);
    statsStruct.outliers.percentage.mean=findOutliers(allFolderStats.programNames,statsStruct.percentage.mean);
    statsStruct.outliers.percentage.median=findOutliers(allFolderStats.programNames,statsStruct.percentage.median);
    allFolderStats=setfield(allFolderStats,measure{:},statsStruct);
end
