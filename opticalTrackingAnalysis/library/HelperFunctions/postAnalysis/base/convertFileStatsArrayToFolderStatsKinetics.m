function folderStats=convertFileStatsArrayToFolderStatsKinetics(fileStatsCellArray)
    folderStats=createSummaryStructKinetics();
    for j=1:size(fileStatsCellArray,1)
        folderStats.programNames{j}=fileStatsCellArray{j}.programName;
        
        %axial force statistics
        folderStats.axialForce=transferFileStatsToSummaryKinetics(folderStats.axialForce,{'axialForce'},fileStatsCellArray{j},j);
        %bending moment statistics
        folderStats.bendingMoment=transferFileStatsToSummaryKinetics(folderStats.bendingMoment,{'bendingMoment'},fileStatsCellArray{j},j);
        folderStats.thorax.bendingMoment=transferFileStatsToSummaryKinetics(folderStats.thorax.bendingMoment,{'thorax','bendingMoment'},fileStatsCellArray{j},j);
        %axial moment statistics
        folderStats.axialMoment=transferFileStatsToSummaryKinetics(folderStats.axialMoment,{'axialMoment'},fileStatsCellArray{j},j);
    end
    
    for n=1:4
        tempForcesStruct=struct;
        tempMomentsStruct=struct;
        for j=1:size(fileStatsCellArray,1)
            tempForcesStruct=transferFileStatsToSummaryKinetics(tempForcesStruct,{'forces'},fileStatsCellArray{j},j,n);
            tempMomentsStruct=transferFileStatsToSummaryKinetics(tempMomentsStruct,{'moments'},fileStatsCellArray{j},j,n);
        end
        %forces statistic
        folderStats.forces(n)=tempForcesStruct;
        %moments statistic
        folderStats.moments(n)=tempMomentsStruct;
    end
end