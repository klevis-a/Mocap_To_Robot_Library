function warpPathEndPts=computeVisibleEndPtsDtw(warpPath,signalStart,signalStop,signalNum,offset)
    warpPathEndPts(1)=find(warpPath(:,signalNum)==signalStart, 1, 'last')-offset;
    warpPathEndPts(2)=find(warpPath(:,signalNum)==signalStop, 1, 'first')+offset;

    if warpPathEndPts(1)<1
        warpPathEndPts(1)=1;
    end
    
    if warpPathEndPts(2)>length(warpPath(:,signalNum))
        warpPathEndPts(2)=length(warpPath(:,signalNum));
    end
end