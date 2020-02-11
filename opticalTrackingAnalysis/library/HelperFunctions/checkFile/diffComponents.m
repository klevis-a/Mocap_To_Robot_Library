function [fig,pAxes]=diffComponents(figureNum,plotStyle,figTitle,yAxesLabel,zeroVec,diffVec,visibleEndPts)
    fig=figure(figureNum);
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    xIndex=(visibleEndPts(1):visibleEndPts(2))-visibleEndPts(1)+1;
    pAxes(1)=subplot(3,1,1);
    plot(xIndex,zeroVec(visibleEndPts(1):visibleEndPts(2),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    subplot(3,1,2)
    plot(xIndex,zeroVec(visibleEndPts(1):visibleEndPts(2),2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    subplot(3,1,3)
    plot(xIndex,zeroVec(visibleEndPts(1):visibleEndPts(2),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))

    subplot(3,1,1)
    hold on
    plot(diffVec(visibleEndPts(1):visibleEndPts(2),1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)])
    hAxes = gca;
    set(hAxes,'box','off')
    %hAxes.XAxis.Visible = 'off';
    legend('boxoff')

    pAxes(2)=subplot(3,1,2);
    hold on
    plot(xIndex,diffVec(visibleEndPts(1):visibleEndPts(2),2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)])
    hAxes = gca;
    set(hAxes,'box','off')
    %hAxes.XAxis.Visible = 'off';
    legend('boxoff')
    ylabel(yAxesLabel);

    pAxes(3)=subplot(3,1,3);
    hold on
    plot(xIndex,diffVec(visibleEndPts(1):visibleEndPts(2),3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)])
    hAxes = gca;  
    set(hAxes,'box','off')
    %hAxes.XAxis.Visible = 'off';
    legend('boxoff')
    
    annotation('textbox', [0 0.9 1 0.1], ...
    'String', figTitle, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontWeight', 'Bold');
    %sgtitle(figTitle);
    %suplabel(yAxesLabel,'y');
end