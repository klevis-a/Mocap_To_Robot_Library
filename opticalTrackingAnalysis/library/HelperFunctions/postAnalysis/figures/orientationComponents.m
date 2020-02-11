function fig=orientationComponents(figureNum, plotStyle, mocapTime, mocapOrientVec, ndiOrientVec, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    plot(mocapTime,mocapOrientVec(:,1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapTime,mocapOrientVec(:,2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapTime,mocapOrientVec(:,3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))
    hold on
    plot(mocapTime,ndiOrientVec(:,1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapTime,ndiOrientVec(:,2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapTime,ndiOrientVec(:,3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))
    ylabel('Orientation (deg)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    xlabel('Time (s)');
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Orientation (X)','Desired Orientation (Y)','Desired Orientation (Z)',...
        'Achieved Orientation (X)','Achieved Orientation (Y)','Achieved Orientation (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Desired vs Achieved Orientation (Component-Wise)');
end