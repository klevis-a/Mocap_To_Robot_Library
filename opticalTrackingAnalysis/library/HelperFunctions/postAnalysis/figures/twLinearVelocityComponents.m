function fig=twLinearVelocityComponents(figureNum, plotStyle, warpPathVel, mocapVelVec, ndiVelVec, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    plot(mocapVelVec(warpPathVel(:,1),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapVelVec(warpPathVel(:,1),2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapVelVec(warpPathVel(:,1),3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))
    hold on
    plot(ndiVelVec(warpPathVel(:,2),1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(ndiVelVec(warpPathVel(:,2),2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(ndiVelVec(warpPathVel(:,2),3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))
    ylabel('Linear Velocity (mm/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hAxes = gca;
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
    legend({'Desired Linear Velocity (X)','Desired Linear Velocity (Y)','Desired Linear Velocity (Z)',...
        'Achieved Linear Velocity (X)','Achieved Linear Velocity (Y)','Achieved Linear Velocity (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Time Warped Desired vs Achieved Linear Velocity (Component-Wise)');
end