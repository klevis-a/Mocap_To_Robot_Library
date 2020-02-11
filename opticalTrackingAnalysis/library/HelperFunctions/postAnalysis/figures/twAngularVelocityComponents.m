function fig=twAngularVelocityComponents(figureNum, plotStyle, warpPathVel, angVelocityMocap, angVelocityNdi,isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    plot(angVelocityMocap(warpPathVel(:,1),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(angVelocityMocap(warpPathVel(:,1),2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(angVelocityMocap(warpPathVel(:,1),3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))
    hold on
    plot(angVelocityNdi(warpPathVel(:,2),1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(angVelocityNdi(warpPathVel(:,2),2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(angVelocityNdi(warpPathVel(:,2),3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))
    ylabel('Angular Velocity (deg/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hAxes = gca;
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
    legend({'Desired Angular Velocity (X)','Desired Angular Velocity (Y)','Desired Angular Velocity (Z)',...
        'Achieved Angular Velocity (X)','Achieved Angular Velocity (Y)','Achieved Angular Velocity (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Time Warped Desired vs Achieved Angular Velocity (Component-Wise)');
end