function markMaxDiffForDiff(diffStruct,plotStyle,pAxes,endPts,visibleEndPts,addLbl)
    for n=1:3
        %index of where the max difference occurs
        maxI=diffStruct.maxI(1,n+1);
        diffY=diffStruct.vector(maxI,n);
        %twComponents plots from visibleEndPts(1) forward so we account for 
        %that here. 
        %Here we are plotting the endpoints
        plot(pAxes(n),endPts(1)-visibleEndPts(1)+1, diffStruct.vector(endPts(1),n),'Color','black','Marker','.','MarkerSize',14);
        plot(pAxes(n),endPts(2)-visibleEndPts(1)+1, diffStruct.vector(endPts(2),n),'Color','black','Marker','.','MarkerSize',14);
        %here we are plotting the max difference
        plot(pAxes(n),maxI-visibleEndPts(1)+1,0,'Color',plotStyle.triColor(n,:),'Marker','.','MarkerSize',14);
        plot(pAxes(n),maxI-visibleEndPts(1)+1,diffY,'Color',plotStyle.triColor(n,:),'Marker','.','MarkerSize',14);
        %the legend is simply the maximum, rms, etc. difference
        dummyh = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
        lgnd=legend(dummyh, sprintf('Max: %.2f RMS: %.2f MAE: %.2f Mdn: %.2f Mean: %.2f STD: %.2f %s',diffStruct.max(1,n+1),diffStruct.rms(1,n+1),diffStruct.mae(1,n+1),diffStruct.median(1,n+1),diffStruct.mean(1,n+1),diffStruct.std(1,n+1),addLbl),'Location', 'north','FontSize',9);
        lgnd.Position(2)=lgnd.Position(2)+0.05;
%         dummyh1 = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%         dummyh2 = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%         dummyh3 = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%         dummyh4 = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%         dummyh5 = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%         dummyh6 = line(pAxes(n),nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%         alignment='%-5s%6.2f';
%         lgnd=legend([dummyh1 dummyh2 dummyh3 dummyh4 dummyh5 dummyh6], {sprintf(alignment,'Max:',diffStruct.max(1,n+1)),...
%             sprintf(alignment,'RMS:',diffStruct.rms(1,n+1)),sprintf(alignment,'MAE:',diffStruct.mae(1,n+1)),...
%             sprintf(alignment,'Mdn:', diffStruct.median(1,n+1)),sprintf(alignment,'Mean:',diffStruct.mean(1,n+1)),sprintf(alignment,'STD:',diffStruct.std(1,n+1))},'Location', 'east','FontSize',9,'FontName','FixedWidth');
%         lgnd.Position(1)=0.85;
    end
end
