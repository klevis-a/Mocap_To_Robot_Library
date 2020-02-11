function fig=createCheckFileGraphDiff(figNum,plotStyle,figTitle,yaxLabel,fileStats,measure,CsRbs,visibleEndPts,plotPer)
    %the measure gives you whether you need a linear, rotation, or euler RB
    %and CS
    [cs,rb]=determineCsRb(measure);
    %difference data
    diffStructActual=getfield(fileStats.diff.mmdeg,measure{:});
    diffStructActual=diffStructActual.(CsRbs.(cs)).(CsRbs.(rb));
    diffStructPer=getfield(fileStats.diff.percentage,measure{:});
    diffStructPer=diffStructPer.(CsRbs.(cs)).(CsRbs.(rb));
    %get the endpoints
    endPts=fileStats.endPts.(measure{1}).(CsRbs.linCS).(CsRbs.linRB).(CsRbs.rotCS).(CsRbs.rotRB);
    %for the mocap data we just plot zeros
    zeroVector=zeros(size(diffStructActual.vector,1),3);
    %plot the graphs
    if plotPer
        diffStruct=diffStructPer;
        addLbl='%';
    else
        diffStruct=diffStructActual;
        addLbl='';
    end
    [fig,pAxes]=diffComponents(figNum,plotStyle,figTitle,yaxLabel,zeroVector,diffStruct.vector,visibleEndPts);
    %mark the endpoints and max diff
    markMaxDiffForDiff(diffStruct,plotStyle,pAxes,endPts,visibleEndPts,addLbl);
end