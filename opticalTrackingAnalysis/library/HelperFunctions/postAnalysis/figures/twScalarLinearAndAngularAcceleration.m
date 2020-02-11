function fig=twScalarLinearAndAngularAcceleration(figureNum,plotStyle,warpPathAcc,mocapAcc,ndiAcc,mocapRotAcc,ndiRotAcc,isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'defaultAxesColorOrder',[plotStyle.leftColor;plotStyle.rightColor]);
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    subplot(2,1,1);
    plot(mocapAcc(warpPathAcc(:,1)), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.leftColor)
    hold on
    plot(ndiAcc(warpPathAcc(:,2)), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.leftColor)
    ylabel('Linear Acceleration (mm/sec^2)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])
    title('Time Warped Desired vs Achieved Linear Acceleration (Scalar)');
    legend({'Desired Linear Acceleration','Achieved Linear Acceleration'},'Location', 'northeast', 'NumColumns', 2);
    hAxes = gca;
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')

    subplot(2,1,2);
    plot(mocapRotAcc(warpPathAcc(:,1)), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.rightColor)
    hold on
    plot(ndiRotAcc(warpPathAcc(:,2)), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.rightColor)
    ylabel('Angular Acceleration (deg/sec^2)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hAxes = gca; 
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
    legend({'Desired Angular Acceleration','Achieved Angular Acceleration'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Time Warped Desired vs Achieved Angular Acceleration (Scalar)');
end