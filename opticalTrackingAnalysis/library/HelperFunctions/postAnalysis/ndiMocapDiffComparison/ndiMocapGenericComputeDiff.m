function captureInfo=ndiMocapGenericComputeDiff(captureInfo,cs,rigidBody,warpPath,endPts,diffPathVec,diffPathScalar,statsPath,diffFunVec,diffFunScalar,varargin)
    if ~isfield(captureInfo,'diff')
        captureInfo.diff=struct;
    end
    %get the mocap data - could be vectors or frames
    mocapDataVec=getfield(captureInfo.mocap.(cs).(rigidBody),diffPathVec{:});
    %get the ndi data - could be vector or frames
    ndiDataVec=getfield(captureInfo.ndi.(cs).(rigidBody),diffPathVec{:});
    %compute the vector difference
    vecDiff=diffFunVec(mocapDataVec,ndiDataVec,warpPath);
    %get the mocap data - could be vectors or frames
    mocapDataScalar=getfield(captureInfo.mocap.(cs).(rigidBody),diffPathScalar{:});
    %get the ndi data - could be vector or frames
    ndiDataScalar=getfield(captureInfo.ndi.(cs).(rigidBody),diffPathScalar{:});
    %compute the scalar difference
    scalarDiff=diffFunScalar(mocapDataScalar,ndiDataScalar,warpPath);
    %get the struct that will hold the span data
    spanStruct=getfield(captureInfo.mocap.(cs).(rigidBody),statsPath{:});
    %now get the span vector data
    spanVec=spanStruct.vector(warpPath(:,1),:);
    %and the span scalar data
    if isfield(spanStruct,'scalar')
        spanScalar=spanStruct.scalar(warpPath(:,1),:);
    else
        spanScalar=0;
    end
    
    %and finally call the compute statistics function
    [diffStruct,spanStructReturn]=...
        computeDiffStats(spanStruct,vecDiff,scalarDiff,spanVec,spanScalar,endPts);
    
    %store differences
    diffStruct.vector=vecDiff;
    diffStruct.scalar=scalarDiff;
    
    if nargin>10
        xCorrPathVec=varargin{1};
        %get the mocap data for cross correlation
        mocapDataVec_xcorr=getfield(captureInfo.mocap.(cs).(rigidBody),xCorrPathVec{:});
        %get the ndi data for cross correlation
        ndiDataVec_xcorr=getfield(captureInfo.ndi.(cs).(rigidBody),xCorrPathVec{:});
    else
        mocapDataVec_xcorr=mocapDataVec;
        ndiDataVec_xcorr=ndiDataVec;
    end
    
    diffStruct.xcorr(1)=xcorr(mocapDataScalar(warpPath(endPts(1):endPts(2),1))-mean(mocapDataScalar(warpPath(endPts(1):endPts(2),1))),...
        ndiDataScalar(warpPath(endPts(1):endPts(2),2))-mean(ndiDataScalar(warpPath(endPts(1):endPts(2),2))),0,'coeff');
    diffStruct.xcorr(2)=xcorr(mocapDataVec_xcorr(warpPath(endPts(1):endPts(2),1),1)-mean(mocapDataVec_xcorr(warpPath(endPts(1):endPts(2),1),1)),...
        ndiDataVec_xcorr(warpPath(endPts(1):endPts(2),2),1)-mean(ndiDataVec_xcorr(warpPath(endPts(1):endPts(2),2),1)),0,'coeff');
    diffStruct.xcorr(3)=xcorr(mocapDataVec_xcorr(warpPath(endPts(1):endPts(2),1),2)-mean(mocapDataVec_xcorr(warpPath(endPts(1):endPts(2),1),2)),...
        ndiDataVec_xcorr(warpPath(endPts(1):endPts(2),2),2)-mean(ndiDataVec_xcorr(warpPath(endPts(1):endPts(2),2),2)),0,'coeff');
    diffStruct.xcorr(4)=xcorr(mocapDataVec_xcorr(warpPath(endPts(1):endPts(2),1),3)-mean(mocapDataVec_xcorr(warpPath(endPts(1):endPts(2),1),3)),...
        ndiDataVec_xcorr(warpPath(endPts(1):endPts(2),2),3)-mean(ndiDataVec_xcorr(warpPath(endPts(1):endPts(2),2),3)),0,'coeff');
    
    totalStatsPath=statsPath;
    totalStatsPath{end+1}=cs;
    totalStatsPath{end+1}=rigidBody;
    captureInfo.diff=setfield(captureInfo.diff,totalStatsPath{:},diffStruct);
    captureInfo.mocap.(cs).(rigidBody)=setfield(captureInfo.mocap.(cs).(rigidBody),statsPath{:},spanStructReturn);
end