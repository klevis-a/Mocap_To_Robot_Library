function annotateKinetics_JO(mocapY,ndiY,diffStruct,warpPath,plotStyle,endPts,visibleEndPts)
    %index of where the max difference occurs
    mocapTopMaxI=diffStruct.topMaxMocapPeakIdx(1,1);
    %twComponents plots from visibleEndPts(1) forward so we account for 
    %that here. 
    %Here we are plotting the endpoints
    plot(endPts(1)-visibleEndPts(1)+1, mocapY(warpPath(endPts(1),1)),'Color','black','Marker','.','MarkerSize',14);
    plot(endPts(2)-visibleEndPts(1)+1, mocapY(warpPath(endPts(2),1)),'Color','black','Marker','.','MarkerSize',14);
    %here we are plotting difference at topMax
    plot(mocapTopMaxI-visibleEndPts(1)+1,mocapY(warpPath(mocapTopMaxI,1)),'Color',plotStyle.triColor(3,:),'Marker','.','MarkerSize',14);
    plot(mocapTopMaxI-visibleEndPts(1)+1,ndiY(warpPath(mocapTopMaxI,2)),'Color',plotStyle.triColor(3,:),'Marker','.','MarkerSize',14);
    %the legend is simply the maximum, rms, etc. difference
    dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
    lgnd=legend(dummyh, sprintf('AtTopMax: %.2f RMS: %.2f MAE: %.2f Mdn: %.2f Mean: %.2f STD: %.2f',...
        diffStruct.percentage.diffAtPeaks(1,1), diffStruct.percentage.rms,diffStruct.percentage.mae,diffStruct.percentage.median, ...
        diffStruct.percentage.mean,diffStruct.percentage.std),'Location', 'north','FontSize',9);
    lgnd.Position(2)=lgnd.Position(2)+0.05;
end
