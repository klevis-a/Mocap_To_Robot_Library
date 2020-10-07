function annotateKinetics_IR(mocapY,ndiY,diffStruct,warpPath,plotStyle,endPts,visibleEndPts)
    %index of where the max difference occurs
    firstHalfI = diffStruct.firstHalf.maxI;
    secondHalfI = diffStruct.secondHalf.maxI;
    %twComponents plots from visibleEndPts(1) forward so we account for 
    %that here. 
    %Here we are plotting the endpoints
    plot(endPts(1)-visibleEndPts(1)+1, mocapY(warpPath(endPts(1),1)),'Color','black','Marker','.','MarkerSize',14);
    plot(endPts(2)-visibleEndPts(1)+1, mocapY(warpPath(endPts(2),1)),'Color','black','Marker','.','MarkerSize',14);
    %here we are plotting the first half max difference
    plot(firstHalfI-visibleEndPts(1)+1,mocapY(warpPath(firstHalfI,1)),'Color',plotStyle.triColor(2,:),'Marker','.','MarkerSize',14);
    plot(firstHalfI-visibleEndPts(1)+1,ndiY(warpPath(firstHalfI,2)),'Color',plotStyle.triColor(2,:),'Marker','.','MarkerSize',14);
    %here we are plotting the second half max difference
    plot(secondHalfI-visibleEndPts(1)+1,mocapY(warpPath(secondHalfI,1)),'Color',plotStyle.triColor(3,:),'Marker','.','MarkerSize',14);
    plot(secondHalfI-visibleEndPts(1)+1,ndiY(warpPath(secondHalfI,2)),'Color',plotStyle.triColor(3,:),'Marker','.','MarkerSize',14);
    %the legend is simply the maximum, rms, etc. difference
    dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
    lgnd=legend(dummyh, sprintf('FirstMax: %.2f SecondMax: %.2f %.2f RMS: %.2f MAE: %.2f Mdn: %.2f Mean: %.2f STD: %.2f',...
        diffStruct.percentage.firstHalf.max, diffStruct.percentage.secondHalf.max,...
        diffStruct.percentage.rms,diffStruct.percentage.mae,diffStruct.percentage.median, ...
        diffStruct.percentage.mean,diffStruct.percentage.std),'Location', 'north','FontSize',9);
    lgnd.Position(2)=lgnd.Position(2)+0.05;
end
