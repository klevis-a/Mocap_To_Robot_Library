function regeneratePDFFunc(resultsFile,dataFolder,samplingPeriods,robotI,smoothDataFunctions)
    %extract results folder and program name
    [resultsFolder,resultFileName,~]=fileparts(resultsFile);

    programName=strrep(resultFileName,'_sum','');

    %read data capture
    fileStats=readAndProcessCapture(samplingPeriods,robotI,dataFolder,resultsFile,smoothDataFunctions);
    [fileStats,ndiEndPts,jointsEndPts]=determineCaptureTimingXCorr(fileStats,samplingPeriods.mocapSamplingPeriod);

    close all

    %plot scalar position
    figure(1)
    plot(fileStats.ndi.time(ndiEndPts(1):ndiEndPts(2))-fileStats.ndi.time(ndiEndPts(1)),...
        fileStats.ndi.lab.hs.mmdeg.pose.position.scalar(ndiEndPts(1):ndiEndPts(2)));
    hold on
    plot(fileStats.joints.time(jointsEndPts(1):jointsEndPts(2))-fileStats.joints.time(jointsEndPts(1)),...
        fileStats.joints.lab.hs.mmdeg.pose.position.scalar(jointsEndPts(1):jointsEndPts(2)));
    hold on
    plot(fileStats.mocap.time,fileStats.mocap.lab.hs.mmdeg.pose.position.scalar);
    legend('Captured Data', 'Joints Data', 'Mocap Data','Location','southoutside','NumColumns',3);
    title('Scalar position over time');
    scalarPosFile=fullfile(resultsFolder,'scalarPos.pdf');
    print(scalarPosFile, '-dpdf')

    %plot scalar orientation
    figure(2)
    plot(fileStats.ndi.time(ndiEndPts(1):ndiEndPts(2))-fileStats.ndi.time(ndiEndPts(1)),...
        fileStats.ndi.thorax.bone.mmdeg.pose.rotation.scalar(ndiEndPts(1):ndiEndPts(2)));
    hold on
    plot(fileStats.joints.time(jointsEndPts(1):jointsEndPts(2))-fileStats.joints.time(jointsEndPts(1)),...
        fileStats.joints.thorax.bone.mmdeg.pose.rotation.scalar(jointsEndPts(1):jointsEndPts(2)));
    hold on
    plot(fileStats.mocap.time,fileStats.mocap.thorax.bone.mmdeg.pose.rotation.scalar);
    legend('Captured Data', 'Joints Data','Mocap Data','Location','southoutside','NumColumns',3);
    title('Scalar orientation over time');
    scalarOrientFile=fullfile(resultsFolder,'scalarOrient.pdf');
    print(scalarOrientFile, '-dpdf')

    %start plotting individual components for position
    for n=1:3
        figure(n+2)
        plot(fileStats.ndi.time(ndiEndPts(1):ndiEndPts(2))-fileStats.ndi.time(ndiEndPts(1)),...
            fileStats.ndi.lab.hs.mmdeg.pose.position.vector(ndiEndPts(1):ndiEndPts(2),n));
        hold on
        plot(fileStats.joints.time(jointsEndPts(1):jointsEndPts(2))-fileStats.joints.time(jointsEndPts(1)),...
            fileStats.joints.lab.hs.mmdeg.pose.position.vector(jointsEndPts(1):jointsEndPts(2),n));
        hold on
        plot(fileStats.mocap.time,fileStats.mocap.lab.hs.mmdeg.pose.position.vector(:,n));
        legend('Captured Data', 'Joints Data', 'Mocap Data','Location','southoutside','NumColumns',3);
        switch n
            case 1
                title('X');
                xPosFile=fullfile(resultsFolder,'xPos.pdf');
                print(xPosFile, '-dpdf')
            case 2
                title('Y');
                yPosFile=fullfile(resultsFolder,'yPos.pdf');
                print(yPosFile, '-dpdf')
            case 3
                title('Z');
                zPosFile=fullfile(resultsFolder,'zPos.pdf');
                print(zPosFile, '-dpdf')
        end
    end

    %start plotting individual components for rotation
    for n=1:3
        figure(n+5)
        plot(fileStats.ndi.time(ndiEndPts(1):ndiEndPts(2))-fileStats.ndi.time(ndiEndPts(1)),...
            fileStats.ndi.thorax.bone.mmdeg.pose.rotation.vector(ndiEndPts(1):ndiEndPts(2),n));
        hold on
        plot(fileStats.joints.time(jointsEndPts(1):jointsEndPts(2))-fileStats.joints.time(jointsEndPts(1)),...
            fileStats.joints.thorax.bone.mmdeg.pose.rotation.vector(jointsEndPts(1):jointsEndPts(2),n));
        hold on
        plot(fileStats.mocap.time,fileStats.mocap.thorax.bone.mmdeg.pose.rotation.vector(:,n));
        legend('Captured Data', 'Joints Data', 'Mocap Data','Location','southoutside','NumColumns',3);
        switch n
            case 1
                title('X Rot');
                xOrientFile=fullfile(resultsFolder,'xOrient.pdf');
                print(xOrientFile, '-dpdf')
            case 2
                title('Y Rot');
                yOrientFile=fullfile(resultsFolder,'yOrient.pdf');
                print(yOrientFile, '-dpdf')
            case 3
                title('Z Rot');
                zOrientFile=fullfile(resultsFolder,'zOrient.pdf');
                print(zOrientFile, '-dpdf')
        end
    end

    summaryFile=fullfile(resultsFolder,strcat(programName,'_trunc.pdf'));
    if exist(summaryFile, 'file')==2
        delete(summaryFile);
    end
    append_pdfs(summaryFile,scalarPosFile,scalarOrientFile,xPosFile,yPosFile,...
        zPosFile,xOrientFile,yOrientFile,zOrientFile);

    delete(scalarPosFile)
    delete(scalarOrientFile)
    delete(xPosFile)
    delete(yPosFile)
    delete(zPosFile)
    delete(xOrientFile)
    delete(yOrientFile)
    delete(zOrientFile)
end