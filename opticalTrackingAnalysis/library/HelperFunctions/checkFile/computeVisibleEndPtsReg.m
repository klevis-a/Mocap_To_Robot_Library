function warpPathEndPts=computeVisibleEndPtsReg(warpPath,signalStart,signalStop,signalNum,offset)
    warpPathEndPts(1)=signalStart-offset;
    warpPathEndPts(2)=signalStop+offset;

    if warpPathEndPts(1)<1
        warpPathEndPts(1)=1;
    end
    
    if warpPathEndPts(2)>length(warpPath(:,signalNum))
        warpPathEndPts(2)=length(warpPath(:,signalNum));
    end
end