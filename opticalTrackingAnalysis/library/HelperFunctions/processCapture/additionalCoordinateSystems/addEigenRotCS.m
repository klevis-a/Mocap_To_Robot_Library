function captureInfo=addEigenRotCS(captureInfo)
    %calculate the eigen coordinate system for the hemisphere position
    %V is the rotation matrix from lab to the eigen coordinate system, so
    %V is the transformation matrix from eigen to lab
    %hence V' is the transformation matrix from lab to eigen
    [~,framesDx]=cumFrameDiff(captureInfo.mocap.thorax.bone.pose.frames);
    framesDx=prependIdentity(framesDx);
    angVel=computeAngVelocity(captureInfo.mocap.time,framesDx);
    angAcc=velocity(captureInfo.mocap.time,angVel);
    poseVector=frameToVectorDiff(framesDx);
    [~,~,V]=svd(poseVector(:,4:6));
    [~,~,Vv]=svd(angVel);
    [~,~,Va]=svd(angAcc);
    TLtoE=ht(V',[0 0 0]);
    TLtoEv=ht(Vv',[0 0 0]);
    TLtoEa=ht(Va',[0 0 0]);
    captureInfo=addCS(captureInfo,TLtoE,'thorax','eigenRot');
    captureInfo=addCS(captureInfo,TLtoEv,'thorax','eigenRotVel');
    captureInfo=addCS(captureInfo,TLtoEa,'thorax','eigenRotAcc');
    captureInfo.referenceCS{end+1}='eigenRot';
    captureInfo.referenceCS{end+1}='eigenRotVel';
    captureInfo.referenceCS{end+1}='eigenRotAcc';
end