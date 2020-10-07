function diffStruct=computeScalarStats(scalarDiff,endPts,span,warpedMocap,warpedNdi,varargin)
    if nargin>5
        minPeakProminence=varargin{1};
        meanPeakWidth=varargin{2};
        if nargin>7
            minPeakProminence_mocap=varargin{3};
            meanPeakWidth_mocap=varargin{4};
        else
            minPeakProminence_mocap=1;
            meanPeakWidth_mocap=5;
        end
    else
        minPeakProminence=1;
        meanPeakWidth=5;
    end
    [diffStruct.max,diffStruct.maxI(1,1)]=max(abs(scalarDiff(endPts(1):endPts(2))));
    diffStruct.mae=mean(abs(scalarDiff(endPts(1):endPts(2))));
    diffStruct.mean=mean(scalarDiff(endPts(1):endPts(2)));
    diffStruct.median=median(scalarDiff(endPts(1):endPts(2)));
    diffStruct.rms=rms(scalarDiff(endPts(1):endPts(2)));
    diffStruct.std=std(scalarDiff(endPts(1):endPts(2)));
    diffStruct.mad=mad(scalarDiff(endPts(1):endPts(2)),1);
    [pks,pksI]=findpeaks(abs(scalarDiff(endPts(1):endPts(2))),'MinPeakDistance',10,'MinPeakProminence',minPeakProminence,'MinPeakWidth',meanPeakWidth,'SortStr','descend');
    if length(pks)<5
        pksScalar=rectifyVectorLength(pks',5,@zeros)';
        pksScalarI=rectifyVectorLength(pksI',5,@zeros)';
    else
        pksScalar=pks(1:5);
        pksScalarI=pksI(1:5);
    end
    diffStruct.topMax(:,1)=pksScalar;
    diffStruct.topMaxI(:,1)=pksScalarI+endPts(1)-1;
    diffStruct.maxI(2,1)=diffStruct.maxI(1,1)/diff(endPts);
    %we computed the max between the endpoints so renormalize the index
    %so it counts from the actual beginning of the capture
    diffStruct.maxI(1,1)=diffStruct.maxI(1,1)+endPts(1)-1;
    
    %now compute percentages from the span supplied
    diffStruct.percentage.max=diffStruct.max/span*100;
    diffStruct.percentage.mae=diffStruct.mae/span*100;
    diffStruct.percentage.mean=diffStruct.mean/span*100;
    diffStruct.percentage.median=diffStruct.median/span*100;
    diffStruct.percentage.rms=diffStruct.rms/span*100;
    diffStruct.percentage.std=diffStruct.std/span*100;
    diffStruct.percentage.mad=diffStruct.mad/span*100;
    diffStruct.percentage.topMax(:,1)=diffStruct.topMax(:,1)/span*100;
    
    %compute difference at maximum
    [~,maxMocapI]=max(abs(warpedMocap(endPts(1):endPts(2))));
    diffStruct.mocapMaxI = maxMocapI+endPts(1)-1;
    diffStruct.diffAtMax = abs(warpedMocap(diffStruct.mocapMaxI)-warpedNdi(diffStruct.mocapMaxI));
    diffStruct.percentage.diffAtMax = diffStruct.diffAtMax/span*100;
    
    [~,topMaxMocapI]=findpeaks(abs(warpedMocap(endPts(1):endPts(2))), 'SortStr','descend','MinPeakDistance',10,'MinPeakProminence',minPeakProminence_mocap,'MinPeakWidth',meanPeakWidth_mocap);
    if length(topMaxMocapI)<5
        topMaxMocapPeakIdx=rectifyVectorLength(topMaxMocapI',5,@ones)';
    else
        topMaxMocapPeakIdx=topMaxMocapI(1:5);
    end
    diffStruct.topMaxMocapPeakIdx = topMaxMocapPeakIdx+endPts(1)-1;
    diffStruct.diffAtPeaks = abs(warpedMocap(diffStruct.topMaxMocapPeakIdx)-warpedNdi(diffStruct.topMaxMocapPeakIdx));
    diffStruct.percentage.diffAtPeaks = diffStruct.diffAtPeaks/span*100;
end