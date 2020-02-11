function fig=angularAccelerationComponents(figureNum,plotStyle,mocapTime,angAccelerationMocap,angAccelerationNdi,isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    subplot(3,1,1)
    plot(mocapTime,angAccelerationMocap(:,1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    subplot(3,1,2)
    plot(mocapTime,angAccelerationMocap(:,2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    subplot(3,1,3)
    plot(mocapTime,angAccelerationMocap(:,3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))

    subplot(3,1,1)
    hold on
    plot(mocapTime,angAccelerationNdi(:,1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*1.5])
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Angular Acceleration (X)','Achieved Angular Acceleration (X)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')

    subplot(3,1,2)
    hold on
    plot(mocapTime,angAccelerationNdi(:,2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*1.1])
    hAxes = gca;
    set(hAxes,'box','off')
    legend({'Desired Angular Acceleration (Y)','Achieved Angular Acceleration (Y)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')

    subplot(3,1,3)
    hold on
    plot(mocapTime,angAccelerationNdi(:,3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))

    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*1.5])
    xlabel('Time (s)');
    hAxes = gca;  
    set(hAxes,'box','off')
    legend({'Desired Angular Acceleration (Z)','Achieved Angular Acceleration (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    suptitle('Desired vs Achieved Angular Acceleration (Component-Wise)');
    
    if ~isVisible
        set(fig,'Visible','off');
    end
end