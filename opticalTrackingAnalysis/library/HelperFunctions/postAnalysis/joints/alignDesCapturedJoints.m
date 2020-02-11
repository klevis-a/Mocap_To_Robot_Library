function [capturedJoints_aligned]=alignDesCapturedJoints(desJoints,capturedJoints,capturedJoints_time,period,extPoints)
    %first resample the captured joints signal so it matches the desired
    %joints
    capturedJoints_resamp_time=0:period:capturedJoints_time(end);
    for n=1:6
        capturedJoints_resamp(:,n)=interp1(capturedJoints_time',capturedJoints(:,n),capturedJoints_resamp_time);
    end
    %now extend the resampled captured joints by extPoints in each
    %direction
    capturedJoints_resamp=[repmat(capturedJoints_resamp(1,:),extPoints,1); capturedJoints_resamp; repmat(capturedJoints_resamp(end,:),extPoints,1)];
    %now compute the xcorr
    lengthDiff=size(capturedJoints_resamp,1)-size(desJoints,1);
    assert(lengthDiff>=0);
    startIdx=zeros(5,1);
    numDesPoints=size(desJoints,1);
    %ignore the first joint because it can be offset without changing the
    %capture properties
    for n=2:6
        r=zeros(lengthDiff+1,1);
        for i=1:lengthDiff+1
            r(i)=xcorr(capturedJoints_resamp(i:i+numDesPoints-1,n),desJoints(:,n),0,'coeff');
        end
        [~,maxR_idx]=max(r);
        startIdx(n-1)=maxR_idx;
    end
    startIdxAll=round(median(startIdx));
    capturedJoints_aligned=capturedJoints_resamp(startIdxAll:startIdxAll+numDesPoints-1,:);
end