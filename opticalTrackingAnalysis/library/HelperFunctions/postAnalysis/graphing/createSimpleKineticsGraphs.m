function createSimpleKineticsGraphs(fileStats,visibleAxialForceEndPts,visibleBendingMomentEndPts,visibleAxialMomentEndPts,visibleForcesEndPts,visibleMomentsEndPts,printDir)
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
    
    close all
    fig1=kineticsGraph(1,plotStyle,'Axial Force','Force (N)',fileStats.kinetics.warpPaths.axialForce,fileStats.kinetics.mocap.axialForce,fileStats.kinetics.ndi.axialForce,visibleAxialForceEndPts);
    if fileStats.activity==Activities.JO_free
        annotateKinetics_JO(fileStats.kinetics.mocap.axialForce,fileStats.kinetics.ndi.axialForce,fileStats.kinetics.diff.axialForce,fileStats.kinetics.warpPaths.axialForce,plotStyle,fileStats.kinetics.endPts.axialForce,visibleAxialForceEndPts);
    else
        annotateKinetics(fileStats.kinetics.mocap.axialForce,fileStats.kinetics.ndi.axialForce,fileStats.kinetics.diff.axialForce,fileStats.kinetics.warpPaths.axialForce,plotStyle,fileStats.kinetics.endPts.axialForce,visibleAxialForceEndPts);
    end
    set(fig1,'Visible','off');
    
    fig2=kineticsGraph(2,plotStyle,'Bending Moment','Moment (Nm)',fileStats.kinetics.warpPaths.bendingMoment,fileStats.kinetics.mocap.bendingMoment,fileStats.kinetics.ndi.bendingMoment,visibleBendingMomentEndPts);
    annotateKinetics(fileStats.kinetics.mocap.bendingMoment,fileStats.kinetics.ndi.bendingMoment,fileStats.kinetics.diff.bendingMoment,fileStats.kinetics.warpPaths.bendingMoment,plotStyle,fileStats.kinetics.endPts.bendingMoment,visibleBendingMomentEndPts);
    set(fig2,'Visible','off');
    
    fig3=kineticsGraph(3,plotStyle,'Axial Moment','Moment (Nm)',fileStats.kinetics.warpPaths.axialMoment,fileStats.kinetics.mocap.axialMoment,fileStats.kinetics.ndi.axialMoment,visibleAxialMomentEndPts);
    if fileStats.activity==Activities.IR90
        annotateKinetics_IR(fileStats.kinetics.mocap.axialMoment,fileStats.kinetics.ndi.axialMoment,fileStats.kinetics.diff.axialMoment,fileStats.kinetics.warpPaths.axialMoment,plotStyle,fileStats.kinetics.endPts.axialMoment,visibleAxialMomentEndPts);
    else
        annotateKinetics(fileStats.kinetics.mocap.axialMoment,fileStats.kinetics.ndi.axialMoment,fileStats.kinetics.diff.axialMoment,fileStats.kinetics.warpPaths.axialMoment,plotStyle,fileStats.kinetics.endPts.axialMoment,visibleAxialMomentEndPts);
    end
    set(fig3,'Visible','off');
    
    [fig4,subPlots]=kineticsGraphVector(4,plotStyle,'Forces','Force (N)',fileStats.kinetics.warpPaths.forces,fileStats.kinetics.mocap.forces.vector,fileStats.kinetics.ndi.forces.vector,visibleForcesEndPts);
    for n=1:3
        annotateKinetics(fileStats.kinetics.mocap.forces.vector(:,n),fileStats.kinetics.ndi.forces.vector(:,n),fileStats.kinetics.diff.forces(n),fileStats.kinetics.warpPaths.forces,plotStyle,fileStats.kinetics.endPts.forces,visibleForcesEndPts,subPlots(n));
    end
    set(fig4,'Visible','off');
    
    [fig5,subPlots]=kineticsGraphVector(5,plotStyle,'Moments','Moment (Nm)',fileStats.kinetics.warpPaths.moments,fileStats.kinetics.mocap.moments.vector,fileStats.kinetics.ndi.moments.vector,visibleMomentsEndPts);
    for n=1:3
        annotateKinetics(fileStats.kinetics.mocap.moments.vector(:,n),fileStats.kinetics.ndi.moments.vector(:,n),fileStats.kinetics.diff.moments(n),fileStats.kinetics.warpPaths.moments,plotStyle,fileStats.kinetics.endPts.moments,visibleMomentsEndPts,subPlots(n));
    end
    set(fig4,'Visible','off');
    
    fig6=kineticsGraph(6,plotStyle,'Force','Force (N)',fileStats.kinetics.warpPaths.forces,fileStats.kinetics.mocap.forces.scalar,fileStats.kinetics.ndi.forces.scalar,visibleForcesEndPts);
    annotateKinetics(fileStats.kinetics.mocap.forces.scalar,fileStats.kinetics.ndi.forces.scalar,fileStats.kinetics.diff.forces(4),fileStats.kinetics.warpPaths.forces,plotStyle,fileStats.kinetics.endPts.forces,visibleForcesEndPts);
    set(fig6,'Visible','off');
    
    fig7=kineticsGraph(7,plotStyle,'Moment','Moment (Nm)',fileStats.kinetics.warpPaths.moments,fileStats.kinetics.mocap.moments.scalar,fileStats.kinetics.ndi.moments.scalar,visibleMomentsEndPts);
    annotateKinetics(fileStats.kinetics.mocap.moments.scalar,fileStats.kinetics.ndi.moments.scalar,fileStats.kinetics.diff.moments(4),fileStats.kinetics.warpPaths.moments,plotStyle,fileStats.kinetics.endPts.moments,visibleMomentsEndPts);
    set(fig7,'Visible','off');
    
    fig8=kineticsGraph(8,plotStyle,'Bending Moment Thorax','Moment (Nm)',fileStats.kinetics.warpPaths.thorax.bendingMoment,fileStats.kinetics.mocap.thorax.bendingMoment,fileStats.kinetics.ndi.thorax.bendingMoment,visibleBendingMomentEndPts);
    annotateKinetics(fileStats.kinetics.mocap.thorax.bendingMoment,fileStats.kinetics.ndi.thorax.bendingMoment,fileStats.kinetics.diff.thorax.bendingMoment,fileStats.kinetics.warpPaths.thorax.bendingMoment,plotStyle,fileStats.kinetics.endPts.bendingMoment,visibleBendingMomentEndPts);
    set(fig8,'Visible','off');
    
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
        print(fig7,fullfile(resDir,num2str(7)), '-dpng');
        print(fig8,fullfile(resDir,num2str(8)), '-dpng');
    end
end