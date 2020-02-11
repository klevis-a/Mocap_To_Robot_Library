function fig=twPositionComponents(figureNum, plotStyle, warpPathPose, mocapPosVec, ndiPosVec, isVisible)
    fig=figure(figureNum);
    if ~isVisible
        set(fig,'Visible','off');
    end
    set(fig,'color','w');
    set(fig,'PaperPositionMode','auto')
    set(fig, 'Position', [300 300 plotStyle.width plotStyle.height])

    plot(mocapPosVec(warpPathPose(:,1),1), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(mocapPosVec(warpPathPose(:,1),2), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(mocapPosVec(warpPathPose(:,1),3), plotStyle.desiredStyle, 'LineWidth', plotStyle.desiredWidth, 'Color', plotStyle.triColor(3,:))
    hold on
    plot(ndiPosVec(warpPathPose(:,2),1), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(1,:))
    hold on
    plot(ndiPosVec(warpPathPose(:,2),2), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(2,:))
    hold on
    plot(ndiPosVec(warpPathPose(:,2),3), plotStyle.achievedStyle, 'LineWidth', plotStyle.actualWidth, 'Color', plotStyle.triColor(3,:))
    ylabel('Distance (mm)');
    YLimits=ylim;
    ylim([YLimits(1) YLimits(2)*plotStyle.yLimMult])

    hAxes = gca;
    hAxes.XAxis.Visible = 'off';
    set(hAxes,'box','off')
    legend({'Desired Position (X)','Desired Position (Y)','Desired Position (Z)',...
        'Achieved Position (X)','Achieved Position (Y)','Achieved Position (Z)'},'Location', 'northeast', 'NumColumns', 2);
    legend('boxoff')
    title('Time Warped Desired vs Achieved Position (Component-Wise)');
end