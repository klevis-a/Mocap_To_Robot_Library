function captureInfo=computeEndPointsDtw(captureInfo,poseCsRbs,velCsRbs,accCsRbs) 
    %the warp paths allow you to find the end points for computing RMS
    %values. Note that we don't want to use the entire capture because
    %there is tons of zeros at the beginning and end which would skew the
    %statistics
    posEndPts(1)=find(captureInfo.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB)(:,2)==captureInfo.ndiStart, 1, 'last');
    posEndPts(2)=find(captureInfo.warpPaths.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB)(:,2)==captureInfo.ndiStop, 1, 'first');
    velEndPts(1)=find(captureInfo.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB)(:,2)==captureInfo.ndiStart, 1, 'last');
    velEndPts(2)=find(captureInfo.warpPaths.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB)(:,2)==captureInfo.ndiStop, 1, 'first');
    accEndPts(1)=find(captureInfo.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB)(:,2)==captureInfo.ndiStart, 1, 'last');
    accEndPts(2)=find(captureInfo.warpPaths.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB)(:,2)==captureInfo.ndiStop, 1, 'first');
    
    captureInfo.endPts.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB)=posEndPts;
    captureInfo.endPts.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB)=velEndPts;
    captureInfo.endPts.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB)=accEndPts;
end