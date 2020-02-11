function fig=scalarPositionAndOrientation(figureNum, plotStyle, mocapTime, mocapPos, ndiPos, mocapOrient, ndiOrient, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'defaultAxesColorOrder',[plotStyle.leftColor;plotStyle.rightColor]);
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    yyaxis left
    plot(mocapTime,mocapPos, plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.leftColor)
    hold on
    yyaxis left
    plot(mocapTime,ndiPos, plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.leftColor)
    ylabel('Distance (mm)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hold on
    yyaxis right
    plot(mocapTime,mocapOrient, plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.rightColor)
    hold on
    yyaxis right
    plot(mocapTime,ndiOrient, plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.rightColor)
    ylabel('Orientation (deg)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    xlabel('Time (s)');
    hAxes = gca;
    hAxes.XRuler.Axle.LineStyle = 'none';  
    set(hAxes,'box','off')
    legend({'Desired Position','Achieved Position','Desired Orientation','Achieved Orientation'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Desired vs Achieved Pose (Scalar)');
%     set(gca,'linewidth',4)
%     set(gca,'fontsize',20)
end