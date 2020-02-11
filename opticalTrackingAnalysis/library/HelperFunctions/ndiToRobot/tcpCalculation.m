function [tcp,radiusDiff,maxRes,rmsRes]=tcpCalculation(pos6Dfile,tm,r0)
    %read calibration file and process data
    [~,data,numRigidBodies] = readNDI6D(pos6Dfile);

    if numRigidBodies>1
        hs = removeBlankNdiData(squeeze(data(:,:,2)));
    else
        hs=removeBlankData(data);
    end

    hsPos = squeeze(hs(:,1:3));
    hsOrient = squeeze(hs(:,4:7));
    numFrames = size(hsPos,1);

    %do a sphere fit
    [sphereCenter, sphereRadius, res] = spherefit(hsPos);
    maxRes=max(abs(res));
    rmsRes=rms(res);

    %normalize vectors so they start from center of sphere
    hsPosCenter = hsPos - sphereCenter';

    %see my notebook for documentation
    hsPosRobotNoRot = zeros(3,numFrames);
    for n=1:numFrames
        hsPosRobot=tm*hsPosCenter(n,:)';
        hsPosRobotNoRot(:,n) = r0'*(tm*quat2rotm(hsOrient(n,:))*quat2rotm(hsOrient(1,:))'*tm')'*hsPosRobot;
    end

    tcp = mean(hsPosRobotNoRot,2);
    tcpRadius = sqrt(sum(tcp.^2));
    radiusDiff = tcpRadius-sphereRadius;
end