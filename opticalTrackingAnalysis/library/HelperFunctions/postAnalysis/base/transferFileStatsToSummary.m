function folderStats=transferFileStatsToSummary(folderStats,fileStats,measure,csRbInfo,fileNum)
    [cs,rb]=determineCsRb(measure);
    fileStatsStruct=getfield(fileStats.diff.mmdeg,measure{:});
    fileStatsStruct=fileStatsStruct.(csRbInfo.(cs)).(csRbInfo.(rb));
    mocapStruct=fileStats.mocap.(csRbInfo.(cs)).(csRbInfo.(rb)).mmdeg;
    mocapStruct=getfield(mocapStruct,measure{:});
    folderStatsStruct=getfield(folderStats,measure{:});
    
    folderStatsStruct.max(fileNum,:)=fileStatsStruct.max;
    folderStatsStruct.mean(fileNum,:)=fileStatsStruct.mean;
    folderStatsStruct.mae(fileNum,:)=fileStatsStruct.mae;
    folderStatsStruct.median(fileNum,:)=fileStatsStruct.median;
    folderStatsStruct.rms(fileNum,:)=fileStatsStruct.rms;
    folderStatsStruct.std(fileNum,:)=fileStatsStruct.std;
    folderStatsStruct.mad(fileNum,:)=fileStatsStruct.mad;
    folderStatsStruct.topMax(fileNum,:)=fileStatsStruct.topMax(:);
    folderStatsStruct.maxI(fileNum,:)=[fileStatsStruct.maxI(1,:) fileStatsStruct.maxI(2,:)];
    folderStatsStruct.xcorr(fileNum,:)=fileStatsStruct.xcorr;
    folderStatsStruct.span(fileNum,:)=mocapStruct.span;
    folderStats=setfield(folderStats,measure{:},folderStatsStruct);
end