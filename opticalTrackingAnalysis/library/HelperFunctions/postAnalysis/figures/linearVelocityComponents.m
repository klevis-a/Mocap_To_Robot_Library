function fig=linearVelocityComponents(figureNum, plotStyle, mocapTime, mocapVelVec, ndiVelVec, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    plot(mocapTime,mocapVelVec(:,1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapTime,mocapVelVec(:,2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapTime,mocapVelVec(:,3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))
    hold on
    plot(mocapTime,ndiVelVec(:,1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapTime,ndiVelVec(:,2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapTime,ndiVelVec(:,3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))
    ylabel('Linear Velocity (mm/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    xlabel('Time (s)');
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Linear Velocity (X)','Desired Linear Velocity (Y)','Desired Linear Velocity (Z)',...
        'Achieved Linear Velocity (X)','Achieved Linear Velocity (Y)','Achieved Linear Velocity (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Desired vs Achieved Linear Velocity (Component-Wise)');
end