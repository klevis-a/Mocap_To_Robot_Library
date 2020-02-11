function fig=twLinearAccelerationComponents(figureNum,plotStyle,warpPathAcc,mocapAccVec,ndiAccVec,isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    subplot(3,1,1)
    plot(mocapAccVec(warpPathAcc(:,1),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    subplot(3,1,2)
    plot(mocapAccVec(warpPathAcc(:,1),2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    subplot(3,1,3)
    plot(mocapAccVec(warpPathAcc(:,1),3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))

    subplot(3,1,1)
    hold on
    plot(ndiAccVec(warpPathAcc(:,2),1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*1.5])
    hAxes = gca;
    set(hAxes,'box','off')
    hAxes.XAxis.Visible = 'off';
    legend({'Desired Linear Acceleration (X)','Achieved Linear Acceleration (X)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')

    subplot(3,1,2)
    hold on
    plot(ndiAccVec(warpPathAcc(:,2),2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*1.1])
    hAxes = gca;
    set(hAxes,'box','off')
    hAxes.XAxis.Visible = 'off';
    legend({'Desired Linear Acceleration (Y)','Achieved Linear Acceleration (Y)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')

    subplot(3,1,3)
    hold on
    plot(ndiAccVec(warpPathAcc(:,2),3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*1.5])
    hAxes = gca;  
    set(hAxes,'box','off')
    hAxes.XAxis.Visible = 'off';
    legend({'Desired Linear Acceleration (Z)','Achieved Linear Acceleration (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    suptitle('Time Warped Desired vs Achieved Linear Acceleration (Component-Wise)');
    if ~isVisible
        set(fig,'Visible','off');
    end
end