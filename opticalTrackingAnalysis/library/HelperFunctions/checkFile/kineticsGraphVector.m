function [fig,subPlots]=kineticsGraphVector(figureNum,plotStyle,figTitle,yAxesLabel,warpPath,mocapVector,ndiVector,visibleEndPts)
    fig=figure(figureNum);
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    xIndex=(visibleEndPts(1):visibleEndPts(2))-visibleEndPts(1)+1;
    
    for n=1:3
        subPlots(n)=subplot(3,1,n);
        plot(xIndex,mocapVector(warpPath(visibleEndPts(1):visibleEndPts(2),1),n), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
        hold on
        plot(xIndex,ndiVector(warpPath(visibleEndPts(1):visibleEndPts(2),2),n), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
        hAxes = gca;
        set(hAxes,'box','off')
        legend('boxoff')
        if n==2
            ylabel(yAxesLabel);
        end
    end
    
    annotation('textbox', [0 0.9 1 0.1], ...
    'String', figTitle, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontWeight', 'Bold');
    %sgTit=sgtitle(figTitle);
    %suplabel(yAxesLabel,'y');
end