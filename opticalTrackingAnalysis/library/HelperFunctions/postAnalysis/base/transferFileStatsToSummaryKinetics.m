function targetStruct=transferFileStatsToSummaryKinetics(targetStruct,kineVar,fileStats,fileNum,varargin)
    if nargin>4
        index=varargin{1};
        sourceStruct=getfield(fileStats.kinetics.diff, kineVar{:});
        sourceStruct=sourceStruct(index);
    else
        sourceStruct=getfield(fileStats.kinetics.diff, kineVar{:});
    end
    
    targetStruct.diffAtMax(fileNum,:)=sourceStruct.diffAtMax;
    targetStruct.max(fileNum,:)=sourceStruct.max;
    targetStruct.mean(fileNum,:)=sourceStruct.mean;
    targetStruct.mae(fileNum,:)=sourceStruct.mae;
    targetStruct.median(fileNum,:)=sourceStruct.median;
    targetStruct.rms(fileNum,:)=sourceStruct.rms;
    targetStruct.std(fileNum,:)=sourceStruct.std;
    targetStruct.mad(fileNum,:)=sourceStruct.mad;
    targetStruct.topMax(fileNum,:)=sourceStruct.topMax(:);
    targetStruct.diffAtPeaks(fileNum,:)=sourceStruct.diffAtPeaks(:);
    targetStruct.span(fileNum,:)=sourceStruct.span;
    if fileStats.activity==Activities.IR90 && any(contains(kineVar,'axialMoment'))
        targetStruct.firstHalfMax(fileNum,:)=sourceStruct.firstHalf.max;
        targetStruct.secondHalfMax(fileNum,:)=sourceStruct.secondHalf.max;
    end
    
    targetStruct.percentage.max(fileNum,:)=sourceStruct.percentage.max;
    targetStruct.percentage.diffAtMax(fileNum,:)=sourceStruct.percentage.diffAtMax;
    targetStruct.percentage.mae(fileNum,:)=sourceStruct.percentage.mae;
    targetStruct.percentage.mean(fileNum,:)=sourceStruct.percentage.mean;
    targetStruct.percentage.median(fileNum,:)=sourceStruct.percentage.median;
    targetStruct.percentage.rms(fileNum,:)=sourceStruct.percentage.rms;
    targetStruct.percentage.std(fileNum,:)=sourceStruct.percentage.std;
    targetStruct.percentage.mad(fileNum,:)=sourceStruct.percentage.mad;
    targetStruct.percentage.topMax(fileNum,:)=sourceStruct.percentage.topMax(:);
    targetStruct.percentage.diffAtPeaks(fileNum,:)=sourceStruct.percentage.diffAtPeaks(:);
    if fileStats.activity==Activities.IR90 && any(contains(kineVar,'axialMoment'))
        targetStruct.percentage.firstHalfMax(fileNum,:)=sourceStruct.percentage.firstHalf.max;
        targetStruct.percentage.secondHalfMax(fileNum,:)=sourceStruct.percentage.secondHalf.max;
    end
end