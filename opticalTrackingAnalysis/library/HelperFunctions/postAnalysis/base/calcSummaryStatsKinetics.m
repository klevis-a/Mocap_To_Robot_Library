function folderStats=calcSummaryStatsKinetics(folderStats)
    folderStats=calcPostAnalysisStatsKinetics(folderStats, 'axialForce');
    folderStats=calcPostAnalysisStatsKinetics(folderStats, 'bendingMoment');
    folderStats=calcPostAnalysisStatsKinetics(folderStats, 'axialMoment');
end