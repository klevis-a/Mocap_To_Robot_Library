function fileStats=computeIndividualPercentages(fileStats,statsPath,cs,rb)
    diffStruct=getfield(fileStats.diff,statsPath{:});
    diffStruct=diffStruct.(cs).(rb);
    spanStruct=getfield(fileStats.mocap.(cs).(rb),statsPath{:});
    perDiffStruct.max=(diffStruct.max./spanStruct.span)*100;
    perDiffStruct.maxI=diffStruct.maxI;
    perDiffStruct.mean=(diffStruct.mean./spanStruct.span)*100;
    perDiffStruct.mae=(diffStruct.mae./spanStruct.span)*100;
    perDiffStruct.median=(diffStruct.median./spanStruct.span)*100;
    perDiffStruct.std=(diffStruct.std./spanStruct.span)*100;
    perDiffStruct.mad=(diffStruct.mad./spanStruct.span)*100;
    perDiffStruct.rms=(diffStruct.rms./spanStruct.span)*100;
    perDiffStruct.topMax=(diffStruct.topMax./repelem(spanStruct.span,5,1))*100;
    perDiffStruct.vector=(diffStruct.vector./spanStruct.span(2:4))*100;
    perDiffStruct.scalar=(diffStruct.scalar/spanStruct.span(1))*100;
    newPath=[{'percentage'}, statsPath{2:end}, {cs}, {rb}];
    fileStats.diff=setfield(fileStats.diff,newPath{:},perDiffStruct);
end