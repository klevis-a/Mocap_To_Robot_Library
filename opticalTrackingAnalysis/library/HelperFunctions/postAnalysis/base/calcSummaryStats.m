function folderStats=calcSummaryStats(folderStats)
    %pose
    folderStats=calcPostAnalysisStats(folderStats, {'pose','position'});
    folderStats=calcPostAnalysisStats(folderStats, {'pose','rotation'});
    folderStats=calcPostAnalysisStats(folderStats, {'pose','euler','yxz'});
    %velocity
    folderStats=calcPostAnalysisStats(folderStats, {'velocity','linear'});
    folderStats=calcPostAnalysisStats(folderStats, {'velocity','angular'});
    folderStats=calcPostAnalysisStats(folderStats, {'velocity','euler','yxz'});
    %acceleration
    folderStats=calcPostAnalysisStats(folderStats, {'acceleration','linear'});
    folderStats=calcPostAnalysisStats(folderStats, {'acceleration','angular'});
    folderStats=calcPostAnalysisStats(folderStats, {'acceleration','euler','yxz'});

    %pose
    folderStats=determineOutliers(folderStats, {'pose','position'});
    folderStats=determineOutliers(folderStats, {'pose','rotation'});
    folderStats=determineOutliers(folderStats, {'pose','euler','yxz'});
    %velocity
    folderStats=determineOutliers(folderStats, {'velocity','linear'});
    folderStats=determineOutliers(folderStats, {'velocity','angular'});
    folderStats=determineOutliers(folderStats, {'velocity','euler','yxz'});
    %acceleration
    folderStats=determineOutliers(folderStats, {'acceleration','linear'});
    folderStats=determineOutliers(folderStats, {'acceleration','angular'});
    folderStats=determineOutliers(folderStats, {'acceleration','euler','yxz'});
end