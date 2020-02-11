function fig=yxzEulerAngles(figureNum, plotStyle, mocapTime, mocapYxzAngles, ndiYxzAngles, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    plot(mocapTime,mocapYxzAngles(:,1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapTime,mocapYxzAngles(:,2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapTime,mocapYxzAngles(:,3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))
    hold on
    plot(mocapTime,ndiYxzAngles(:,1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapTime,ndiYxzAngles(:,2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapTime,ndiYxzAngles(:,3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))
    ylabel('Angle (deg)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    xlabel('Time (s)');
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Angle (X)','Desired Angle (Y)','Desired Angle (Z)',...
        'Achieved Angle (X)','Achieved Angle (Y)','Achieved Angle (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Desired vs Achieved YXZ Euler Angles');
end