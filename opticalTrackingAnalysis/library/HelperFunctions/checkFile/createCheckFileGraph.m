function fig=createCheckFileGraph(figNum,plotStyle,figTitle,yaxLabel,fileStats,measure,CsRbs,visibleEndPts,plotPer)
    %the measure gives you whether you need a linear, rotation, or euler RB
    %and CS
    [cs,rb]=determineCsRb(measure);
    %mocap data
    mocapStruct=getfield(fileStats.mocap.(CsRbs.(cs)).(CsRbs.(rb)).mmdeg,measure{:});
    %ndi data
    ndiStruct=getfield(fileStats.ndi.(CsRbs.(cs)).(CsRbs.(rb)).mmdeg,measure{:});
    %difference data
    diffStruct=getfield(fileStats.diff.mmdeg,measure{:});
    diffStruct=diffStruct.(CsRbs.(cs)).(CsRbs.(rb));
    diffStructPer=getfield(fileStats.diff.percentage,measure{:});
    diffStructPer=diffStructPer.(CsRbs.(cs)).(CsRbs.(rb));
    %get the calculated warp path
    warpPath=fileStats.warpPaths.(measure{1}).(CsRbs.linCS).(CsRbs.linRB).(CsRbs.rotCS).(CsRbs.rotRB);
    %get the endpoints
    endPts=fileStats.endPts.(measure{1}).(CsRbs.linCS).(CsRbs.linRB).(CsRbs.rotCS).(CsRbs.rotRB);
    %plot the graphs
    [fig,pAxes]=twComponents(figNum,plotStyle,figTitle,yaxLabel,warpPath,mocapStruct.vector,ndiStruct.vector,visibleEndPts);
    %mark the endpoints and max diff
    if plotPer
        diffStructLbl=diffStructPer;
        addLbl='%';
    else
        diffStructLbl=diffStruct;
        addLbl='';
    end
    markMaxDiff(mocapStruct,ndiStruct,diffStruct,diffStructLbl,warpPath,plotStyle,pAxes,endPts,visibleEndPts,addLbl);
end