function offset=capturesOffsetXCorrRot(capture1,capture2,posIndex)
    [r,lags]=xcorr(capture1.ndi.robot.hs.pose.rotation.vector(:,posIndex),capture2.ndi.robot.hs.pose.rotation.vector(:,posIndex),'coeff',100);
    %find maximum correlation
    [~,maxI]=max(r);
    offset=lags(maxI);
end