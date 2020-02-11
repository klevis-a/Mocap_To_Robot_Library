function markMaxDiff(mocapStruct,ndiStruct,diffStruct,diffStructLbl,warpPath,plotStyle,pAxes,endPts,visibleEndPts,addLbl)
    for n=1:3
        %index of where the max difference occurs
        maxI=diffStruct.maxI(1,n+1);
        %mocap y data
        mocapY=mocapStruct.vector(warpPath(maxI,1),n);
        %ndi y data
        ndiY=ndiStruct.vector(warpPath(maxI,2),n);
        %twComponents plots from visibleEndPts(1) forward so we account for 
        %that here. 
        %Here we are plotting the endpoints
        plot(pAxes(n),endPts(1)-visibleEndPts(1)+1, mocapStruct.vector(warpPath(endPts(1),1),n),'Color','black','Marker','.','MarkerSize',14);
        plot(pAxes(n),endPts(2)-visibleEndPts(1)+1, mocapStruct.vector(warpPath(endPts(2),1),n),'Color','black','Marker','.','MarkerSize',14);
        %here we are plotting the max difference
        plot(pAxes(n),maxI-visibleEndPts(1)+1,mocapY,'Color',plotStyle.triColor(n,:),'Marker','.','MarkerSize',14);
        plot(pAxes(n),maxI-visibleEndPts(1)+1,ndiY,'Color',plotStyle.triColor(n,:),'Marker','.','MarkerSize',14);
        %the legend is simply the maximum, rms, etc. difference
        dummyh = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
        lgnd=legend(dummyh, sprintf('Max: %.2f RMS: %.2f MAE: %.2f Mdn: %.2f Mean: %.2f STD: %.2f %s',...
            diffStructLbl.max(1,n+1),diffStructLbl.rms(1,n+1),diffStructLbl.mae(1,n+1),diffStructLbl.median(1,n+1),diffStructLbl.mean(1,n+1),diffStructLbl.std(1,n+1),addLbl),'Location', 'north','FontSize',9);
        lgnd.Position(2)=lgnd.Position(2)+0.05;
    end
end
