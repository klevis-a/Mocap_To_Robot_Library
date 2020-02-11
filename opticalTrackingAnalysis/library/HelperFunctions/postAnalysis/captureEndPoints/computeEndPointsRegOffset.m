function captureInfo=computeEndPointsRegOffset(captureInfo,poseCsRbs,velCsRbs,accCsRbs)
    %determine endpoints based on activity
    endPts=determineEndPts(captureInfo.activity,captureInfo.mocap.time);
    
    captureInfo.endPts.pose.(poseCsRbs.linCS).(poseCsRbs.linRB).(poseCsRbs.rotCS).(poseCsRbs.rotRB)=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
    captureInfo.endPts.velocity.(velCsRbs.linCS).(velCsRbs.linRB).(velCsRbs.rotCS).(velCsRbs.rotRB)=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
    captureInfo.endPts.acceleration.(accCsRbs.linCS).(accCsRbs.linRB).(accCsRbs.rotCS).(accCsRbs.rotRB)=...
        [captureInfo.ndiStart+endPts(1)-1 captureInfo.ndiStart+endPts(2)-1];
end