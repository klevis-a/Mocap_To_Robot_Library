function fig=twScalarPositionAndOrientation(figureNum, plotStyle, warpPathPose, mocapPos, ndiPos, mocapOrient, ndiOrient, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'defaultAxesColorOrder',[plotStyle.leftColor;plotStyle.rightColor]);
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    yyaxis left
    plot(mocapPos(warpPathPose(:,1)), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.leftColor)
    hold on
    yyaxis left
    plot(ndiPos(warpPathPose(:,2)), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.leftColor)
    ylabel('Distance (mm)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hold on
    yyaxis right
    plot(mocapOrient(warpPathPose(:,1)), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.rightColor)
    hold on
    yyaxis right
    plot(ndiOrient(warpPathPose(:,2)), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.rightColor)
    ylabel('Orientation (deg)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hAxes = gca;
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
    legend({'Desired Position','Achieved Position','Desired Orientation','Achieved Orientation'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Time Warped Desired vs Achieved Pose (Scalar)');
%     set(gca,'linewidth',4)
%     set(gca,'fontsize',20)
end