function createSimpleGraphs(fileStats,poseCsRbs,velCsRbs,accCsRbs,...
    visiblePosEndPts,visibleVelEndPts,visibleAccEndPts,printDir,plotDiff,plotPer,performDtw)
    % Initialization for graphs
    %colors for graphs
    plotStyle.leftColor=[7 114 234]./255;
    plotStyle.rightColor=[234 127 7]./255;
    plotStyle.triColor=[236 77 3; 3 236 77; 77 3 236]./255;

    %line widths
    plotStyle.desiredWidth=1.5;
    plotStyle.actualWidth=2;

    %line styles
    plotStyle.desiredStyle='-';
    plotStyle.achievedStyle=':';

    %other parameters
    plotStyle.yLimMult=1.2;
    plotStyle.width=800;
    plotStyle.height=600;
    
    if plotDiff
        graphFunc=@createCheckFileGraphDiff;
        if plotPer
            graphUnits = {'%','%','%','%','%','%'};
        else
            graphUnits = {'deg','deg/sec','deg/sec^2','mm','mm/sec','mm/sec^2'};
        end
    else
        graphFunc=@createCheckFileGraph;
        graphUnits = {'deg','deg/sec','deg/sec^2','mm','mm/sec','mm/sec^2'};
    end
    
    if performDtw
        graphsTitles={'Time Warped Desired vs Achieved Position',...
                    'Time Warped Desired vs Achieved Linear Velocity',...
                    'Time Warped Desired vs Achieved Linear Acceleration',...
                    'Time Warped Desired vs Achieved Orientation',...
                    'Time Warped Desired vs Achieved Angular Velocity',...
                    'Time Warped Desired vs Achieved Angular Acceleration'};
    else
        graphsTitles={'Desired vs Achieved Position',...
                    'Desired vs Achieved Linear Velocity',...
                    'Desired vs Achieved Linear Acceleration',...
                    'Desired vs Achieved Orientation',...
                    'Desired vs Achieved Angular Velocity',...
                    'Desired vs Achieved Angular Acceleration'};
    end
    
    close all
    %Position Components
    fig1=graphFunc(1,plotStyle,graphsTitles{1},sprintf('Distance (%s)',graphUnits{4}),...
        fileStats,{'pose','position'},poseCsRbs,visiblePosEndPts,plotPer);
    set(fig1,'Visible','off');
    
    %Linear Velocity Components
    fig2=graphFunc(2,plotStyle,graphsTitles{2},sprintf('Linear Velocity (%s)',graphUnits{5}),...
        fileStats,{'velocity','linear'},velCsRbs,visibleVelEndPts,plotPer);
    set(fig2,'Visible','off');

    %Linear Acceleration Components
    fig3=graphFunc(3,plotStyle,graphsTitles{3},sprintf('Linear Acceleration (%s)',graphUnits{6}),...
        fileStats,{'acceleration','linear'},accCsRbs,visibleAccEndPts,plotPer);
    set(fig3,'Visible','off');
    
    %Orientation Components
    fig4=graphFunc(4,plotStyle,graphsTitles{4},sprintf('Orientation (%s)',graphUnits{1}),...
        fileStats,{'pose','rotation'},poseCsRbs,visiblePosEndPts,plotPer);
    set(fig4,'Visible','off');
    
    %Angular Velocity Components
    fig5=graphFunc(5,plotStyle,graphsTitles{5},sprintf('Angular Velocity (%s)',graphUnits{2}),...
        fileStats,{'velocity','angular'},velCsRbs,visibleVelEndPts,plotPer);
    set(fig5,'Visible','off');
    
    %Angular Acceleration Components
    fig6=graphFunc(6,plotStyle,graphsTitles{6},sprintf('Angular Acceleration (%s)',graphUnits{3}),...
        fileStats,{'acceleration','angular'},accCsRbs,visibleAccEndPts,plotPer);
    set(fig6,'Visible','off');
    
    if ~isempty(printDir)
        %create directory to store graphs if it doesn't already exist
        resDir=fullfile(printDir,fileStats.programName);
        if ~exist(resDir, 'dir')
          mkdir(resDir);
        end
        print(fig1,fullfile(resDir,num2str(1)), '-dpng');
        print(fig2,fullfile(resDir,num2str(2)), '-dpng');
        print(fig3,fullfile(resDir,num2str(3)), '-dpng');
        print(fig4,fullfile(resDir,num2str(4)), '-dpng');
        print(fig5,fullfile(resDir,num2str(5)), '-dpng');
        print(fig6,fullfile(resDir,num2str(6)), '-dpng');
    end
end