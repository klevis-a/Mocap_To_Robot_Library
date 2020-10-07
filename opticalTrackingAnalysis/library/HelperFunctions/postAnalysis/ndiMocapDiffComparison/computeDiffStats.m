function [diffStruct,spanStruct]=computeDiffStats(spanStruct,vecDiff,scalarDiff,spanVec,spanScalar,endPts)
    if scalarDiff==0
        %if the scalar difference vector is zero then we cannot compute
        %scalar differences, this happens for euler angles
        diffStruct.max(1)=0;
        diffStruct.mae(1)=0;
        diffStruct.mean(1)=0;
        diffStruct.median(1)=0;
        diffStruct.rms(1)=0;
        diffStruct.std(1)=0;
        diffStruct.mad(1)=0;
        diffStruct.topMax(:,1)=zeros(5,1);
        diffStruct.maxI(1,1)=0;
        diffStruct.maxI(2,1)=0;
    else
        %otherwise compute scalar differences
        [diffStruct.max(1),diffStruct.maxI(1,1)]=max(abs(scalarDiff(endPts(1):endPts(2))));
        diffStruct.mae(1)=mean(abs(scalarDiff(endPts(1):endPts(2))));
        diffStruct.mean(1)=mean(scalarDiff(endPts(1):endPts(2)));
        diffStruct.median(1)=median(scalarDiff(endPts(1):endPts(2)));
        diffStruct.rms(1)=rms(scalarDiff(endPts(1):endPts(2)));
        diffStruct.std(1)=std(scalarDiff(endPts(1):endPts(2)));
        diffStruct.mad(1)=mad(scalarDiff(endPts(1):endPts(2)),1);
        pks=findpeaks(abs(scalarDiff(endPts(1):endPts(2))),'MinPeakDistance',10,'MinPeakProminence',1);
        pksSorted=sort(pks,'descend');
        if length(pksSorted)<5
            pksScalar=rectifyVectorLength(pksSorted',5,@zeros)';
        else
            pksScalar=pksSorted(1:5);
        end
        diffStruct.topMax(:,1)=pksScalar;
        diffStruct.maxI(2,1)=diffStruct.maxI(1,1)/diff(endPts);
        %we computed the max between the endpoints so renormalize the index
        %so it counts from the actual beginning of the capture
        diffStruct.maxI(1,1)=diffStruct.maxI(1,1)+endPts(1)-1;
        
        [~,topMaxMocapI]=findpeaks(abs(spanScalar(endPts(1):endPts(2))), 'SortStr','descend','MinPeakDistance',10,'MinPeakProminence',1,'MinPeakWidth',5);
        if length(topMaxMocapI)<5
            topMaxMocapPeakIdx=rectifyVectorLength(topMaxMocapI',5,@ones)';
        else
            topMaxMocapPeakIdx=topMaxMocapI(1:5);
        end
        diffStruct.topMaxMocapPeakIdx(:,1) = topMaxMocapPeakIdx+endPts(1)-1;
        diffStruct.diffAtPeaks(:,1) = abs(scalarDiff(diffStruct.topMaxMocapPeakIdx(:,1)));
    end
    
    if spanScalar==0
        spanStruct.span(1)=0;
    else
        spanStruct.span(1)=max(spanScalar(endPts(1):endPts(2)));
    end

    for n=1:3
        [diffStruct.max(n+1),diffStruct.maxI(1,n+1)]=max(abs(vecDiff(endPts(1):endPts(2),n)));
        diffStruct.mean(n+1)=mean(vecDiff(endPts(1):endPts(2),n));
        diffStruct.mae(n+1)=mean(abs(vecDiff(endPts(1):endPts(2),n)));
        diffStruct.median(n+1)=median(vecDiff(endPts(1):endPts(2),n));
        diffStruct.rms(n+1)=rms(abs(vecDiff(endPts(1):endPts(2),n)));
        diffStruct.std(n+1)=std(vecDiff(endPts(1):endPts(2),n));
        diffStruct.mad(n+1)=mad(vecDiff(endPts(1):endPts(2),n),1);
        pks=findpeaks(abs(vecDiff(endPts(1):endPts(2),n)),'MinPeakDistance',10,'MinPeakProminence',1);
        pksSorted=sort(pks,'descend');
        if length(pksSorted)<5
            pksVec=rectifyVectorLength(pksSorted',5,@zeros)';
        else
            pksVec=pksSorted(1:5);
        end
        diffStruct.topMax(:,n+1)=pksVec;
        diffStruct.maxI(2,n+1)=diffStruct.maxI(1,n+1)/diff(endPts);
        %we computed the max between the endpoints so renormalize the index
        %so it counts from the actual beginning of the capture
        diffStruct.maxI(1,n+1)=diffStruct.maxI(1,n+1)+endPts(1)-1;
        spanStruct.span(n+1)=max(spanVec(endPts(1):endPts(2),n))-min(spanVec(endPts(1):endPts(2),n));
        
        [~,topMaxMocapI]=findpeaks(abs(spanVec(endPts(1):endPts(2),n)), 'SortStr','descend','MinPeakDistance',10,'MinPeakProminence',1,'MinPeakWidth',5);
        if length(topMaxMocapI)<5
            topMaxMocapPeakIdx=rectifyVectorLength(topMaxMocapI',5,@ones)';
        else
            topMaxMocapPeakIdx=topMaxMocapI(1:5);
        end
        diffStruct.topMaxMocapPeakIdx(:,n+1) = topMaxMocapPeakIdx+endPts(1)-1;
        diffStruct.diffAtPeaks(:,n+1) = abs(vecDiff(diffStruct.topMaxMocapPeakIdx(:,n+1),n));
    end
end