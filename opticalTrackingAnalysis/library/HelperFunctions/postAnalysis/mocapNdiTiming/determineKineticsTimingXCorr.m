function [captureInfo,ndiEndPts]=determineKineticsTimingXCorr(captureInfo)
    %how many points do we have for each capture
    numNdiPts=length(captureInfo.ndi.time);
    numMocapPts=length(captureInfo.mocap.time);
    
    %difference in the number of points between mocap and ndi
    mocapNdiDiff=(numNdiPts-numMocapPts+1);
    mocapNdiXCorr=zeros(3,mocapNdiDiff);
    
    %iterate through ndi offset indices and compute the cross-correlation
    for n=1:mocapNdiDiff
        mocapNdiXCorr(1,n)=xcorr(captureInfo.kinetics.mocap.axialForce,...
            captureInfo.kinetics.ndi.axialForce(n:n+numMocapPts-1),0,'coeff');
        mocapNdiXCorr(2,n)=xcorr(captureInfo.kinetics.mocap.bendingMoment,...
            captureInfo.kinetics.ndi.bendingMoment(n:n+numMocapPts-1),0,'coeff');
        mocapNdiXCorr(3,n)=xcorr(captureInfo.kinetics.mocap.axialMoment,...
            captureInfo.kinetics.ndi.axialMoment(n:n+numMocapPts-1),0,'coeff');
    end
    
    %the offset index occurs where the maximum cross-correlation occurs -
    %we just average amongst all the signals
    ndiEndPts=zeros(1,2);
    [~,maxCorrINdi]=max(mocapNdiXCorr,[],2);
    ndiEndPts(1)=round(median(maxCorrINdi),0);
    ndiEndPts(2)=ndiEndPts(1)+numMocapPts-1;
    
    captureInfo.kinetics.ndiStart=ndiEndPts(1);
    captureInfo.kinetics.ndiStop=ndiEndPts(2);
end