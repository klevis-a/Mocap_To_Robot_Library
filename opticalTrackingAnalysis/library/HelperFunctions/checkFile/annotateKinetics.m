function annotateKinetics(mocapY,ndiY,diffStruct,warpPath,plotStyle,endPts,visibleEndPts,varargin)
    if nargin>7
        ax=varargin{1};
    else
        ax=gca;
    end
    %index of where the max difference occurs
    maxI=diffStruct.maxI(1,1);
    mocapMaxI=diffStruct.mocapMaxI;
    topMaxI=diffStruct.topMaxI(1,1);
    mocapTopMaxI=diffStruct.topMaxMocapPeakIdx(1,1);
    %twComponents plots from visibleEndPts(1) forward so we account for 
    %that here. 
    %Here we are plotting the endpoints
    plot(ax,endPts(1)-visibleEndPts(1)+1, mocapY(warpPath(endPts(1),1)),'Color','black','Marker','.','MarkerSize',14);
    plot(ax,endPts(2)-visibleEndPts(1)+1, mocapY(warpPath(endPts(2),1)),'Color','black','Marker','.','MarkerSize',14);
    %here we are plotting the max difference
    plot(ax,maxI-visibleEndPts(1)+1,mocapY(warpPath(maxI,1)),'Color',plotStyle.triColor(1,:),'Marker','.','MarkerSize',14);
    plot(ax,maxI-visibleEndPts(1)+1,ndiY(warpPath(maxI,2)),'Color',plotStyle.triColor(1,:),'Marker','.','MarkerSize',14);
    %here we are plotting the difference at max
    plot(ax,mocapMaxI-visibleEndPts(1)+1,mocapY(warpPath(mocapMaxI,1)),'Color',plotStyle.triColor(1,:),'Marker','.','MarkerSize',14);
    plot(ax,mocapMaxI-visibleEndPts(1)+1,ndiY(warpPath(mocapMaxI,2)),'Color',plotStyle.triColor(1,:),'Marker','.','MarkerSize',14);
    %here we are plotting topMax difference
    if ~isempty(topMaxI) && topMaxI~=0
        plot(ax,topMaxI-visibleEndPts(1)+1,mocapY(warpPath(topMaxI,1)),'Color',plotStyle.triColor(2,:),'Marker','.','MarkerSize',14);
        plot(ax,topMaxI-visibleEndPts(1)+1,ndiY(warpPath(topMaxI,2)),'Color',plotStyle.triColor(2,:),'Marker','.','MarkerSize',14);
    end
    %here we are plotting difference at topMax
    if ~isempty(mocapTopMaxI) && mocapTopMaxI~=0
        plot(ax,mocapTopMaxI-visibleEndPts(1)+1,mocapY(warpPath(mocapTopMaxI,1)),'Color',plotStyle.triColor(3,:),'Marker','.','MarkerSize',14);
        plot(ax,mocapTopMaxI-visibleEndPts(1)+1,ndiY(warpPath(mocapTopMaxI,2)),'Color',plotStyle.triColor(3,:),'Marker','.','MarkerSize',14);
    end
    %the legend is simply the maximum, rms, etc. difference
    dummyh = line(ax,nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
    lgnd=legend(ax,dummyh, sprintf('AtTopMax: %.2f TopMax: %.2f AtMax: %.2f: Max: %.2f RMS: %.2f MAE: %.2f Mdn: %.2f Mean: %.2f STD: %.2f',...
        diffStruct.percentage.diffAtPeaks(1,1), diffStruct.percentage.topMax(1,1),diffStruct.percentage.diffAtMax, ...
        diffStruct.percentage.max,diffStruct.percentage.rms,diffStruct.percentage.mae,diffStruct.percentage.median, ...
        diffStruct.percentage.mean,diffStruct.percentage.std),'Location', 'north','FontSize',9);
    lgnd.Position(2)=lgnd.Position(2)+0.05;
end
