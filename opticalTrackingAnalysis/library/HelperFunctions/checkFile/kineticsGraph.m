function [fig]=kineticsGraph(figureNum,plotStyle,figTitle,yAxesLabel,warpPath,mocapScalar,ndiScalar,visibleEndPts)
    fig=figure(figureNum);
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    xIndex=(visibleEndPts(1):visibleEndPts(2))-visibleEndPts(1)+1;
    plot(xIndex,mocapScalar(warpPath(visibleEndPts(1):visibleEndPts(2),1),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(xIndex,ndiScalar(warpPath(visibleEndPts(1):visibleEndPts(2),2),1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hAxes = gca;
    set(hAxes,'box','off')
    legend('boxoff')
    ylabel(yAxesLabel);
    
    annotation('textbox', [0 0.9 1 0.1], ...
    'String', figTitle, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontWeight', 'Bold');
    %sgTit=sgtitle(figTitle);
    %suplabel(yAxesLabel,'y');
end