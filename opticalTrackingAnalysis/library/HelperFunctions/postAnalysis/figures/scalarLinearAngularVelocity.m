function fig=scalarLinearAngularVelocity(figureNum, plotStyle, mocapTime, mocapVel, ndiVel, mocapRotVel, ndiRotVel, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'defaultAxesColorOrder',[plotStyle.leftColor;plotStyle.rightColor]);
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    subplot(2,1,1);
    plot(mocapTime, mocapVel, plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.leftColor)
    hold on
    plot(mocapTime, ndiVel, plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.leftColor)
    ylabel('Linear Velocity (mm/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])
    title('Desired vs Achieved Linear Velocity (Scalar)');
    legend({'Desired Linear Velocity','Achieved Linear Velocity'},'Location', 'northeast', 'NumColumns', 2);
    hAxes = gca;
    set(hAxes,'box','off')
    xlabel('Time (s)');

    subplot(2,1,2);
    plot(mocapTime,mocapRotVel, plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.rightColor)
    hold on
    plot(mocapTime,ndiRotVel, plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.rightColor)
    ylabel('Angular Velocity (deg/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    xlabel('Time (s)');
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Angular Velocity','Achieved Angular Velocity'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Desired vs Achieved Angular Velocity (Scalar)');
end