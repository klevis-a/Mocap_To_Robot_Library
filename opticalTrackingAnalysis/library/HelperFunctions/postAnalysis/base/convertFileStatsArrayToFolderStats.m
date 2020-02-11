function folderStats=convertFileStatsArrayToFolderStats(fileStatsCellArray,poseCsRbs,velCsRbs,accCsRbs)
    folderStats=createSummaryStruct();
    
    for j=1:size(fileStatsCellArray,1)
        folderStats.programNames{j}=fileStatsCellArray{j}.programName;
        
        %Position Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'pose','position'},poseCsRbs,j);

        %Orientation Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'pose','rotation'},poseCsRbs,j);

        %Euler Angle Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'pose','euler', 'yxz'},poseCsRbs,j);

        %Linear Velocity Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'velocity','linear'},velCsRbs,j);

        %Rotational Velocity Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'velocity','angular'},velCsRbs,j);

        %Euler Angle Rate Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'velocity','euler', 'yxz'},velCsRbs,j);

        %Acceleration Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'acceleration','linear'},accCsRbs,j);

        %Angular Acceleration Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'acceleration','angular'},accCsRbs,j);

        %Euler Angle Acceleration Statistics
        folderStats=transferFileStatsToSummary(folderStats,fileStatsCellArray{j},{'acceleration','euler', 'yxz'},accCsRbs,j);
    end
end