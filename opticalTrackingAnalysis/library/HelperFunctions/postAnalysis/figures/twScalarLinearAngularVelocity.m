function fig=twScalarLinearAngularVelocity(figureNum, plotStyle, warpPathVel, mocapVel, ndiVel, mocapRotVel, ndiRotVel, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'defaultAxesColorOrder',[plotStyle.leftColor;plotStyle.rightColor]);
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    subplot(2,1,1);
    plot(mocapVel(warpPathVel(:,1)), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.leftColor)
    hold on
    plot(ndiVel(warpPathVel(:,2)), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.leftColor)
    ylabel('Linear Velocity (mm/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])
    title('Time Warped Desired vs Achieved Linear Velocity (Scalar)');
    legend({'Desired Linear Velocity','Achieved Linear Velocity'},'Location', 'northeast', 'NumColumns', 2);
    hAxes = gca;
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
%     set(gca,'linewidth',4)
%     set(gca,'fontsize',20)

    subplot(2,1,2);
    plot(mocapRotVel(warpPathVel(:,1)), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.rightColor)
    hold on
    plot(ndiRotVel(warpPathVel(:,2)), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.rightColor)
    ylabel('Angular Velocity (deg/sec)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hAxes = gca; 
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
    legend({'Desired Angular Velocity','Achieved Angular Velocity'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Time Warped Desired vs Achieved Angular Velocity (Scalar)');
%     set(gca,'linewidth',4)
%     set(gca,'fontsize',20)
end