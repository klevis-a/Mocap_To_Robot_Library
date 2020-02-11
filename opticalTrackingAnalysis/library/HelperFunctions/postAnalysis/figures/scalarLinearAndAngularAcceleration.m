function fig=scalarLinearAndAngularAcceleration(figureNum,plotStyle,mocapTime,mocapAcc,ndiAcc,mocapRotAcc,ndiRotAcc,isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'defaultAxesColorOrder',[plotStyle.leftColor;plotStyle.rightColor]);
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    subplot(2,1,1);
    plot(mocapTime, mocapAcc, plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.leftColor)
    hold on
    plot(mocapTime, ndiAcc, plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.leftColor)
    ylabel('Linear Acceleration (mm/sec^2)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])
    title('Desired vs Achieved Linear Acceleration (Scalar)');
    legend({'Desired Linear Acceleration','Achieved Linear Acceleration'},'Location', 'northeast', 'NumColumns', 2);
    hAxes = gca;
    set(hAxes,'box','off')
    xlabel('Time (s)');

    subplot(2,1,2);
    plot(mocapTime, mocapRotAcc, plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.rightColor)
    hold on
    plot(mocapTime, ndiRotAcc, plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.rightColor)
    ylabel('Angular Acceleration (deg/sec^2)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    xlabel('Time (s)');
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Angular Acceleration','Achieved Angular Acceleration'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Desired vs Achieved Angular Acceleration (Scalar)');
end